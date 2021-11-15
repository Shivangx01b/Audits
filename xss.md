## Introduction

Cross site scripting (XSS) is one of the most popular vulnerabilities in today’s web applications. This vulnerability has been on the OWASP top 10 for several years and doesn’t seem to be going away. This vulnerability can be used to execute malicious JavaScript in a user’s web browser. This could then be used to steal users JWT tokens, CSRF tokens, and cookies. There are three types of XSS reflected, stored, and DOM based. The following sections will discuss each of these.


### Reflected XSS

Suppose you have a application where you put something and it's reflected back in the reponse either in web app page or in elements of the source like

![Alt Text](https://i.ibb.co/Qb266ws/like.png)

We can try bacis payload to see if we can trigger xss

![Alt Text](https://i.ibb.co/Qv4TwWV/xss.png)

Some time we need to break out the context from html or js depending upon where our input is refelected. For example

#### XSS in HTML tag attributes

When the XSS context is into an HTML tag attribute value, you might sometimes be able to terminate the attribute value, close the tag, and introduce a new one. For example:

```"><script>alert(document.domain)</script>```

More commonly in this situation, angle brackets are blocked or encoded, so your input cannot break out of the tag in which it appears. Provided you can terminate the attribute value, you can normally introduce a new attribute that creates a scriptable context, such as an event handler. For example:

```" autofocus onfocus=alert(document.domain) x="```

The above payload creates an onfocus event that will execute JavaScript when the element receives the focus, and also adds the autofocus attribute to try to trigger the onfocus event automatically without any user interaction. Finally, it adds x=" to gracefully repair the following markup.

Sometimes the XSS context is into a type of HTML tag attribute that itself can create a scriptable context. Here, you can execute JavaScript without needing to terminate the attribute value. For example, if the XSS context is into the href attribute of an anchor tag, you can use the javascript pseudo-protocol to execute script. For example:

```<a href="javascript:alert(document.domain)">```

#### XSS into JavaScript

When the XSS context is some existing JavaScript within the response, a wide variety of situations can arise, with different techniques necessary to perform a successful exploit.

Terminating the existing script
In the simplest case, it is possible to simply close the script tag that is enclosing the existing JavaScript, and introduce some new HTML tags that will trigger execution of JavaScript. For example, if the XSS context is as follows:
```
<script>
...
var input = 'controllable data here';
...
</script>
```
then you can use the following payload to break out of the existing JavaScript and execute your own:

```</script><img src=1 onerror=alert(document.domain)>```

The reason this works is that the browser first performs HTML parsing to identify the page elements including blocks of script, and only later performs JavaScript parsing to understand and execute the embedded scripts. The above payload leaves the original script broken, with an unterminated string literal. But that doesn't prevent the subsequent script being parsed and executed in the normal way.

n cases where the XSS context is inside a quoted string literal, it is often possible to break out of the string and execute JavaScript directly. It is essential to repair the script following the XSS context, because any syntax errors there will prevent the whole script from executing.

Some useful ways of breaking out of a string literal are:

```'-alert(document.domain)-'```
```';alert(document.domain)//```

There are many ways to break out context which can be found here  https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XSS%20Injection#filter-bypass-and-exotic-payloads

### Reference

- Lab https://portswigger.net/web-security/all-labs
- CheatSheet https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XSS%20Injection
