# Title :  Active Directory


## Recona

### Step 1 : network mapping : Mapping Out the Network

```bash

We don't have any credentials yet; only our attacking machine is equipped with the greatest and latest tools. Our goal is to discover the structure of the Active Directory environment, identify hosts and services, and map out the network. Let's imagine for a second that we don't have a nice network diagram, and are given the following subnet as part of our scope: 10.x.x.x/24

```

#### Host Discovery

```
One of the first things we can do is run a subnet host discovery scan. This will allow us to identify all live hosts in our target network range. Most clients will include a subnet range in the pentest scope, so we must discover all active hosts we might want to target. We will showcase two different tools that can be used for initial host discovery.
```

##### fping
```
Just like ping, fping uses Internet Control Message Protocol (ICMP) requests to determine if a host is live or not. However, with fping, we can specify any number of targets, including a subnet, making it more versatile than the ping command. Instead of sending a packet to one target until it replies or times out, fping will move to the next target after each request.
```

```sh

$ fping -agq 10.211.11.0/24
10.211.11.10
10.211.11.20
10.211.11.250

```

- -a: shows systems that are alive.
- -g: generates a target list from a supplied IP netmask.
- -q: quiet mode, doesn't show per-probe results or ICMP error messages.

##### nmap 

We can also use Nmap in ping scan mode (-sn) to probe the entire subnet:

```sh

nmap -sn 10.211.11.0/24

```

- -sn: Ping scan to determine which hosts are up without port scanning.

###### Port Scanning
Once we've discovered live hosts, we must identify which one is the Domain Controller (DC) to determine which critical AD-related services are being used and can be exploited. These are some common Active Directory ports and protocols:

We can run a service version scan with these specific ports to help identify the DC:

```sh
nmap -p 88,135,139,389,445 -sV -sC -iL hosts.txt
```

-sV: This enables version detection. Nmap will try to determine the version of the services running on the open ports.
-sC: Runs Nmap Scripting Engine (NSE) scripts in the default category.
-iL: This tells Nmap to read the list of target hosts from the file hosts.txt. Each line in this file should contain a single IP address or hostname.
We can spot the Domain Controller because it will often have ports 88 (Kerberos), 389 (LDAP), and 445 (SMB) open, with banners like 'Windows Server' or even domain names revealed in the output of our nmap command.

If we were running a more exhaustive assessment or dealing with unfamiliar environments, starting with a full port scan ensures we don't miss critical services running on non-standard ports. We could use this command to scan for all open ports:

```sh
nmap -sS -p- -T3 -iL hosts.txt -oN full_port_scan.txt
```

- -sS: TCP SYN scan, which is stealthier than a full connect scan
- -p-: Scans all 65,535 TCP ports.
- -T3: Sets the timing template to "normal" to balance speed and stealth.
- -iL hosts.txt: Inputs the list of live hosts from the previous nmap command.
- -oN full_port_scan.txt: Outputs the results to a file.
Through these enumeration techniques, we have identified two live hosts in our target network, one DC and one Workstation, and the domain. We have also confirmed a couple of known services running on the DC, which we can target to further enumerate the domain



###### Result 

```sh

map -p 88,135,139,389,445 -sV -sC -iL uhosts.txt
Starting Nmap 7.95 ( https://nmap.org ) at 2025-07-28 18:40 WAT
Stats: 0:00:07 elapsed; 0 hosts completed (2 up), 2 undergoing Service Scan
Service scan Timing: About 0.00% done
Stats: 0:00:08 elapsed; 0 hosts completed (2 up), 2 undergoing Service Scan
Service scan Timing: About 12.50% done; ETC: 18:41 (0:00:49 remaining)
Nmap scan report for 10.211.11.10
Host is up (0.29s latency).

PORT    STATE SERVICE      VERSION
88/tcp  open  kerberos-sec Microsoft Windows Kerberos (server time: 2025-07-28 17:40:17Z)
135/tcp open  msrpc        Microsoft Windows RPC
139/tcp open  netbios-ssn  Microsoft Windows netbios-ssn
389/tcp open  ldap         Microsoft Windows Active Directory LDAP (Domain: tryhackme.loc0., Site: Default-First-Site-Name)
445/tcp open  microsoft-ds Windows Server 2019 Datacenter 17763 microsoft-ds (workgroup: TRYHACKME)
Service Info: Host: DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2025-07-28T17:40:40
|_  start_date: N/A
|_clock-skew: mean: 0s, deviation: 1s, median: 0s
| smb-os-discovery: 
|   OS: Windows Server 2019 Datacenter 17763 (Windows Server 2019 Datacenter 6.3)
|   Computer name: DC
|   NetBIOS computer name: DC\x00
|   Domain name: tryhackme.loc
|   Forest name: tryhackme.loc
|   FQDN: DC.tryhackme.loc
|_  System time: 2025-07-28T17:40:37+00:00
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled and required
| smb-security-mode: 
|   account_used: <blank>
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: required

Nmap scan report for 10.211.11.20
Host is up (0.29s latency).

PORT    STATE  SERVICE       VERSION
88/tcp  closed kerberos-sec
135/tcp open   msrpc         Microsoft Windows RPC
139/tcp open   netbios-ssn   Microsoft Windows netbios-ssn
389/tcp closed ldap
445/tcp open   microsoft-ds?
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required
|_clock-skew: -1s
| smb2-time: 
|   date: 2025-07-28T17:40:42
|_  start_date: N/A

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 2 IP addresses (2 hosts up) scanned in 50.71 seconds                             

```

