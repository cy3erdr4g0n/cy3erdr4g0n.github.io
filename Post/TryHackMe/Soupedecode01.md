# Title : Soupedecode 01

## overview

```sh

Soupedecode is an intense and engaging challenge in which players must compromise a domain controller by exploiting Kerberos authentication, navigating through SMB shares, performing password spraying, and utilizing Pass-the-Hash techniques. Prepare to test your skills and strategies in this multifaceted cyber security adventure.

Note: Please allow 4 minutes for the VM to properly boot up.


```

- we are be given `10.10.115.53` has our target

## REcon

### Port scanning

```sh

$ nmap -sV  10.10.115.53 -A
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-15 10:06 WAT
Nmap scan report for 10.10.115.53
Host is up (0.24s latency).
Not shown: 988 filtered tcp ports (no-response)
PORT     STATE SERVICE      VERSION
53/tcp   open  tcpwrapped
88/tcp   open  kerberos-sec Microsoft Windows Kerberos (server time: 2025-08-15 09:08:11Z)
135/tcp  open  tcpwrapped
139/tcp  open  netbios-ssn  Microsoft Windows netbios-ssn
389/tcp  open  tcpwrapped
445/tcp  open  tcpwrapped
464/tcp  open  tcpwrapped
593/tcp  open  tcpwrapped
636/tcp  open  tcpwrapped
3268/tcp open  ldap         Microsoft Windows Active Directory LDAP (Domain: SOUPEDECODE.LOCAL0., Site: Default-First-Site-Name)
3269/tcp open  tcpwrapped
3389/tcp open  tcpwrapped
| ssl-cert: Subject: commonName=DC01.SOUPEDECODE.LOCAL
| Not valid before: 2025-06-17T21:35:42
|_Not valid after:  2025-12-17T21:35:42
| rdp-ntlm-info: 
|   Target_Name: SOUPEDECODE
|   NetBIOS_Domain_Name: SOUPEDECODE
|   NetBIOS_Computer_Name: DC01
|   DNS_Domain_Name: SOUPEDECODE.LOCAL
|   DNS_Computer_Name: DC01.SOUPEDECODE.LOCAL
|   Product_Version: 10.0.20348
|_  System_Time: 2025-08-15T09:08:20+00:00
|_ssl-date: 2025-08-15T09:09:02+00:00; -1s from scanner time.
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows 2022|2012|2016 (89%)
OS CPE: cpe:/o:microsoft:windows_server_2022 cpe:/o:microsoft:windows_server_2012:r2 cpe:/o:microsoft:windows_server_2016
Aggressive OS guesses: Microsoft Windows Server 2022 (89%), Microsoft Windows Server 2012 R2 (85%), Microsoft Windows Server 2016 (85%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: DC01; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2025-08-15T09:08:24
|_  start_date: N/A
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled and required

TRACEROUTE (using port 135/tcp)
HOP RTT       ADDRESS
1   234.95 ms 10.11.0.1
2   234.82 ms 10.10.115.53

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 256.09 seconds


$ nmap -p 88,135,139,389,445 -sV -sC  10.10.115.53 
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-15 10:14 WAT
Nmap scan report for 10.10.115.53
Host is up (0.42s latency).

PORT    STATE SERVICE       VERSION
88/tcp  open  kerberos-sec  Microsoft Windows Kerberos (server time: 2025-08-15 09:14:51Z)
135/tcp open  msrpc         Microsoft Windows RPC
139/tcp open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp open  ldap          Microsoft Windows Active Directory LDAP (Domain: SOUPEDECODE.LOCAL0., Site: Default-First-Site-Name)
445/tcp open  microsoft-ds?
Service Info: Host: DC01; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled and required
|_clock-skew: -1s
| smb2-time: 
|   date: 2025-08-15T09:15:39
|_  start_date: N/A

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 97.05 seconds

                             
```



### Step 2 : Network Enumeration With SMB

##### Listing SMB Shares

```sh

$ smbclient  -L //10.10.115.53
Password for [WORKGROUP\graceman]:

	Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	backup          Disk      
	C$              Disk      Default share
	IPC$            IPC       Remote IPC
	NETLOGON        Disk      Logon server share 
	SYSVOL          Disk      Logon server share 
	Users           Disk      
tstream_smbXcli_np_destructor: cli_close failed on pipe srvsvc. Error was NT_STATUS_IO_TIMEOUT
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.10.115.53 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available

```

