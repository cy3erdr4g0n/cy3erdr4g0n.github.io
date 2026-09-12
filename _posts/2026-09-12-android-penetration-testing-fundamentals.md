---
title: "Android Penetration Testing Fundamentals: Static, Dynamic & SSL Pinning Bypass"
date: 2026-09-12 10:00:00 +0100
categories: ["Articles", "Mobile Security"]
tags: ["android", "mobile-security", "frida", "objection", "jadx", "ssl-pinning", "burp-suite"]
---

Mobile application security testing has become a crucial domain in offensive security. Modern mobile applications interact with complex cloud backends, store sensitive user credentials locally, and rely heavily on client-side controls. 

In this comprehensive guide, we will walk through the complete workflow of an **Android Application Penetration Test**: setting up a test lab, performing static analysis with JADX and APKTool, intercepting encrypted traffic with Burp Suite, bypassing SSL Pinning, and executing dynamic runtime hooking using Frida and Objection.

---

## 1. Prerequisites & Lab Setup

> **Full Lab Setup Guide**: For an in-depth walkthrough on configuring Android Studio AVD with writable system partitions, Docker-Android containers, physical Magisk devices, and Burp system CAs, see:
> 👉 **[Setting Up My Personal Android Penetration Testing Lab: A Complete Practical Guide](/posts/setting-up-android-pentesting-lab/)**
{: .prompt-info }

An effective mobile security lab requires the ability to inspect both the filesystem and runtime memory of the application.

### Key Tools
- **ADB (Android Debug Bridge)**: Command-line tool to communicate with an emulator or rooted device.
- **JADX / JADX-GUI**: DEX to Java decompiler.
- **APKTool**: Reverse engineering tool for decoding resources and disassembling Smali code.
- **Burp Suite**: Web proxy to intercept HTTP/HTTPS traffic.
- **Frida**: Dynamic code instrumentation toolkit.
- **Objection**: Runtime mobile security assessment framework powered by Frida.

### Android Device / Emulator
Using an emulator without Google Play services (or an AVD with Google APIs) allows you to gain root access easily:
```bash
# Check connected devices
adb devices

# Gain root shell on emulator
adb root
adb shell
```

---

## 2. Phase 1: Static Analysis (Reverse Engineering)

Static analysis involves pulling the APK from the device and reviewing its structure, configurations, and source code without executing it.

### Extracting the Target APK
If the application is already installed on your device:
```bash
# Find package name
adb shell pm list packages | grep target

# Get file path of the APK
adb shell pm path com.target.app

# Pull APK to local workstation
adb pull /data/app/~~.../com.target.app/base.apk target.apk
```

### Decompiling with APKTool
APKTool decodes XML resources and translates DEX bytecode into readable Smali code:
```bash
apktool d target.apk -o target_decompiled
```

Inspect `AndroidManifest.xml` for low-hanging security issues:
- **`android:debuggable="true"`**: Allows an attacker to attach a debugger (`jdb`) and inspect memory.
- **`android:allowBackup="true"`**: Allows extracting app data via `adb backup`.
- **Exported Components**: Any Activity, Service, Broadcast Receiver, or Content Provider with `android:exported="true"` (or an intent-filter without explicit `exported="false"`) can be invoked by other applications on the device.

```bash
# Example: Launching an exported vulnerable activity directly via ADB
adb shell am start -n com.target.app/.ui.SecretAdminActivity
```

### Decompiling Source Code with JADX
Launch `jadx-gui target.apk` to inspect decompiled Java code:

Look out for:
1. **Hardcoded Secrets**: API keys, hardcoded encryption keys (AES/DES), AWS/Firebase credentials:
   ```bash
   grep -rn "AWS_SECRET" target_decompiled/
   grep -rn "Bearer " target_decompiled/
   ```
2. **Insecure Storage Mechanisms**: Writing sensitive data to external storage (`getExternalStorageDirectory()`) or unencrypted `SharedPreferences`.
3. **Insecure WebViews**: `setJavaScriptEnabled(true)` combined with `addJavascriptInterface()` without proper input sanitization.

---

## 3. Phase 2: Intercepting Traffic & Bypassing SSL Pinning

Android 7.0 (API Level 24) introduced changes to how the operating system trusts user-installed Certificate Authorities (CAs). Apps by default ignore user certificates installed in the Android settings.

### Installing Burp CA as a System Certificate
To intercept all HTTPS traffic without application modification, install the Burp certificate into the system trust store:

1. Export Burp CA in DER format, convert it to PEM:
   ```bash
   openssl x509 -inform DER -in burp.der -out burp.pem
   ```
