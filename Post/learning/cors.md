# CORS (Cross-Origin Resource Sharing) Full Course Content

## 🔰 Module 1: Introduction to Same-Origin Policy (SOP)

- What is Same-Origin Policy?
- Origin structure: Scheme + Host + Port
- Why browsers enforce SOP
- SOP limitations in modern applications
- Difference between SOP and CORS

### 🛠 Lab:
- Test basic SOP by loading resources from another origin using browser console

---

## 🌐 Module 2: What is CORS?

- Definition and purpose of CORS
- CORS request flow (simple vs preflight)
- Important CORS headers:
  - `Access-Control-Allow-Origin`
  - `Access-Control-Allow-Methods`
  - `Access-Control-Allow-Headers`
  - `Access-Control-Allow-Credentials`
- Preflight requests (OPTIONS method)
- Browser behavior

### 🛠 Lab:
- Build two apps (api.local and client.local)
- Use `fetch()` and `curl` to test CORS interaction

---

## ⚠️ Module 3: CORS Misconfigurations

- Wildcard origin with credentials (`*` + `withCredentials: true`)
- Reflected origin (`Access-Control-Allow-Origin: <user_input>`)
- Trusting null origin
- Improper subdomain trust (`*.example.com`)
- Regex flaws in origin matching

### 🛠 Lab:
- Set up a vulnerable Node.js/PHP server with misconfigured CORS headers
- Exploit using JavaScript fetch() to read sensitive API responses

---

## 🛡 Module 4: CORS & Credential Theft

- Danger of `Access-Control-Allow-Credentials: true`
- How cookies and tokens leak via CORS
- Using JavaScript to send credentials across origins
- Real-world bug bounty examples

### 🛠 Lab:
- Create attacker.com and victim.com
- Exploit CORS misconfig to extract `Set-Cookie`-protected data

---

## 🔐 Module 5: Bypassing Origin Whitelists

- Regex bypass (e.g., `https://evil.com.example.com`)
- Using `null` origin via iframe sandboxing
- CRLF injection to break origin validation
- Parser inconsistencies

### 🛠 Lab:
- Bypass origin checks using subdomain injection or iframe tricks

---

## 🧰 Module 6: Tools for CORS Testing

- Manual testing with `curl -H "Origin: evil.com"`
- Burp Suite + CORS extension
- CORStest (Python tool)
- CORS Scanner in browser DevTools

### 🛠 Lab:
- Scan and analyze CORS behavior on public APIs
- Automate with CORStest

---

## 📚 Module 7: CORS in Bug Bounty & Real World

- Top real-world CORS vulnerabilities from HackerOne, Bugcrowd
- When is a CORS bug critical?
- Report writing tips for CORS bugs
- Bounty scope awareness

### 🛠 Exercise:
- Read and summarize 3 real-world bug reports involving CORS
- Write your own sample CORS report (PoC + impact + fix)

---

## 🧪 Bonus Module: CORS + Other Attacks

- CORS + IDOR: Accessing other users' data
- CORS + CSRF: Cross-origin actions with cookies
- CORS + JSONP (legacy pattern)
- CORS + XSS: Chained impact

### 🛠 Lab:
- Combine a misconfigured CORS endpoint with IDOR or CSRF to extract private data

---

## ✅ Final Deliverables

- CORS Attack Lab (Node.js or PHP)
- CORS Pentesting Checklist
- Final project: Exploit your own vulnerable API with misconfigured CORS
Would you like me to turn this into a downloadable .md file or host it in a GitHub repo for easy use?