### Step 2 : Network Enumeration With SMB

#### Discovering Services
We will begin our “discovery” with the good old Nmap. We are mainly interested in MS Windows and Active Directory-related ports. We will limit our scan to the following ports:

- TCP 88 (Kerberos): Kerberos uses this port for authentication in the Active Directory. From a penetration testing point of view, it can be a goldmine for ticket attacks like Pass-the-Ticket and Kerberoasting.
- TCP 135 (RPC Endpoint Mapper): This TCP port is used for Remote Procedure Calls (RPC). It might be leveraged to identify services for lateral movement or remote code execution via DCOM.
- TCP 139 (NetBIOS Session Service): This port is used for file sharing in older Windows systems. It can be abused for null sessions and information gathering.
- TCP 389 (LDAP): This TCP port is used by the Lightweight Directory Access Protocol (LDAP). It is in plaintext and can be a prime target for enumerating AD objects, users, and policies.
- TCP 445 (SMB): Critical for file sharing and remote admin; abused for exploits like EternalBlue, SMB relay attacks, and credential theft.
- TCP 636 (LDAPS): This port is used by Secure LDAP. Although it is encrypted, it can still expose AD structure if misconfigured and can be abused via certificate-based attacks like AD CS exploitation.

```sh
We can use the Nmap scanner to check if any active services are listening on these ports, attempt to detect their versions with -sV, and allow default scripts to run with -sC. Our final command will be, nmap -p 88,135,139,389,445,636 -sV -sC TARGET_IP. The result of scanning the domain controller is shown below.
```

##### Listing SMB Shares
At this stage, we don’t have valid credentials. Let’s check the exposed SMB shares and see if we can connect to any of them anonymously. We will try an anonymous connection, also known as a null session because it uses no username or password, and see if we can get access. There are two good tools for enumerating SMB shares from a Linux box: smbclient and smbmap.

smbclient is a command-line tool that allows interaction with SMB shares and is part of the Samba suite. It is similar to an FTP client. You can use it to list, upload, download, and browse files on a remote SMB server. In the terminal below, we try to list the shares via the -L option, with no password, hence the -N option. We can see some interesting shares below running smbclient -L //TARGET_IP -N.

Another tool is smbmap, a reconnaissance tool that enumerates SMB shares across a host. It can be used to display read and write permissions for each share. It’s instrumental for quickly identifying accessible or misconfigured shares without manually connecting to each one

```sh

$ smbmap -H 10.211.11.10
[+] Finding open SMB ports....
[+] User SMB session established on 10.211.11.10...
[+] IP: 10.211.11.10:445        Name: 10.211.11.10        
        Disk                     Permissions     Comment
        ----                     -----------     -------
        ADMIN$                   NO ACCESS       Remote Admin
        AnonShare                READ, WRITE
        C$                       NO ACCESS       Default share
        IPC$                     NO ACCESS       Remote IPC
        NETLOGON                 NO ACCESS       Logon server share 
        SharedFiles              READ, WRITE
        SYSVOL                   NO ACCESS       Logon server share 
        UserBackups              READ, WRITE

```

###### Accessing SMB Shares
Now that we have listed the shares, let’s attempt to access the ones that allow anonymous access. We might discover any interesting files that might help us gain access. We will target all the shares that showed READ access among their permissions when we ran smbmap. To use smbclient to connect to a share, you can use smbclient //TARGET_IP/SHARE_NAME -N



