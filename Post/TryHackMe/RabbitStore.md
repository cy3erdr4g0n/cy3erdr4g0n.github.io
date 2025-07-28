# Title : Rabbit Store


## step 1

-  add your ip and domain name to your /etc/hosts

```bash

10.10.90.213   cloudsite.thm storage.cloudsite.thm

```

## Scanning / Enumeration

```bash

$ nmap -sV -sC -Pn 10.10.90.213
Starting Nmap 7.95 ( https://nmap.org ) at 2025-07-16 00:49 WAT
Nmap scan report for 10.10.90.213
Host is up (0.59s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.10 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 3f:da:55:0b:b3:a9:3b:09:5f:b1:db:53:5e:0b:ef:e2 (ECDSA)
|_  256 b7:d3:2e:a7:08:91:66:6b:30:d2:0c:f7:90:cf:9a:f4 (ED25519)
80/tcp open  http    Apache httpd 2.4.52
|_http-title: Did not follow redirect to http://cloudsite.thm/
|_http-server-header: Apache/2.4.52 (Ubuntu)
Service Info: Host: 127.0.1.1; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 49.10 seconds

```