###### Accessing SMB Shares

```sh
$ smbclient  //10.10.115.53/Users  -N
Try "help" to get a list of possible commands.
smb: \> ls
NT_STATUS_ACCESS_DENIED listing \*
smb: \> exit

$ smbclient  //10.10.115.53/backup  -N
Try "help" to get a list of possible commands.
smb: \> ls
NT_STATUS_ACCESS_DENIED listing \*
smb: \> exit

$ smbclient  //10.10.115.53/SYSVOL  -N
Try "help" to get a list of possible commands.
smb: \> ls
NT_STATUS_ACCESS_DENIED listing \*
smb: \> exit

$ smbclient  //10.10.115.53/NETLOGON  -N
Try "help" to get a list of possible commands.
smb: \> ls
NT_STATUS_ACCESS_DENIED listing \*
smb: \> exit

```

## Using the “Guest” account we can check the shares:

```sh
$ nxc smb 10.10.115.53 -u "Guest" -p "" --shares
SMB         10.10.115.53    445    DC01             [*] Windows Server 2022 Build 20348 x64 (name:DC01) (domain:SOUPEDECODE.LOCAL) (signing:True) (SMBv1:False)
SMB         10.10.115.53    445    DC01             [+] SOUPEDECODE.LOCAL\Guest: 
SMB         10.10.115.53    445    DC01             [*] Enumerated shares
SMB         10.10.115.53    445    DC01             Share           Permissions     Remark
SMB         10.10.115.53    445    DC01             -----           -----------     ------
SMB         10.10.115.53    445    DC01             ADMIN$                          Remote Admin
SMB         10.10.115.53    445    DC01             backup                          
SMB         10.10.115.53    445    DC01             C$                              Default share
SMB         10.10.115.53    445    DC01             IPC$            READ            Remote IPC
SMB         10.10.115.53    445    DC01             NETLOGON                        Logon server share 
SMB         10.10.115.53    445    DC01             SYSVOL                          Logon server share 
SMB         10.10.115.53    445    DC01             Users     

```

# user Emuneration

- which i use metaploit for that 
- after i spin my mfconsole

```sh

# auxiliary/scanner/smb/smb_lookupsid

$ use auxiliary/scanner/smb/smb_lookupsid

# than set your options

## Results


```

### Step 3 : Domain Enumeration

#### LDAP Enumeration (Anonymous Bind)

```sh

$ ldapsearch -x -H ldap://10.10.115.53 -s base
# extended LDIF
#
# LDAPv3
# base <> (default) with scope baseObject
# filter: (objectclass=*)
# requesting: ALL
#

#
dn:
domainFunctionality: 7
forestFunctionality: 7
domainControllerFunctionality: 7
rootDomainNamingContext: DC=SOUPEDECODE,DC=LOCAL
ldapServiceName: SOUPEDECODE.LOCAL:dc01$@SOUPEDECODE.LOCAL
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
subschemaSubentry: CN=Aggregate,CN=Schema,CN=Configuration,DC=SOUPEDECODE,DC=L
 OCAL
serverName: CN=DC01,CN=Servers,CN=Default-First-Site-Name,CN=Sites,CN=Configur
 ation,DC=SOUPEDECODE,DC=LOCAL
schemaNamingContext: CN=Schema,CN=Configuration,DC=SOUPEDECODE,DC=LOCAL
namingContexts: DC=SOUPEDECODE,DC=LOCAL
namingContexts: CN=Configuration,DC=SOUPEDECODE,DC=LOCAL
namingContexts: CN=Schema,CN=Configuration,DC=SOUPEDECODE,DC=LOCAL
namingContexts: DC=DomainDnsZones,DC=SOUPEDECODE,DC=LOCAL
namingContexts: DC=ForestDnsZones,DC=SOUPEDECODE,DC=LOCAL
isSynchronized: TRUE
highestCommittedUSN: 180265
dsServiceName: CN=NTDS Settings,CN=DC01,CN=Servers,CN=Default-First-Site-Name,
 CN=Sites,CN=Configuration,DC=SOUPEDECODE,DC=LOCAL
dnsHostName: DC01.SOUPEDECODE.LOCAL
defaultNamingContext: DC=SOUPEDECODE,DC=LOCAL
currentTime: 20250815092520.0Z
configurationNamingContext: CN=Configuration,DC=SOUPEDECODE,DC=LOCAL

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1

```


