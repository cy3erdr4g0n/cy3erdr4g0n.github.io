# Overview 

# step 1

```bash 

nmap -sC -sV 10.10.55.161

```

```
result 

$

Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-03-12 12:48 WAT
Nmap scan report for 10.10.55.161
Host is up (0.16s latency).
Not shown: 999 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 52:aa:41:a2:da:c0:4f:94:ab:a1:9c:43:91:d2:1a:7f (ECDSA)
|_  256 f5:4a:9a:b7:63:f9:a1:2d:df:b6:b4:8e:b1:c0:b3:82 (ED25519)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 19.74 seconds

```

note : that the ssh is the only port open so we login through the ssh

```bash

ssh nopriv@10.10.55.161

```

