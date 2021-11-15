## Introduction
SQL Injection (SQL) is a classic vulnerability that doesn’t seem to be going anywhere. This vulnerability can be exploited to dump the contents of an applications database. Databases typically hold sensitive information such as usernames and passwords so gaining access to this is basically game over. The most popular database is MySQL but you will run into others such as MSSQL, PostgreSQL, Oracle, and more. The way you exploit each of these is similar but different. A nice cheat sheet can be found on payloadallthethings:

### SQL Injection
I’ll be demonstrating how to exploit a PostgreSQL server today. The error message I got was a little less noticeable and could easily go undetected

![Alt Text](https://i.ibb.co/9nNWfg2/a.png)

If you notice I added ```'``` after Gifts which caused an error and these error depends from site to site. You can use sqlmap which can automate everything, we will copy the request from burp to a file ```req3.txt``` and run the command as

![Alt Text](https://i.ibb.co/nz1c8xW/sqlmap.png)

- Note: Sqlmap won't work on this lab as it's desinged in such a way

We then proceed to finding the number of columns being returned to the application. This can be done with the ```order by``` command.

![Alt Text](https://i.ibb.co/rMpd26G/order.png)

Basically, you ask the database “do you have 1 column?”, the server will then respond and says yes. You then ask ```do you have 2 columns?``` and the server responds again with yes. Then you ask ```do you have 3 columns?``` and the database errors out. So, you know the database table only contains 2 columns.
```' order by <Number here>--```
  
![Alt Text](https://i.ibb.co/Y8LM9VX/map.png)

 
As you can see the server responds back without any errors. This is basically telling us the server has 2 columns. The below request shows what happens when the server errors out indicating that number of columns doesn’t exists.
  
Knowing that there are only 2 columns we need to figure out which columns are used to display text on the application. We need to know this so we know which column to use when extracting data.
```' union select NULL,NULL— ```

![Alt Text](https://i.ibb.co/Vw9Rs94/gifts.png)

The union select command can be utilized to retrieve data from the backend database. Some database will error out if the column data type is incorrect. For this reason, we use the word “NULL” which in most cases will default to whatever data type the database is expecting. We discovered that there are only two columns so that’s why you only see two NULL columns being selected.
We need to find out which column is being used to display text on the screen. To do this we can replace each selected column with a string and see if it appears on the page.
```' union select NULL,'VULNERABLE'--```

![Alt Text](https://i.ibb.co/NW7Gmb3/vul.png)