```sh

 smbclient //10.211.11.10/SharedFiles -N
Anonymous login successful
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Mon Jul 28 18:55:39 2025
  ..                                  D        0  Mon Jul 28 18:55:39 2025
  Mouse_and_Malware.txt               A     1141  Thu May 15 10:40:19 2025

		7863807 blocks of size 4096. 3478073 blocks available
smb: \> 


```


###### What Can We Find in SMB Shares
An anonymous SMB share is a horrible idea. However, system administrators may have enabled it for legacy systems to work. Maybe an old printer needs to read a file, or an old scanner needs to write a file.

From a penetration testers’ point of view, SMB shares might contain configuration files, backup files, scripts, and even documents. After all, accessing a particular folder from any computer on the network is convenient. If the folder allows writing, it will only encourage users to upload more files. Some files might contain usernames or even credentials with a password that never got changed. In summary, it is essential to thoroughly search for any available shares as you might uncover useful hidden secrets.

### Step 3 : Domain Enumeration

#### LDAP Enumeration (Anonymous Bind)

Lightweight Directory Access Protocol (LDAP) is a widely used protocol for accessing and managing directory services, such as Microsoft Active Directory. LDAP helps locate and organise resources within a network, including users, groups, devices, and organisational information, by providing a central directory that applications and users can query.
Some LDAP servers allow anonymous users to perform read-only queries. This can expose user accounts and other directory information.

We can test if anonymous LDAP bind is enabled with ldapsearch:

ldapsearch -x -H ldap://10.211.11.10 -s base

- -x: Simple authentication, in our case, anonymous authentication.
- -H: Specifies the LDAP server.
- -s: Limits the query only to the base object and does not search subtrees or children.

#### Result

