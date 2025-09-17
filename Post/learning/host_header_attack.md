# Title : HTTP Host header attacks\



```sh

Before we go deep into  HTTP Host header  let us start from explain what vhost is (is a configuration inside a web server (Apache, Nginx, etc.) that allows it to host multiple websites or applications on the same physical/virtual server and same IP address.)

```

- why is possible to host different (2 or more) application on a single or virtual server(cloud computing)

```sh

it possible due to HTTP Host header because in vhost 

- It relies on the HTTP Host header from the client’s request to decide which site to serve.

- Without vhosts, a single IP could only serve one website.

- the web server uses the HTTP Host header to know there services you want to access

```

##  How does the HTTP Host header solve this problem?
In both of these scenarios, the Host header is relied on to specify the intended recipient. A common analogy is the process of sending a letter to somebody who lives in an apartment building. The entire building has the same street address, but behind this street address there are many different apartments that each need to receive the correct mail somehow. One solution to this problem is simply to include the apartment number or the recipient's name in the address. In the case of HTTP messages, the Host header serves a similar purpose.

When a browser sends the request, the target URL will resolve to the IP address of a particular server. When this server receives the request, it refers to the Host header to determine the intended back-end and forwards the request accordingly.

##  What is an HTTP Host header attack?
HTTP Host header attacks exploit vulnerable websites that handle the value of the Host header in an unsafe way. If the server implicitly trusts the Host header, and fails to validate or escape it properly, an attacker may be able to use this input to inject harmful payloads that manipulate server-side behavior. Attacks that involve injecting a payload directly into the Host header are often known as "Host header injection" attacks.