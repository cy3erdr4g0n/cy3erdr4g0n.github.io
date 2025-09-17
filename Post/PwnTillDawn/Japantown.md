# Title 


## Target ip 10.150.150.21


## Enumeration


###  Port scaning 

```sh

$ nmap -sS 10.150.150.21 -A -Pn    
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-27 07:25 WAT
Nmap scan report for 10.150.150.21
Host is up (0.14s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 8e:76:47:5b:e4:5e:ac:c4:f3:37:7f:ab:03:8d:15:20 (RSA)
|   256 f9:d4:01:a0:71:ee:66:ae:d6:dc:c4:39:2d:ab:04:c4 (ECDSA)
|_  256 f4:4c:5d:62:f1:d1:04:f6:7f:ea:bb:ee:82:d9:9b:6f (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
| http-robots.txt: 1 disallowed entry 
|_*/2020/12/you-know-what-this-is-for.png
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Japantown &#8211; &#8211; experience &amp; live Asia
|_http-generator: WordPress 5.3.6
Device type: general purpose
Running: Linux 4.X|5.X
OS CPE: cpe:/o:linux:linux_kernel:4 cpe:/o:linux:linux_kernel:5
OS details: Linux 4.15 - 5.19
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 111/tcp)
HOP RTT       ADDRESS
1   162.78 ms 10.66.66.1
2   163.07 ms 10.150.150.21

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 22.20 seconds
                                                                 

```

### Directory brute-force

```sh

$  gobuster dir  -u 10.150.150.21  -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt  
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.150.150.21
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.6
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/.htaccess            (Status: 403) [Size: 278]
/.hta                 (Status: 403) [Size: 278]
/.htpasswd            (Status: 403) [Size: 278]
/blog                 (Status: 301) [Size: 313] [--> http://10.150.150.21/blog/]
/index.php            (Status: 301) [Size: 0] [--> http://10.150.150.21/]
/javascript           (Status: 301) [Size: 319] [--> http://10.150.150.21/javascript/]
/robots.txt           (Status: 200) [Size: 111]
/server-status        (Status: 403) [Size: 278]
/wp-admin             (Status: 301) [Size: 317] [--> http://10.150.150.21/wp-admin/]
/wp-content           (Status: 301) [Size: 319] [--> http://10.150.150.21/wp-content/]
/wp-includes          (Status: 301) [Size: 320] [--> http://10.150.150.21/wp-includes/]
/xmlrpc.php           (Status: 405) [Size: 42]
Progress: 4746 / 4747 (99.98%)
===============================================================
Finished
===============================================================

```

## Step

###  flag 4

- get the flag4 at `http://10.150.150.21/robots.txt`


### flag 5

- get the flag at `http://10.150.150.21/blog/index.php/feed/`