2. Calculate certificate hash:
   ```bash
   HASH=$(openssl x509 -inform PEM -subject_hash_old -in burp.pem | head -n 1)
   mv burp.pem ${HASH}.0
   ```
3. Push to Android system store (requires root):
   ```bash
   adb root
   adb remount
   adb push ${HASH}.0 /system/etc/security/cacerts/
   adb shell chmod 644 /system/etc/security/cacerts/${HASH}.0
   ```

### Bypassing SSL Pinning with Frida
When an application implements SSL Pinning (e.g., OkHttp `CertificatePinner`, TrustKit, or custom network security configs), it will reject the Burp proxy certificate even if installed in the system store.

#### 1. Setup Frida Server on Device
Download matching `frida-server` binary for your device architecture (e.g. `x86_64` or `arm64`):
```bash
# Push and execute frida-server
adb push frida-server /data/local/tmp/
adb shell "chmod 755 /data/local/tmp/frida-server"
adb shell "/data/local/tmp/frida-server &"

# Verify frida can list processes
frida-ps -U
```

#### 2. Universal SSL Pinning Bypass with Frida
Use Frida CodeShare to dynamically hook and disable certificate verification at runtime:
```bash
frida -U --codeshare pcipolloni/universal-android-ssl-pinning-bypass-with-frida -f com.target.app
```

#### 3. Bypassing with Objection
Objection provides an all-in-one automated environment:
```bash
# Spawn application under Objection
objection -g com.target.app explore

# Run inside objection prompt:
android sslpinning disable
```

Once executed, open Burp Suite—all API calls, headers, authentication payloads, and tokens will be visible in plain HTTP/JSON in the HTTP history tab!

---

## 4. Phase 3: Dynamic Runtime Hooking & Tampering

Dynamic instrumentation allows you to modify application logic on the fly without modifying or resigning the APK.

### Root Detection Bypass
If the application refuses to run on a rooted emulator or test device, you can patch the detection logic:

```bash
# Via Objection
android root disable
```

Or via custom Frida script:
```javascript
Java.perform(function () {
    var RootDetection = Java.use("com.target.app.util.SecurityUtils");
    
    RootDetection.isDeviceRooted.implementation = function () {
        console.log("[*] Root detection call intercepted! Returning false.");
        return false;
    };
});
```

Execute your custom script:
```bash
frida -U -f com.target.app -l bypass_root.js
```

### Authentication Logic Bypass
Imagine the application validates a 4-digit PIN code client-side before revealing sensitive tokens:

```javascript
Java.perform(function () {
    var AuthManager = Java.use("com.target.app.auth.PinValidator");

    AuthManager.verifyPin.implementation = function (enteredPin) {
        console.log("[+] User entered PIN: " + enteredPin);
        console.log("[+] Forcing return value to TRUE");
        return true; // Force success regardless of PIN
    };
});
```

---

## 5. Phase 4: Local Data Storage & Secrets Inspection

Inspect the application’s private data directory:
```bash
adb shell
su
cd /data/data/com.target.app/
```

Key directories to audit:
- `shared_prefs/`: Look for sensitive cleartext JSON or XML storing tokens, session IDs, and user settings:
  ```bash
  cat shared_prefs/*.xml
  ```
- `databases/`: Check SQLite database files for cleartext PII, cached credentials, or credit card information:
  ```bash
  sqlite3 app_database.db
  .tables
  SELECT * FROM user_session;
  ```
- `cache/`: Review cached HTTP responses and temporary files.

---

## 6. Penetration Testing Checklist Summary

| Assessment Area | Key Checks | Primary Tools |
| :--- | :--- | :--- |
| **Manifest Auditing** | `debuggable`, `allowBackup`, Exported Components, Deep Links | `apktool`, `jadx` |
| **Static Code Review** | Hardcoded secrets, insecure crypto (ECB mode, static keys), cleartext traffic | `jadx-gui`, `ripgrep` |
| **Network Security** | Missing/bypassable SSL Pinning, sensitive data in query params, weak ciphers | `Burp Suite`, `Frida`, `Objection` |
| **Runtime Protections** | Root detection, integrity checks, emulator detection | `Frida`, `Magisk` |
| **Local Data Storage** | Cleartext SharedPreferences, unencrypted SQLite DBs, world-readable files | `adb`, `sqlite3` |
| **Backend API Security** | IDOR, BOLA, Mass Assignment, Broken Object Level Authorization | `Burp Suite Repeater / Intruder` |

---

## Conclusion

Mobile application penetration testing blends traditional API testing with client-side reverse engineering and dynamic binary manipulation. By mastering static inspection with **JADX**, runtime hooking with **Frida**, and traffic interception with **Burp Suite**, you can uncover high-impact vulnerabilities before attackers do.

Happy Hacking! 🐉
