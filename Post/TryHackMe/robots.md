#  Title : Robots v1.7


## scanning


```bash

nmap -sC -sV 10.10.72.56
Starting Nmap 7.95 ( https://nmap.org ) at 2025-07-05 08:09 WAT
Nmap scan report for 10.10.72.56
Host is up (0.28s latency).
Not shown: 997 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.9p1 (protocol 2.0)
80/tcp   open  http    Apache httpd 2.4.61
| http-robots.txt: 3 disallowed entries 
|_/harming/humans /ignoring/human/orders /harm/to/self
|_http-title: 403 Forbidden
|_http-server-header: Apache/2.4.61 (Debian)
9000/tcp open  http    Apache httpd 2.4.52 ((Ubuntu))
|_http-server-header: Apache/2.4.52 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
Service Info: Host: robots.thm

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 22.43 seconds

```

- both port `80` and `9000`  is open and they both have `Apache` runing on them

# Web 80

- Vsiting `http://10.10.72.56/`, we encounter a 403 Forbidden page.

- nmap has already identified a `robots.txt` file on the server, which contains the following disallowed entries:

```bash

$ curl -s -L http://robots.thm/robots.txt

Disallow: /harming/humans
Disallow: /ignoring/human/orders
Disallow: /harm/to/self    

```

- checking the register page at `http://robots.thm/harm/to/self/register.php`, we see an additional message:

``` Your initial password will be md5(username+ddmm). ```

- i proceed by registering an account with:

```bash

Username: cyb

Date of Birth: 31/12/1900

```

- To log in, we can calculate our initial password (md5(username + ddmm)) as follows:

```bash

$ echo -n 'cyb3112' | md5sum
65ea19589193fb3553d479a61301dbc4  -

```

```bash

- To login use `cyb:65ea19589193fb3553d479a61301dbc4`

```



