## Introduction

Server-Side Request Forgery (SSRF) occurs when an attacker forces an application to make HTTP requests on their behalf. This can be used to read data from internal applications. Most people leverage this vulnerability to post or read data from sensitive endpoints such as AWS and Gcloud metadata service, FTP service, LDAP service, and local files.

### SSRF
When looking for SSRF vulnerabilities I typically search for requests that have a URL as a parameter value. If the response is reflected back to the attacker you could have a possible SSRF vulnerability. I will then change the URL to google.com and if I see a response then I can assume the endpoint is vulnerable. The next step is to find a vulnerable endpoint on the systems local host or on an endpoint in the local network.

![Alt Text](https://i.ibb.co/CBqp9r0/Capture.png)

In the above requests I changed the “stockApi” value to an admin directory on the systems local IP. The request will be performed by the target application thus it will perform a request against itself. This endpoint has an admin application hosted on the local host, normally this would be impossible to access from the internet but because of SSRF we can.

![Alt Text](https://i.ibb.co/Yc98yzm/Capture.png)

If we render the html response, we can see that we are able to access an internal admin application hosted on the target system.
The hardest part about SSRF is proving the impact of the vulnerability. You have to find an application to exploit that would be impossible without using SSRF. If you can’t find an endpoint on the local host you can also send requests to servers on the targets internal network. If you find yourself on an application hosted on Google Cloud or other cloud providers you can try to read the metadata service to retrieve API keys and credentials.

### Reference

- Lab https://portswigger.net/web-security/ssrf/lab-basic-ssrf-against-localhost
- CheatSheet https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Request%20Forgery

