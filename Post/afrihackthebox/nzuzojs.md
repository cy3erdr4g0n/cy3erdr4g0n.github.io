# Title : nzuzojs 


## step 1

- add the ip address to your `/etc/hosts`

```bash 

$ sudo nano /etc/hosts


# and paste this

10.0.1.2        nzuzojs.afrihackbox.ctf


# or 

$ sudo echo "10.0.1.2        nzuzojs.afrihackbox.ctf" >> /etc/hosts


```


## step 2 : Enumeration 


```bash

gobuster dir  -u  http://nzuzojs.afrihackbox.ctf/  -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt 
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://nzuzojs.afrihackbox.ctf/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.6
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/.gitattributes       (Status: 200) [Size: 378]
/.gitignore           (Status: 200) [Size: 649]
/css                  (Status: 301) [Size: 169] [--> http://nzuzojs.afrihackbox.ctf/css/]
/fonts                (Status: 301) [Size: 169] [--> http://nzuzojs.afrihackbox.ctf/fonts/]
/images               (Status: 301) [Size: 169] [--> http://nzuzojs.afrihackbox.ctf/images/]
/index.html           (Status: 200) [Size: 14582]
/js                   (Status: 301) [Size: 169] [--> http://nzuzojs.afrihackbox.ctf/js/]
/robots.txt           (Status: 200) [Size: 42]
Progress: 4746 / 4747 (99.98%)
===============================================================
Finished
===============================================================


```





## step 3 


- i check the `robots.txt`

```bash

ETSCTF_a88835fb57784ff59de0fdb55841e744

```

## i inspect the page 

- i see the second flag in the main.js

```bash

 ETSCTF_FLAG="ETSCTF_9b52b578a16ef83564dae47583343758"

```

- i check the index.html source 

```bash
ETSCTF_ea6181137a8ccf075e9cd8f7ad92de00 
```

- i check the secret.html

```bash

ETSCTF_4ceaf8a75861afb883729a9cad03e357

```

