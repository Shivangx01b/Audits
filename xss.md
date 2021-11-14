## Introduction

Cross site scripting (XSS) is one of the most popular vulnerabilities in today’s web applications. This vulnerability has been on the OWASP top 10 for several years and doesn’t seem to be going away. This vulnerability can be used to execute malicious JavaScript in a user’s web browser. This could then be used to steal users JWT tokens, CSRF tokens, and cookies. There are three types of XSS reflected, stored, and DOM based. The following sections will discuss each of these.


### Reflected XSS

Suppose you have a application where you put something and it's reflected back in the reponse either in web app page or in elements of the source
