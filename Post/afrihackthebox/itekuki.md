# Title : itekuki


## Enumeration


```bash

Starting Nmap 7.95 ( https://nmap.org ) at 2025-07-04 13:23 WAT
Nmap scan report for 10.0.1.3
Host is up (0.15s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
80/tcp open  http    nginx 1.22.1
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).
|_http-server-header: nginx/1.22.1

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 14.42 seconds

```



- since it having http port `80` on i route to it on my browser it response was `Cookie 'user' is not set!`

- inspect it on the application tab in the cookie session, i see the first flag `ETSCTF_417baec3e039264518c3e2bec4142f8b`


- set cookie for user  to be `ETSCTF_417baec3e039264518c3e2bec4142f8b`

- see the second cookie i.e `ETSCTF_11fe7fe6e1310d18b7b4c155fc0f9441`

- in the cookie session i see user_json with value : `{"username":"proot","id":1000}`

- modify the user_json to `{"username":"root","id":0}`, and make the request again it return a response `ETSCTF_b1e664f972d523c76fd4e6c124a801de`