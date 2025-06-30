# Title : TakeOver---badr


## Description 

```bash

Hello there,

I am the CEO and one of the co-founders of futurevera.thm. In Futurevera, we believe that the future is in space. We do a lot of space research and write blogs about it. We used to help students with space questions, but we are rebuilding our support.

Recently blackhat hackers approached us saying they could takeover and are asking us for a big ransom. Please help us to find what they can takeover.

Our website is located at https://futurevera.thm

Hint: Don't forget to add the 10.10.57.136 in /etc/hosts for futurevera.thm ; )

```

## step 

- add `10.10.57.136` to /etc/hosts

# Enumeration


```bash

$ gobuster vhost -u https://futurevera.thm -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -k --append-domain 
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:             https://futurevera.thm
[+] Method:          GET
[+] Threads:         10
[+] Wordlist:        /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt
[+] User Agent:      gobuster/3.6
[+] Timeout:         10s
[+] Append Domain:   true
===============================================================
Starting gobuster in VHOST enumeration mode
===============================================================
Found: blog.futurevera.thm Status: 421 [Size: 408]
Found: support.futurevera.thm Status: 421 [Size: 411]
Progress: 304 / 19967 (1.52%)^C
[!] Keyboard interrupt detected, terminating.
Progress: 326 / 19967 (1.63%)
===============================================================
Finished
===============================================================

```

- i add the two sub-domain to my `/etc/hosts`


- However, while reviewing the certificate details for the website “support.futurevera.thm” I discovered something intriguing.
- To examine the certificate information, click the “View Certificate” button.

- I noticed, that there is a different subdomain information in the “DNS Name” section. The word “secret” has always piqued my interest.

- i add it to my /etc/hosts

- on broswer i pasta my new find subdomain and it give you flag in the urls




# flag

```bash

http://flag{beea0d6edfcee06a59b83fb50ae81b2f}.s3-website-us-west-3.amazonaws.com/

```
