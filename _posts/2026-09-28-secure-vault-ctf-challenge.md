---
title: "Secure Vault - CTF Challenge: Android Deep Link & WebView Host Validation Audit"
date: 2026-09-28 12:00:00 +0100
categories: ["Mobile Security", "MobileHackingLab"]
tags: ["android", "mobilehackinglab", "webview", "deeplink", "static-analysis", "reverse-engineering"]
image:
  path: /assets/images/secure-vault/secure_vault_banner.png
  alt: Secure Vault CTF Challenge
---

![Secure Vault Banner](/assets/images/secure-vault/secure_vault_banner.png){: .shadow .rounded-10 }

## Introduction

**MHC Corp** recently hardened their employee portal application (`com.poc.mhcctf`) with a feature called **Secure Vault**. 

According to the release notes:
> The Secure Vault now validates that any externally supplied URL belongs to an approved corporate hostname before loading it into the WebView.

### Challenge Objective
* Analyze the application architecture and component interactions to understand how the Secure Vault validates URLs and manages sensitive authentication tokens.
* Identify the deep link routing and understand how authentication data is passed to external or internal endpoints.

### Tools Used
* **Decompiler**: JADX / JADX-GUI
* **Device / Emulator**: Android 14+ test environment with ADB

---

## 1. Static Analysis: Authentication & Navigation Flow

### Login Analysis (`MainActivity.java`)
Auditing `MainActivity.java` reveals that the login flow does not make remote API calls or generate HTTP network requests. Authentication is performed entirely client-side:

```java
String strTrim = textInputEditText3.getText() != null ? textInputEditText3.getText().toString().trim() : "";
String strTrim2 = textInputEditText4.getText() != null ? textInputEditText4.getText().toString().trim() : "";

if (!"admin".equals(strTrim) || !"mhcctf".equals(strTrim2)) {
    textView2.setText(R.string.error_invalid_credentials);
    textView2.setVisibility(View.VISIBLE);
} else {
    Intent intent = new Intent(mainActivity, (Class<?>) DashboardActivity.class);
    intent.putExtra("extra_username", strTrim);
    mainActivity.startActivity(intent);
    mainActivity.finish();
}
```

* **Username**: `admin`
* **Password**: `mhcctf`

![MainActivity Hardcoded Credentials](/assets/images/secure-vault/main_activity_creds.png){: .shadow .rounded-10 }

Entering these credentials transitions directly into `DashboardActivity` without network activity.

---

## 2. Manifest & Component Exposure

In `AndroidManifest.xml`, we observe an exported Activity configured to receive deep links:

```xml
<activity
    android:name="com.poc.mhcctf.DeeplinkManagerActivity"
    android:theme="@android:style/Theme.Translucent.NoTitleBar"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data
            android:scheme="mhcctf"
            android:host="app"/>
    </intent-filter>
</activity>

<activity
    android:name="com.poc.mhcctf.VaultActivity"
    android:exported="false"/>
```

* **Entry Point**: `DeeplinkManagerActivity` is exported (`android:exported="true"`) and handles the custom URI scheme `mhcctf://app/...`.
* **Target Activity**: `VaultActivity` is unexported (`android:exported="false"`), but can be invoked indirectly by `DeeplinkManagerActivity`.

---

## 3. Deep Link Parameter Handling (`DeeplinkManagerActivity.java`)

When `DeeplinkManagerActivity` receives an incoming Intent, it extracts path and query parameters:

```java
Uri data = getIntent().getData();
if (data == null) {
    finish();
    return;
}
String path = data.getPath();
String queryParameter = data.getQueryParameter("url");

if (path.equals("/help")) {
    startActivity(new Intent(this, HelpActivity.class));
} else if (path.equals("/vault")) {
    Intent intent = new Intent(this, VaultActivity.class);
    if (queryParameter != null && !queryParameter.isEmpty()) {
        intent.putExtra("extra_url", queryParameter);
    }
    startActivity(intent);
}
finish();
```

* Passing `mhcctf://app/vault?url=<TARGET_URL>` forwards the `url` parameter directly into `VaultActivity` as the `extra_url` string extra.

---

## 4. WebView Architecture & Hostname Validation (`VaultActivity.java`)

In `VaultActivity`, the application configures a `WebView` and inspects the supplied URL:

```java
public static final Set f2058C = Collections.unmodifiableSet(
    new HashSet(Arrays.asList("portal.mhccorp.com", "vault.mhc-internal"))
);
```

### URL Evaluation Logic:
```java
String stringExtra = getIntent().getStringExtra("extra_url");

if (stringExtra == null || stringExtra.isEmpty()) {
    // Falls back to spawning an internal mock server on 127.0.0.1:8080
    new Thread(new e(this, 0)).start();
    return;
}

try {
    String host = Uri.parse(stringExtra).getHost();
    if (host != null && !host.isEmpty()) {
        zContains = set.contains(host.toLowerCase());
    }
} catch (Exception e2) {
    Log.e("VaultActivity", "isHostAllowed: failed to parse URL: " + e2.getMessage());
}

if (zContains) {
    HashMap map = new HashMap();
    map.put("Authorization", "Bearer MHL{...}");
    this.f2059A.loadUrl(stringExtra, map);
    return;
}

// Fallback if host check fails:
new Thread(new e(this, 0)).start();
```

### Observations:
1. **JavaScript Bridge Exposure**:
   ```java
   this.f2059A.addJavascriptInterface(new MhcVaultBridge(this, ...), "MhcVaultBridge");
   ```
   The `MhcVaultBridge` exposes `getVaultToken()`, making sensitive token data accessible to JavaScript running within the loaded page.
2. **Sensitive Headers on External Requests**:
   When `zContains` evaluates to true, the application attaches an `Authorization` header containing the authentication bearer token to the HTTP GET request:
   ```java
   map.put("Authorization", "Bearer MHL{dummy_flag_replace_with_real_one}");
   this.f2059A.loadUrl(stringExtra, map);
   ```

   ![VaultActivity Sensitive Flag Header](/assets/images/secure-vault/vault_activity_flag.png){: .shadow .rounded-10 }

   > **Note on Flags**: In the offline challenge APK (`secure-vault-dummy.apk`), this contains the placeholder `MHL{dummy_flag_replace_with_real_one}`. On the live cloud lab environment, the backend dynamically supplies the real target flag upon successful challenge completion.

3. **Internal Mock Server Fallback**:
   When no URL or an unapproved host is supplied, the app launches an internal thread binding to `127.0.0.1:8080` to render a local placeholder card.

---

## 5. Security Recommendations & Defensive Hardening

1. **Avoid Exposing Sensitive Tokens via Custom Headers to Dynamic URLs**:
   Custom HTTP headers appended via `loadUrl()` can leak if subsequent redirects occur or if host validation fails.
2. **Strict URI Parser Validation**:
   `Uri.parse().getHost()` can yield unexpected behavior when processing ambiguous URIs with complex authority segments, credentials, or custom schemes. Ensure robust URL canonicalization and strict regex or URI builders are used.
3. **Restrict JavaScript Bridges**:
   Limit `@JavascriptInterface` exposure strictly to trusted local asset pages (`file:///android_asset/`) or enforce strict origin verification before injecting bridge interfaces.
