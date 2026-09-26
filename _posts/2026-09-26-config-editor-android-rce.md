---
title: "Config Editor - Android Static Analysis & Component Audit"
date: 2026-09-26 14:00:00 +0100
categories: ["Mobile Security", "MobileHackingLab"]
tags: ["android", "mobilehackinglab", "static-analysis", "reverse-engineering", "manifest-audit"]
image:
  path: /assets/images/config-editor/config_editor_banner.png
  alt: Config Editor Lab
---

![Config Editor Banner](/assets/images/config-editor/config_editor_banner.png){: .shadow .rounded-10 }

## Introduction

Welcome to the **Config Editor Challenge**! This lab focuses on static analysis, component auditing, and understanding how Android applications handle configuration files and external intents.

### Objective

* Perform comprehensive static reverse engineering on the target application to identify component exposure and entry points.

### Tools Needed

* **Lab Environment**: Android Emulator / Test Device
* **Reverse Engineering Tools**: JADX / JADX-GUI, APKTool

---

![scren shot of androidManifest.xml](/assets/images/config-editor/android.png)

## Static Analysis: AndroidManifest.xml Audit

By inspecting `AndroidManifest.xml` during decompilation with JADX-GUI, we uncover critical architectural configurations:

### 1. Package & SDK Targets

* **Package Name**: `com.mobilehackinglab.configeditor`
* **minSdkVersion**: `26` (Android 8.0 Oreo)
* **targetSdkVersion**: `33` (Android 13)
* **compileSdkVersion**: `34` (Android 14)

### 2. Permissions Declared & Requested

#### System Permissions
* `android.permission.INTERNET`: Grants network access, allowing outbound HTTP/HTTPS requests.
* `android.permission.READ_EXTERNAL_STORAGE` / `android.permission.WRITE_EXTERNAL_STORAGE`: Storage permissions for external shared storage.
* `android.permission.MANAGE_EXTERNAL_STORAGE`: Privileged All-Files Access permission introduced in Android 11 (API 30).

#### Custom Signature Permission
```xml
<permission
    android:name="com.mobilehackinglab.configeditor.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"
    android:protectionLevel="signature"/>
<uses-permission android:name="com.mobilehackinglab.configeditor.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"/>
```
* Defines a custom permission with `protectionLevel="signature"`. Only applications signed with the matching certificate can interact with components guarded by this permission. This is commonly added automatically by modern AndroidX runtime components to protect dynamic broadcast receivers.

### 3. Application Attributes & Flags

* `android:debuggable="true"`: Flags the app as debuggable, allowing debuggers or process inspection tools to attach to the running process.
* `android:allowBackup="true"`: Permits application private storage to be included in device backup operations (`adb backup`).
* `android:networkSecurityConfig="@xml/network_security_config"`: References network security declarations for domain rules and cleartext policies.

### 4. Components & Intent Filters

#### MainActivity (Exported Entry Point)
```xml
<activity
    android:name="com.mobilehackinglab.configeditor.MainActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="file"/>
        <data android:scheme="http"/>
        <data android:scheme="https"/>
        <data android:mimeType="application/yaml"/>
    </intent-filter>
</activity>
```

* **Launcher Filter**: Serves as the standard user entry point launched from the home screen (`ACTION_MAIN`).
* **Deep Link / View Filter**:
  * Registers `MainActivity` to receive `android.intent.action.VIEW` intents.
  * Filters for MIME type `application/yaml`.
  * Accepts data schemes matching `file://`, `http://`, and `https://`.
  * Including `android.intent.category.BROWSABLE` allows external browsers and installed apps to pass YAML configurations to this activity.

#### Internal Components
* **`androidx.startup.InitializationProvider`**: Explicitly unexported (`android:exported="false"`), handling internal library initialization.
* **`androidx.profileinstaller.ProfileInstallReceiver`**: Protected with `android.permission.DUMP`, used by ART for baseline profile optimizations.

---

- examining the AndroidManifest.xml file, we gain insights into the application’s behavior and configuration.

- i went proceed to examing   MainActivity

![scren shot of Manifest.xml](/assets/images/config-editor/manifest.png)

- which i saw 

```
mport org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml; 
```
- and from our andriodmanifest.xml we see it have a permissions 

- proceess with my reshearch i find it was vulnerable 

![scren shot of snakeyaml](/assets/images/config-editor/snakeyaml.png)

```“The SnakeYaml library for Java is vulnerable to arbitrary code execution due to a flaw in its Constructor class. The class does not restrict which types can be deserialized, allowing an attacker to provide a malicious YAML file for deserialization and potentially exploit the system. Thus this flaw leads to an insecure deserialization issue that can result in arbitrary code execution.”```

- and the legacey 


![scren shot of snakeyaml](/assets/images/config-editor/legacey.png)

- i make Use this, we can exploit the RCE (Remote Code Execution) vulnerability:

https://snyk.io/blog/unsafe-deserialization-snakeyaml-java-cve-2022-1471/?source=post_page-----08793d462472-----------------------------------------

- i proced to craft my expoilt 

```

exploit: !!com.mobilehackinglab.configeditor.LegacyCommandUtil ["touch /data/data/com.mobilehackinglab.configeditor/poc.txt"]

  ```


### result

![scren shot of Manifest.xml](/assets/images/config-editor/result1.png)


![scren shot of Manifest.xml](/assets/images/config-editor/result2.png)


## Defensive Remediation & Best Practices

1. **Restrict Component Exporting**: If an activity does not need to accept files from untrusted third-party apps, set `android:exported="false"`.
2. **Strict MIME & Scheme Validation**: When handling `file://` or external schemes, validate file origins and utilize secure parsers that do not permit arbitrary type resolution or dynamic class instantiation.
3. **Disable Debug Mode in Production**: Ensure `android:debuggable="false"` in release builds to prevent debugging hooks in untrusted environments.
