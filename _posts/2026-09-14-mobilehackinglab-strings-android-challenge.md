---
title: "MobileHackingLab: Strings – Exported Intents, Cryptographic Gatekeepers & Runtime Frida Instrumentation"
date: 2026-09-14 22:00:00 +0100
categories: ["Mobile Security", "MobileHackingLab"]
tags: ["android", "reverse-engineering", "frida", "intent-filter", "aes-cbc", "jadx", "sharedpreferences", "mobilehackinglab"]
image:
  path: /assets/images/strings/strings_banner.png
  alt: MobileHackingLab Strings Android Challenge
---

![MobileHackingLab Strings Challenge Banner](/assets/images/strings/strings_banner.png){: .shadow .rounded-10 }

**Strings** is an Android reverse engineering and exploitation challenge from [MobileHackingLab](https://www.mobilehackinglab.com/). The challenge is designed to provide hands-on experience with Android intent messaging architectures, deep link handling, static code reversing, and runtime instrumentation using Frida APIs and memory analysis.

The objective is to analyze the target application (`com.mobilehackinglab.challenge`), uncover an exported activity protected by multiple validation layers ("gatekeepers"), satisfy date-based and cryptographic checks, and extract the secret flag (`MHL{...}`) loaded by a native shared library.

---

## 1. Challenge Overview & Objectives

- **Platform**: [MobileHackingLab.com](https://www.mobilehackinglab.com/)
- **Target Application**: `com.mobilehackinglab.challenge` (`Strings.apk`)
- **Category**: Android Application Security & Dynamic Instrumentation
- **Primary Vulnerability**: Insecurely Exported Activity (`Activity2`) with unauthenticated Deep Link handling
- **Required Skills**:
  - Android application component architecture and intent-filter routing
  - Static reverse engineering with JADX / Bytecode analysis
  - Cryptographic analysis (AES-CBC key/IV extraction & Base64 decoding)
  - Dynamic instrumentation with Frida (calling unreferenced methods & hooking native functions)
- **Flag Format**: `MHL{...}`
- **Recovered Flag**: `MHL{st1ngs_4nd_1nt3nts}`

---

## 2. Background: Understanding Android Intents & Deep Links

In the Android operating system, **Intents** serve as an asynchronous messaging facility enabling communication between app components (Activities, Services, Broadcast Receivers) within the same app or across disparate applications.

Intents fall into two distinct categories:
1. **Explicit Intents**: Directly designate the target component by its fully qualified class name (e.g., `new Intent(this, TargetActivity.class)`). These are typically used for internal application flow.
2. **Implicit Intents**: Declare a general action to perform (`android.intent.action.VIEW`, `android.intent.action.SEND`), optionally coupled with a data URI (`scheme://host/path`) and MIME type. The Android OS resolves which component can handle the request by consulting declared `<intent-filter>` tags in `AndroidManifest.xml`.

When an Activity declares `<intent-filter>` tags and is marked with `android:exported="true"`, any external application or command-line shell (`adb shell am start`) can trigger it. If the activity executes sensitive actions or exposes protected functionality without authenticating the caller, it introduces a severe security vulnerability.

---

## 3. Step 1: Manifest Analysis & Component Discovery

We start our analysis by decompiling `com.mobilehackinglab.strings.apk` in **JADX-GUI** and auditing `AndroidManifest.xml`.

```xml
<activity
    android:name="com.mobilehackinglab.challenge.Activity2"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data 
            android:scheme="mhl" 
            android:host="labs" />
    </intent-filter>
</activity>
```

### Security Findings from Manifest Audit:
- **Missing Permissions**: `Activity2` is declared with `android:exported="true"`, making it accessible to any third-party app installed on the device. No custom `android:permission` or signature-level checks guard this entry point.
- **Deep Link Filter**: The `<intent-filter>` accepts implicit intents with action `android.intent.action.VIEW`, categories `DEFAULT` and `BROWSABLE`, and custom URI matching:
  ```
  mhl://labs/<path>
  ```

---

## 4. Step 2: Reverse Engineering the 3 Gatekeepers

Examining the decompiled source code of `com.mobilehackinglab.challenge.Activity2` and its companion class `Activity2Kt`, we observe that `Activity2.onCreate()` enforces three strict validation gates before the flag can be retrieved.

![JADX Activity2Kt fixedIV Inspection](/assets/images/strings/01_jadx_activity2kt_fixediv.png){: .shadow .rounded-10 }

![JADX Activity2 Gatekeepers](/assets/images/strings/02_jadx_activity2_gatekeepers.png){: .shadow .rounded-10 }

Let's dissect each gatekeeper individually:

### Gatekeeper 1: Intent Action Validation
```java
boolean isActionView = Intrinsics.areEqual(getIntent().getAction(), "android.intent.action.VIEW");
```
- **Requirement**: The incoming intent must explicitly specify `-a android.intent.action.VIEW`. An intent launched without this action will fail this check and terminate the activity via `finishAffinity()` and `System.exit(0)`.

### Gatekeeper 2: SharedPreferences Date Matching
```java
SharedPreferences sharedPreferences = getSharedPreferences("DAD4", 0);
String u_1 = sharedPreferences.getString("UUU0133", null);
boolean isU1Matching = Intrinsics.areEqual(u_1, cd());
```
- **Requirement**: The app opens a `SharedPreferences` file named `DAD4` and reads the string stored under key `UUU0133`.
- It then invokes `cd()`, which returns the current device date formatted as `dd/MM/yyyy`.
- The stored value `u_1` must exactly match `cd()`!

#### Inspecting `MainActivity.java` (The Hidden Method)
When analyzing `MainActivity.java`, we discover an interesting method named `KLOW()`:

```java
public final void KLOW() {
    SharedPreferences sharedPreferences = getSharedPreferences("DAD4", 0);
    SharedPreferences.Editor editor = sharedPreferences.edit();
    String cu_d = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault()).format(new Date());
    editor.putString("UUU0133", cu_d);
    editor.apply();
}
```

> **Key Discovery**: 
> The method `KLOW()` writes today's formatted date directly into `DAD4.xml` under key `UUU0133`. However, static code analysis reveals that `KLOW()` is **dead code—it is never invoked anywhere in the application**! 
> To pass Gatekeeper 2 without modifying the APK, we must dynamically invoke `KLOW()` at runtime using **Frida**.
{: .prompt-warning }

### Gatekeeper 3: Cryptographic Secret Check
Once Gatekeeper 1 and Gatekeeper 2 pass, `Activity2` extracts the URI and validates the scheme and host:

```java
Uri uri = getIntent().getData();
if (uri != null && Intrinsics.areEqual(uri.getScheme(), "mhl") && Intrinsics.areEqual(uri.getHost(), "labs")) {
    String base64Value = uri.getLastPathSegment();
    byte[] decodedValue = Base64.decode(base64Value, 0);
    if (decodedValue != null) {
        String ds = new String(decodedValue, Charsets.UTF_8);
        byte[] bytes = "your_secret_key_1234567890123456".getBytes(Charsets.UTF_8);
        String str = decrypt("AES/CBC/PKCS5Padding", "bqGrDKdQ8zo26HflRsGvVA==", new SecretKeySpec(bytes, "AES"));
        if (str.equals(ds)) {
            System.loadLibrary("flag");
            String s = getflag();
            Toast.makeText(getApplicationContext(), s, 1).show();
            return;
        }
    }
}
```

#### Reversing the Cryptographic Parameters:
1. **Symmetric Cipher**: `AES/CBC/PKCS5Padding`
2. **Ciphertext (Base64)**: `bqGrDKdQ8zo26HflRsGvVA==`
3. **Secret Key**: `your_secret_key_1234567890123456`
4. **Initialization Vector (IV)**: In `Activity2Kt.java`, we locate:
   ```java
   public static final String fixedIV = "1234567890123456";
   ```

When we decrypt `bqGrDKdQ8zo26HflRsGvVA==` with key `"your_secret_key_1234567890123456"` and IV `"1234567890123456"`, we obtain:
```
Plaintext Secret (str) = "mhl_secret_1337"
```

The application checks `if (str.equals(ds))`, where `ds` is derived from:
```java
String base64Value = uri.getLastPathSegment();
byte[] decodedValue = Base64.decode(base64Value, 0);
String ds = new String(decodedValue, Charsets.UTF_8);
```

Therefore, `base64Value` must be the Base64-encoded representation of `"mhl_secret_1337"`:
```
Base64("mhl_secret_1337") = "bWhsX3NlY3JldF8xMzM3"
```

#### Constructing the Target Deep Link URI:
| Component | Required Value | Rationale |
| :--- | :--- | :--- |
| **Scheme** | `mhl` | `uri.getScheme().equals("mhl")` |
| **Host** | `labs` | `uri.getHost().equals("labs")` |
| **Path Segment** | `bWhsX3NlY3JldF8xMzM3` | Base64 of `"mhl_secret_1337"` matching decrypted `str` |

Combining all parts yields the exact payload URI:
```
mhl://labs/bWhsX3NlY3JldF8xMzM3
```

---

## 5. Step 3: Cryptographic Verification (Python Solver)

To verify the mathematical and cryptographic derivation, we write a Python script using `cryptography` to decrypt the ciphertext and generate the required URI token:

```python
#!/usr/bin/env python3
import base64
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding

# Parameters extracted from decompiled classes
key = b"your_secret_key_1234567890123456"
iv  = b"1234567890123456"  # Activity2Kt.fixedIV
ct  = base64.b64decode("bqGrDKdQ8zo26HflRsGvVA==")

# Decrypt AES-CBC
cipher = Cipher(algorithms.AES(key), modes.CBC(iv))
decryptor = cipher.decryptor()
padded_pt = decryptor.update(ct) + decryptor.finalize()

# Remove PKCS7 padding
unpadder = padding.PKCS7(128).unpadder()
secret = (unpadder.update(padded_pt) + unpadder.finalize()).decode("utf-8")

b64_token = base64.b64encode(secret.encode()).decode()

print(f"[+] Decrypted Secret : {secret}")
print(f"[+] Base64 URL Token : {b64_token}")
print(f"[★] Full Deep Link   : mhl://labs/{b64_token}")
```

Executing the script confirms our findings:

![Python AES Decryption Output](/assets/images/strings/03_python_aes_decrypt.png){: .shadow .rounded-10 }

---

## 6. Step 4: Dynamic Instrumentation with Frida

With the URI derived, we must now satisfy Gatekeeper 2 by calling `KLOW()` to populate `DAD4.xml`. We develop a Frida script (`set_date.js`):

```javascript
Java.perform(function () {
    var MainActivity = Java.use("com.mobilehackinglab.challenge.MainActivity");
    
    Java.choose("com.mobilehackinglab.challenge.MainActivity", {
        onMatch: function (instance) {
            console.log("[+] Found active MainActivity instance!");
            console.log("[*] Invoking instance.KLOW()...");
            instance.KLOW();
            console.log("[✔] KLOW() executed: DAD4.xml written with today's date!");
        },
        onComplete: function () {
            console.log("[*] Instance search completed.");
        }
    });
});
```

We launch the application with Frida and execute the hook:

```bash
~$ >> frida -U -f com.mobilehackinglab.challenge -l set_date.js
```

![Frida KLOW Invocation](/assets/images/strings/04_frida_klow_invoke.png){: .shadow .rounded-10 }

---

## 7. Step 5: Triggering the Deep Link via ADB

With `DAD4.xml` populated, we dispatch the exploit Intent using Android's Activity Manager (`am`):

```bash
~$ >> adb shell am start -a android.intent.action.VIEW -d "mhl://labs/bWhsX3NlY3JldF8xMzM3" -n com.mobilehackinglab.challenge/.Activity2
```

We verify that the SharedPreferences file was created and inspect Logcat output:

![ADB Intent Triggering & Verification](/assets/images/strings/05_adb_intent_trigger.png){: .shadow .rounded-10 }

---

## 8. Step 6: Native Library Analysis & Memory Scanning

Once all three gatekeepers pass, `Activity2` executes:
```java
System.loadLibrary("flag");
String s = getflag();
Toast.makeText(getApplicationContext(), s, 1).show();
```

The app loads `libflag.so` and calls the JNI function `getflag()`. To extract the flag directly from process memory or hook the JNI boundary, we use Frida to attach to `Java_com_mobilehackinglab_challenge_Activity2_getflag`:

```javascript
Interceptor.attach(Module.findExportByName("libflag.so", "Java_com_mobilehackinglab_challenge_Activity2_getflag"), {
    onEnter: function (args) {
        console.log("[*] Native getflag() invoked!");
    },
    onLeave: function (retval) {
        var env = Java.vm.getEnv();
        var flagStr = env.getStringUtfChars(retval, null).readCString();
        console.log("[★] Captured Flag: " + flagStr);
    }
});
```

Alternatively, using Objection's memory search command while the activity is running:
```bash
memory search "MHL{" --string
```

Running our interception script outputs the flag:

![Frida Native Hook & Memory Flag Extraction](/assets/images/strings/06_frida_memory_scan_flag.png){: .shadow .rounded-10 }

```
[★] Captured Flag: MHL{st1ngs_4nd_1nt3nts}
```

---

## 9. Remediation & Secure Coding Recommendations

### 1. Enforce Explicit Component Access Controls
If `Activity2` is intended only for internal application usage, set `android:exported="false"` in `AndroidManifest.xml`:
```xml
<activity
    android:name="com.mobilehackinglab.challenge.Activity2"
    android:exported="false" />
```

### 2. Guard Deep Links with Signature-Level Permissions
If third-party or browser apps must trigger deep links, protect the component using a custom permission with `signature` protection:
```xml
<permission
    android:name="com.mobilehackinglab.challenge.permission.ACCESS_LABS"
    android:protectionLevel="signature" />
```

### 3. Eliminate Hardcoded Cryptographic Keys & Static IVs
- Hardcoded AES keys and fixed IVs in client binaries provide zero confidentiality against reverse engineering.
- Use the **Android KeyStore system** to generate and store cryptographic keys in hardware-backed secure enclaves (`StrongBox` / `TEE`).
- Always generate a cryptographically secure random IV (`SecureRandom`) for every AES-CBC encryption operation.

### 4. Remove Dead Code & Insecure Client-Side Validation
Do not rely on client-side SharedPreferences date checks or uncalled helper methods (`KLOW()`) as security controls. Sensitive authorizations must be verified server-side.

---

## 10. Conclusion

The **Strings** challenge from MobileHackingLab highlights how combining multiple client-side mechanisms (exported activities, deep links, dead-code methods, and symmetric encryption) fails to protect sensitive resources when an attacker has access to runtime dynamic analysis. By chaining static JADX analysis, Python cryptographic reversing, and Frida method invocation, all three gatekeepers were bypassed to trigger the native library and extract the flag.
