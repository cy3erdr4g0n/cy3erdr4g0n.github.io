---
title: "MobileHackingLab: Secure Notes – Exploiting Android Content Providers & Cracking AES-CBC PIN"
date: 2026-09-12 14:00:00 +0100
categories: ["Mobile Security", "MobileHackingLab"]
tags: ["android", "content-provider", "mobilehackinglab", "aes-cbc", "pbkdf2", "jadx", "python-bruteforce", "cryptography"]
image:
  path: /assets/images/secure-note/secure_notes_banner.png
  alt: MobileHackingLab Secure Notes Challenge Banner
---

![MobileHackingLab Secure Notes Banner](/assets/images/secure-note/secure_notes_banner.png){: .shadow .rounded-10 }

**Secure Notes** is an Android challenge from [MobileHackingLab](https://www.mobilehackinglab.com/) focused on **Android Content Provider** vulnerabilities and cryptographic implementation weaknesses. 

The objective is to analyze the application's data management architecture, identify an insecurely exported Content Provider, extract the protected cryptographic parameters, and perform an offline brute-force attack to crack the AES-CBC encryption and recover the secret PIN code.

---

## 1. Challenge Overview

- **Platform**: [MobileHackingLab.com](https://www.mobilehackinglab.com/)
- **Category**: Android Application Security & Reverse Engineering
- **Vulnerability**: Insecurely Exported Content Provider + Low-Entropy Cryptographic Key (4-digit PIN)
- **Encryption Scheme**: `AES/CBC/PKCS5Padding` with `PBKDF2WithHmacSHA1` (10,000 iterations, 256-bit key)
- **Cracked PIN**: `2580`
- **Recovered Secret**: `CTF{D1d_y0u_gu3ss_1t!1?}`

---

## 2. Reconnaissance & Static Analysis (JADX)

We begin by decompiling the target APK using **JADX-GUI** to inspect the application structure, declared components, and assets.

### Auditing AndroidManifest.xml
In Android, **Content Providers** manage access to structured datasets (such as SQLite databases or configuration files) and facilitate inter-process data sharing.

Looking at `AndroidManifest.xml`, we look for declared `<provider>` elements:

```xml
<provider
    android:name="com.mobilehackinglab.securenotes.SecretDataProvider"
    android:authorities="com.mobilehackinglab.securenotes.secretprovider"
    android:exported="true" />
```

> **Security Finding: Missing Access Control**:
> The `SecretDataProvider` is declared with `android:exported="true"` and **does not declare any custom permissions (`android:readPermission` / `android:writePermission`)**. This misconfiguration allows any third-party app installed on the device (or ADB) to query and extract data from the provider without requiring elevated privileges.
{: .prompt-danger }

---

## 3. Querying the Content Provider via ADB

We can interact directly with the exported provider using Android's `content` command via ADB:

```bash
# Query the exported SecretDataProvider
adb shell content query --uri content://com.mobilehackinglab.securenotes.secretprovider/
```

Alternatively, any rogue Android application can access the data programmatically using `ContentResolver`:

```java
Uri uri = Uri.parse("content://com.mobilehackinglab.securenotes.secretprovider/");
Cursor cursor = getContentResolver().query(uri, null, null, null, null);
```

---

## 4. Cryptographic Implementation Analysis (JADX Inspection)

Navigating to `com.mobilehackinglab.securenotes.SecretDataProvider` in JADX-GUI reveals how the content provider loads and decrypts the secret.

![JADX SecretDataProvider Code](/assets/images/secure-note/jadx_secretdataprovider.png)
_Figure 2: Decompiled SecretDataProvider showing config.properties parsing and crypto initialization._

### Examining `assets/config.properties`
Inside the decompiled APK resources under `assets/config.properties`, we find the stored cryptographic configuration:

![JADX config.properties View](/assets/images/secure-note/jadx_config_properties.png)
_Figure 3: Configuration properties containing the Base64-encoded encrypted secret, salt, IV, and iteration count._

```properties
encryptedSecret=bTjBHijMAVQX+CoyFbDPJXRUSHcTyzGaie3OgVqvK5w=
salt=m2UvPXkvte7fygEeMr0WUg==
iv=L15Je6YfY5owgIckR9R3DQ==
iterationCount=10000
```

### Decompiled Cryptographic Routine
In `SecretDataProvider.kt` (decompiled to Java by JADX):

```java
public final class SecretDataProvider extends ContentProvider {
    private byte[] encryptedSecret;
    private int iterationCount;
    private byte[] iv;
    private byte[] salt;

    @Override // android.content.ContentProvider
    public boolean onCreate() throws IOException {
        AssetManager assets;
        InputStream inputStreamOpen;
        Properties properties = new Properties();
        Context context = getContext();
        if (context != null && (assets = context.getAssets()) != null && (inputStreamOpen = assets.open("config.properties")) != null) {
            try {
                InputStream it = inputStreamOpen;
                properties.load(it);
                byte[] bArrDecode = Base64.decode(properties.getProperty("encryptedSecret"), 0);
                this.encryptedSecret = bArrDecode;
                byte[] bArrDecode2 = Base64.decode(properties.getProperty("salt"), 0);
                this.salt = bArrDecode2;
                byte[] bArrDecode3 = Base64.decode(properties.getProperty("iv"), 0);
                this.iv = bArrDecode3;
                String property = properties.getProperty("iterationCount");
                this.iterationCount = Integer.parseInt(property);
                Unit unit = Unit.INSTANCE;
                ...
```

Tracing `generateKeyFromPin(String)` and `decryptSecret(String)`:
1. **Key Derivation (`PBKDF2WithHmacSHA1`)**:
   - Iterations: `10000`
   - Key Length: `256 bits` (`32 bytes`)
   - Salt: Base64-decoded `m2UvPXkvte7fygEeMr0WUg==`
   - Password: 4-digit PIN formatted as a 4-digit string (`0000` to `9999`).
2. **Cipher (`AES/CBC/PKCS5Padding`)**:
   - Algorithm: `AES` in `CBC` mode with `PKCS5Padding`
   - Initialization Vector (IV): Base64-decoded `L15Je6YfY5owgIckR9R3DQ==`
   - Ciphertext: Base64-decoded `bTjBHijMAVQX+CoyFbDPJXRUSHcTyzGaie3OgVqvK5w=`

---

## 5. Exploitation: Offline AES-CBC Brute-Force

While AES-256 is mathematically secure, **deriving an encryption key from a 4-digit PIN is fatal**.

* A 4-digit numeric PIN has only $10^4 = 10,000$ possible values (`0000` through `9999`).
* Because we have the `salt`, `iv`, and `encrypted` data, we don't need to interact with the Android application. We can execute a high-speed offline brute-force attack on our workstation.

### The Python Solver Script
We use Python's `hashlib.pbkdf2_hmac` and `Crypto.Cipher.AES` (from `pycryptodome`) to iterate through all 10,000 PINs. The script checks for valid **PKCS#5/PKCS#7 padding** and valid UTF-8 decoding to confirm decryption success:

```python
#!/usr/bin/env python3
import base64
from hashlib import pbkdf2_hmac
from Crypto.Cipher import AES

# Values extracted from config.properties
encrypted = base64.b64decode(
    "bTjBHijMAVQX+CoyFbDPJXRUSHcTyzGaie3OgVqvK5w="
)

salt = base64.b64decode(
    "m2UvPXkvte7fygEeMr0WUg=="
)

iv = base64.b64decode(
    "L15Je6YfY5owgIckR9R3DQ=="
)

ITERATIONS = 10000
KEY_LENGTH = 32  # 256 bits


def decrypt(pin):
    # Android code converts the PIN to a 4-digit string
    password = f"{pin:04d}".encode("utf-8")

    # PBKDF2WithHmacSHA1, 256-bit key
    key = pbkdf2_hmac(
        "sha1",
        password,
        salt,
        ITERATIONS,
        KEY_LENGTH
    )

    # AES/CBC/PKCS5Padding
    cipher = AES.new(key, AES.MODE_CBC, iv)

    try:
        plaintext = cipher.decrypt(encrypted)

        # Validate PKCS#5/PKCS#7 padding
        padding_length = plaintext[-1]

        if padding_length < 1 or padding_length > AES.block_size:
            return None

        if plaintext[-padding_length:] != bytes(
            [padding_length]
        ) * padding_length:
            return None

        plaintext = plaintext[:-padding_length]

        # The Android app converts the result to UTF-8
        return plaintext.decode("utf-8")

    except (UnicodeDecodeError, ValueError):
        return None


def main():
    print("[*] Starting PIN search...")
    print("[*] Testing PINs from 0000 to 9999")

    for pin in range(10000):
        result = decrypt(pin)

        if result is not None:
            print()
            print("[+] Possible PIN found!")
            print(f"[+] PIN:    {pin:04d}")
            print(f"[+] Secret: {result}")
            print()
            return

        # Progress indicator
        if pin % 1000 == 0:
            print(f"[*] Tested {pin:04d}")

    print()
    print("[-] No valid PIN found.")


if __name__ == "__main__":
    main()
```

---

## 6. Execution & Flag Recovery

Running the brute-force script against all 10,000 PIN combinations:

```bash
$ python3 solve.py
[*] Starting PIN search...
[*] Testing PINs from 0000 to 9999
[*] Tested 0000
[*] Tested 1000
[*] Tested 2000

[+] Possible PIN found!
[+] PIN:    ****
[+] Secret: CTF{**************?}
```

The script finds the valid PIN: **`2580`** (which forms a straight vertical line down the center of the keypad: `2 -> 5 -> 8 -> 0`).

Entering `2580` into the Android application unlocks the note and displays the decrypted flag:

```text
Flag: CTF{*********}
```

---

## 7. Prevention & Remediation

### 1. Secure Content Providers
* Set `android:exported="false"` unless external inter-app communication is explicitly required.
* If external access is necessary, define custom permissions with `protectionLevel="signature"` so only apps signed with the same developer certificate can access the provider:
  ```xml
  <permission
      android:name="com.mobilehackinglab.securenotes.READ_NOTES"
      android:protectionLevel="signature" />
  ```

### 2. Android Keystore System
* Never derive cryptographic encryption keys directly from short user PINs on the client.
* Use the **Android Keystore System** (`KeyGenParameterSpec.Builder`) with hardware-backed security (`PURPOSE_ENCRYPT | PURPOSE_DECRYPT`) and require biometric or user authentication to authorize key use.

### 3. Server-Side Key Escrow & Rate Limiting
* If PIN authentication is used, key derivation or verification should involve a remote server that enforces exponential backoff and lockouts after consecutive failed attempts.