```bash

$ ldapsearch -x -H ldap://10.211.11.10 -s base
# extended LDIF
#
# LDAPv3
# base <> (default) with scope baseObject
# filter: (objectclass=*)
# requesting: ALL
#

#
dn:
domainFunctionality: 6
forestFunctionality: 6
domainControllerFunctionality: 7
rootDomainNamingContext: DC=tryhackme,DC=loc
ldapServiceName: tryhackme.loc:dc$@TRYHACKME.LOC
isGlobalCatalogReady: TRUE
supportedSASLMechanisms: GSSAPI
supportedSASLMechanisms: GSS-SPNEGO
supportedSASLMechanisms: EXTERNAL
supportedSASLMechanisms: DIGEST-MD5
supportedLDAPVersion: 3
supportedLDAPVersion: 2
supportedLDAPPolicies: MaxPoolThreads
supportedLDAPPolicies: MaxPercentDirSyncRequests
supportedLDAPPolicies: MaxDatagramRecv
supportedLDAPPolicies: MaxReceiveBuffer
supportedLDAPPolicies: InitRecvTimeout
supportedLDAPPolicies: MaxConnections
supportedLDAPPolicies: MaxConnIdleTime
supportedLDAPPolicies: MaxPageSize
supportedLDAPPolicies: MaxBatchReturnMessages
supportedLDAPPolicies: MaxQueryDuration
supportedLDAPPolicies: MaxDirSyncDuration
supportedLDAPPolicies: MaxTempTableSize
supportedLDAPPolicies: MaxResultSetSize
supportedLDAPPolicies: MinResultSets
supportedLDAPPolicies: MaxResultSetsPerConn
supportedLDAPPolicies: MaxNotificationPerConn
supportedLDAPPolicies: MaxValRange
supportedLDAPPolicies: MaxValRangeTransitive
supportedLDAPPolicies: ThreadMemoryLimit
supportedLDAPPolicies: SystemMemoryLimitPercent
supportedControl: 1.2.840.113556.1.4.319
supportedControl: 1.2.840.113556.1.4.801
supportedControl: 1.2.840.113556.1.4.473
supportedControl: 1.2.840.113556.1.4.528
supportedControl: 1.2.840.113556.1.4.417
supportedControl: 1.2.840.113556.1.4.619
supportedControl: 1.2.840.113556.1.4.841
supportedControl: 1.2.840.113556.1.4.529
supportedControl: 1.2.840.113556.1.4.805
supportedControl: 1.2.840.113556.1.4.521
supportedControl: 1.2.840.113556.1.4.970
supportedControl: 1.2.840.113556.1.4.1338
supportedControl: 1.2.840.113556.1.4.474
supportedControl: 1.2.840.113556.1.4.1339
supportedControl: 1.2.840.113556.1.4.1340
supportedControl: 1.2.840.113556.1.4.1413
supportedControl: 2.16.840.1.113730.3.4.9
supportedControl: 2.16.840.1.113730.3.4.10
supportedControl: 1.2.840.113556.1.4.1504
supportedControl: 1.2.840.113556.1.4.1852
supportedControl: 1.2.840.113556.1.4.802
supportedControl: 1.2.840.113556.1.4.1907
supportedControl: 1.2.840.113556.1.4.1948
supportedControl: 1.2.840.113556.1.4.1974
supportedControl: 1.2.840.113556.1.4.1341
supportedControl: 1.2.840.113556.1.4.2026
supportedControl: 1.2.840.113556.1.4.2064
supportedControl: 1.2.840.113556.1.4.2065
supportedControl: 1.2.840.113556.1.4.2066
supportedControl: 1.2.840.113556.1.4.2090
supportedControl: 1.2.840.113556.1.4.2205
supportedControl: 1.2.840.113556.1.4.2204
supportedControl: 1.2.840.113556.1.4.2206
supportedControl: 1.2.840.113556.1.4.2211
supportedControl: 1.2.840.113556.1.4.2239
supportedControl: 1.2.840.113556.1.4.2255
supportedControl: 1.2.840.113556.1.4.2256
supportedControl: 1.2.840.113556.1.4.2309
supportedControl: 1.2.840.113556.1.4.2330
supportedControl: 1.2.840.113556.1.4.2354
supportedCapabilities: 1.2.840.113556.1.4.800
supportedCapabilities: 1.2.840.113556.1.4.1670
supportedCapabilities: 1.2.840.113556.1.4.1791
supportedCapabilities: 1.2.840.113556.1.4.1935
supportedCapabilities: 1.2.840.113556.1.4.2080
supportedCapabilities: 1.2.840.113556.1.4.2237
subschemaSubentry: CN=Aggregate,CN=Schema,CN=Configuration,DC=tryhackme,DC=loc
serverName: CN=DC,CN=Servers,CN=Default-First-Site-Name,CN=Sites,CN=Configurat
 ion,DC=tryhackme,DC=loc
schemaNamingContext: CN=Schema,CN=Configuration,DC=tryhackme,DC=loc
namingContexts: DC=tryhackme,DC=loc
namingContexts: CN=Configuration,DC=tryhackme,DC=loc
namingContexts: CN=Schema,CN=Configuration,DC=tryhackme,DC=loc
namingContexts: DC=DomainDnsZones,DC=tryhackme,DC=loc
namingContexts: DC=ForestDnsZones,DC=tryhackme,DC=loc
isSynchronized: TRUE
highestCommittedUSN: 114846
dsServiceName: CN=NTDS Settings,CN=DC,CN=Servers,CN=Default-First-Site-Name,CN
 =Sites,CN=Configuration,DC=tryhackme,DC=loc
dnsHostName: DC.tryhackme.loc
defaultNamingContext: DC=tryhackme,DC=loc
currentTime: 20250728181159.0Z
configurationNamingContext: CN=Configuration,DC=tryhackme,DC=loc

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1


```

##### Enum4linux-ng
enum4linux-ng is a tool that automates various enumeration techniques against Windows systems, including user enumeration. It utilizes SMB and RPC protocols to gather information such as user lists, group memberships, and share details.

We can run the following command to get as much information as possible from the DC:

```enum4linux-ng -A 10.211.11.10 -oA results.txt```

- -A: Performs all available enumeration functions (users, groups, shares, password policy, RID cycling, OS information and NetBIOS information).
- -oA: Writes output to YAML and JSON files.

###### RPC Enumeration (Null Sessions)
Microsoft Remote Procedure Call (MSRPC) is a protocol that enables a program running on one computer to request services from a program on another computer, without needing to understand the underlying details of the network. RPC services can be accessed over the SMB protocol. When SMB is configured to allow null sessions that do not require authentication, an unauthenticated user can connect to the IPC$ share and enumerate users, groups, shares, and other sensitive information from the system or domain.

We can run the following command to verify null session access with:

```rpcclient -U "" 10.211.11.10 -N```

- -U: Used to specify the username, in our case, we are using an empty string for anonymous login.
- -N: Tells RPC not to prompt us for a password.
If successful, we can enumerate users with: enumdomusers


### step 4 : Password Spraying


Password spraying is an attack technique where a small set of common passwords is tested across many accounts. Unlike brute-force attacks, password spraying avoids account lockouts by testing each account with only a few attempts, exploiting poor password practices common in many organisations. Password spraying is often effective because many organisations:

