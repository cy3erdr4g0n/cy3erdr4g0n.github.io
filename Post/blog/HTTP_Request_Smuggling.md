# title : HTTP Request Smuggling


# What is HTTP request smuggling?
HTTP request smuggling is a technique for interfering with the way a web site processes sequences of HTTP requests that are received from one or more users. Request smuggling vulnerabilities are often critical in nature, allowing an attacker to bypass security controls, gain unauthorized access to sensitive data, and directly compromise other application users.

Request smuggling is primarily associated with HTTP/1 requests. However, websites that support HTTP/2 may be vulnerable, depending on ththeeir back-end architecture.


- HTTP request smuggling was due the modern application haven a chain of application server at the application where the application request will pass through before it get to the main server at the backend  i.e `HTTP Request Smuggling occurs because modern web applications often rely on a chain of intermediary servers — such as reverse proxies, load balancers, web application firewalls (WAFs), or caching layers`
#
- HTTP request smuggling was possible pass a request without pausing one  i.e `HTTP Request Smuggling is possible because an attacker can craft a single HTTP request that is parsed differently by the front-end and back-end servers, allowing the attacker to "pass" or smuggle a second, hidden request inside the body of the first — all without pausing or needing a separate connection.`



## 
#
