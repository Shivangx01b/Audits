## Introduction

XML External Entity (XXE) is a vulnerability that can appear when an application parses XML. Before diving into what XXE is you need to have a solid understanding of XML first.

### XML Basics

Extensible Markup Language (XML) is a language designed to store and transport data similar to JSON. A sample of what XML looks like can be found below:

```xml
<?xml version="1.0" encoding="UTF-8"?> <bookstore> <book category="cooking"> <title lang="en">Everyday Italian</title> <author>Giada De Laurentiis</author> <year>2005</year> <price>30.00</price> </book> <book category="children"> <title lang="en">Harry Potter</title> <author>J K. Rowling</author> <year>2005</year> <price>29.99</price> </book> </bookstore>
```

On the first line you can see the prolog which contains the XML version and encoding. Tip if you ever see this in burp you should immediately test for XXE:
```<?xml version="1.0" encoding="UTF-8"?>```
Under that you see the ```<bookstore>``` tag which represents the root node. There are two child nodes called ```<book>``` and each of these contain sub child nodes called ```<title>,<author>,<year>,<price>```.

```xml
<root> <child> <subchild>.....</subchild> </child> </root>
```

That’s the basic structure of XML but there is a little more you should know. There is something called document type definition (DTD) which defines the structure and the legal elements and attributes of an XML document as shown below:

```xml
<?xml version="1.0"?> <!DOCTYPE note [ <!ENTITY user "Shivang"> <!ENTITY message "got em"> ]>
<test><name>&user;</name></test>
```

As shown above there is something called an ENTITY. This acts a variable. In this example the entity ```user``` holds the text ```Shivang```. This entity can be called by typing ```&user;``` and it will be replaced by the text ```Shivang```.

You can also use something called an external entity which will load its data from an external source. This can be used to get contents from a URL or a file on disk as shown below:

```
1. <!DOCTYPE foo [ <!ENTITY ext SYSTEM "http://example.com" > ]>
2. <!DOCTYPE foo [ <!ENTITY ext SYSTEM "file:///path/to/file" > ]>
```

### LAB

I mentioned that you can use external entities to grab data from a file on disk and store it in a variable. What if we tried to read data from the ```/etc/passwd``` file and store it in a variable? Note that in order to read the data the entity must be returned in the response. Knowing that lets try to exploit our test environment.
While in burp I captured the following POST request which seems to be using XML to send data to the back-end system. Whenever you see XML you should test for XXE.

![Alt Text](https://i.ibb.co/1mHY39z/Capture.png)




To test for XXE simply put in your malicious external entity and replace each node value with it as shown below:

![Alt Text](https://i.ibb.co/8YjW4wK/Capture.png)


As shown above I created an external entity to grab the data in the “/etc/passwd” file and stored it in the entity XXE. I then placed the variable in the “<productID>” node. If the server doesn’t block external entities the response will be reflected you. You will then be able to retrieve the contents of the “/etc/passwd” file as shown below:

 
  
![Alt Text](https://i.ibb.co/P1xYQF2/Capture.png)

 
 ### Refrence

- Lab Used - https://portswigger.net/web-security
 
- CheatSheet - https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XXE%20Injection