- Require frequent password changes, leading users to pick predictable  patterns (for example, Summer2025!).
- Don't enforce their policies well.
- Reuse common passwords across multiple accounts.

Common password lists for spraying include:

- Seasonal passwords.
- Default passwords used by IT teams (Password123).
- Passwords leaked in data breaches, like rockyou.txt.

#### Password Policy
Before we can start our attack, it is essential to understand our target's password policy. This will allow us to retrieve information about the minimum password length, complexity, and the number of failed attempts that will lock out an account.

rpcclient

We can use rpcclient via a null session to query the DC for the password policy:

``` rpcclient -U "" 10.211.11.10 -N ```

And then we can run the getdompwinfo command:

```sh

$ rpcclient -U "" 10.211.11.10 -N              
rpcclient $> getdompwinfo
min_password_length: 7
password_properties: 0x00000001
	DOMAIN_PASSWORD_COMPLEX
rpcclient $> 


```

#### CrackMapExec

CrackMapExec is a well-known network service exploitation tool that we will use throughout this module. It allows us to perform enumeration, command execution, and post-exploitation attacks in Windows environments. It supports various network protocols, such as SMB, LDAP, RDP, and SSH. If anonymous access is permitted, we can retrieve the password policy without credentials with the following command:

```sh

$ crackmapexec smb 10.211.11.10 --pass-pol
/usr/lib/python3/dist-packages/cme/cli.py:37: SyntaxWarning: invalid escape sequence '\ '
  formatter_class=RawTextHelpFormatter)
/usr/lib/python3/dist-packages/cme/protocols/winrm.py:324: SyntaxWarning: invalid escape sequence '\S'
  self.conn.execute_cmd("reg save HKLM\SAM C:\\windows\\temp\\SAM && reg save HKLM\SYSTEM C:\\windows\\temp\\SYSTEM")
/usr/lib/python3/dist-packages/cme/protocols/winrm.py:338: SyntaxWarning: invalid escape sequence '\S'
  self.conn.execute_cmd("reg save HKLM\SECURITY C:\\windows\\temp\\SECURITY && reg save HKLM\SYSTEM C:\\windows\\temp\\SYSTEM")
/usr/lib/python3/dist-packages/cme/protocols/smb/smbexec.py:49: SyntaxWarning: invalid escape sequence '\p'
  stringbinding = 'ncacn_np:%s[\pipe\svcctl]' % self.__host
/usr/lib/python3/dist-packages/cme/protocols/smb/smbexec.py:93: SyntaxWarning: invalid escape sequence '\{'
  command = self.__shell + 'echo '+ data + ' ^> \\\\127.0.0.1\\{}\\{} 2^>^&1 > %TEMP%\{} & %COMSPEC% /Q /c %TEMP%\{} & %COMSPEC% /Q /c del %TEMP%\{}'.format(self.__share_name, self.__output, self.__batchFile, self.__batchFile, self.__batchFile)
SMB         10.211.11.10    445    DC               [*] Windows Server 2019 Datacenter 17763 x64 (name:DC) (domain:tryhackme.loc) (signing:True) (SMBv1:True)
SMB         10.211.11.10    445    DC               [+] Dumping password info for domain: TRYHACKME
SMB         10.211.11.10    445    DC               Minimum password length: 7
SMB         10.211.11.10    445    DC               Password history length: 24
SMB         10.211.11.10    445    DC               Maximum password age: 41 days 23 hours 53 minutes 
SMB         10.211.11.10    445    DC               
SMB         10.211.11.10    445    DC               Password Complexity Flags: 000001
SMB         10.211.11.10    445    DC               	Domain Refuse Password Change: 0
SMB         10.211.11.10    445    DC               	Domain Password Store Cleartext: 0
SMB         10.211.11.10    445    DC               	Domain Password Lockout Admins: 0
SMB         10.211.11.10    445    DC               	Domain Password No Clear Change: 0
SMB         10.211.11.10    445    DC               	Domain Password No Anon Change: 0
SMB         10.211.11.10    445    DC               	Domain Password Complex: 1
SMB         10.211.11.10    445    DC               
SMB         10.211.11.10    445    DC               Minimum password age: 1 day 4 minutes 
SMB         10.211.11.10    445    DC               Reset Account Lockout Counter: 2 minutes 
SMB         10.211.11.10    445    DC               Locked Account Duration: 2 minutes 
SMB         10.211.11.10    445    DC               Account Lockout Threshold: 10
SMB         10.211.11.10    445    DC               Forced Log off Time: Not Set
                                             

```