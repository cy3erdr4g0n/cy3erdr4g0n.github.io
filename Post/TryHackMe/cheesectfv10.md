# Overview

## Cheese CTF

### Inspired by the great cheese talk of THM!

![](https://tryhackme.com/room/cheesectfv10)

add  your ip add to to /etc/hosts

```bash

$  sudo echo "cheese.thm         10.10.238.27" >> /etc/hosts

```


# Step 1 


run a scan against the ip address of your target:

```bash

$  nmap -p- -A -v -Pn cheese.thm

```

![](<img src=../../../../assets/images/chesse/image.png>)




```bash

# Result



```

## Enumeration
Checking out port 8080


