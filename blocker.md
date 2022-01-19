## Issue

Let's say we have a final data which needs to be pushed in cosmosdb which looks something like this
```
[{'1.36.189.175': ['tor', 'Hong Kong', 'Asia', 4760, 'HKT Limited', '2021-09-22']}, {'100.14.159.254': ['tor', 'United States', 'North America', 701, 'UUNET', '2021-09-22']}, {'100.14.23.208': ['tor', 'United States', 'North America', 701, 'UUNET', '2021-09-22']}, {'100.36.131.172': ['tor', 'United States', 'North America', 701, 'UUNET', '2021-09-22']}, {'101.100.146.147': ['tor', 'New Zealand', 'Oceania', 133579, 'MYREPUBLIC LIMITED', '2021-09-22']}, {'101.100.160.122': ['tor', 'Singapore', 'Asia', 56300, 'MyRepublic Ltd.', '2021-09-22']}, {'101.113.64.35': ['tor', 'Australia', 'Oceania', 133612, 'Vodafone Australia Pty Ltd', '2021-09-22']}, {'101.127.175.218': ['tor', 'Singapore', 'Asia', 55430, 'Starhub Ltd', '2021-09-22']}, {'101.182.114.158': ['tor', 'Australia', 'Oceania', 1221, 'Telstra Corporation Ltd', '2021-09-22']}, {'101.53.147.15': ['tor', 'India', 'Asia', 17439, 'Netmagic Datacenter Mumbai', '2021-09-22']}, {'101.53.147.96': ['tor', 'India', 'Asia', 17439, 'Netmagic Datacenter Mumbai', '2021-09-22']}, {'101.55.125.10': ['tor', 'South Korea', 'Asia', 55592, 'Korea Data Telecommunication Co., Ltd.', '2021-09-22']}, {'101.98.27.141': ['tor', 'New Zealand', 'Oceania', 9790, 'VocusGroup', '2021-09-22']}, {'101.99.90.171': ['tor', 'Malaysia', 'Asia', 45839, 'Shinjiru Technology Sdn Bhd', '2021-09-22']}, {'102.130.112.81': ['tor', 'South Africa', 'Africa', 37153, 'xneelo', '2021-09-22']}, {'102.130.113.29': ['tor', 'South Africa', 'Africa', 37153, 'xneelo', '2021-09-22']}, {'102.130.113.30': ['tor', 'South Africa', 'Africa', 37153, 'xneelo', '2021-09-22']}, {'102.130.113.37': ['tor', 'South Africa', 'Africa', 37153, 'xneelo', '2021-09-22']}, {'102.130.113.42': ['tor', 'South Africa', 'Africa', 37153, 'xneelo', '2021-09-22']}, {'102.130.113.9': ['tor', 'South Africa', 'Africa', 37153, 'xneelo', '2021-09-22']}, {'102.130.119.48': ['tor', 'South Africa', 'Africa', 37153, 'xneelo', '2021-09-22']}, {'102.68.86.53': ['tor', 'Kenya', 'Africa', 327813, 'Web4Africa', '2021-09-22']}, {'103.102.46.57': ['tor', 'Singapore', 'Asia', 38001, 'NewMedia Express Pte Ltd', '2021-09-22']}, {'103.119.112.78': ['tor', 'Netherlands', 'Europe', 174, 'COGENT-174', '2021-09-22']}, {'103.123.0.135': ['tor', 'Taiwan', 'Asia', 131632, 'LETSWIN TELECOM CO., LTD.', '2021-09-22']}, {'103.130.218.125': ['tor', 'Vietnam', 'Asia', 135951, 'Webico Company Limited', '2021-09-22']}, {'103.136.43.141': ['tor', 'Russia', 'Europe', 44812, 'Ip Server LLC', '2021-09-22']}, {'103.140.3.3': ['tor', 'Singapore', 'Asia', 139225, 'Whatbox Inc.', '2021-09-22']}, {'103.152.178.118': ['tor']}, {'103.152.79.249': ['tor']}, {'103.200.210.66': ['tor', 'Singapore', 'Asia', 63930, 'READY SERVER PTE LTD', '2021-09-22']}, {'103.212.70.118': ['tor', 'Malaysia', 'Asia', 55720, 'Gigabit Hosting Sdn Bhd', '2021-09-22']}, {'103.227.99.72': ['tor', 'India', 'Asia', 24309, 'Atria Convergence Technologies Pvt. Ltd. Broadband Internet Service Provider INDIA', '2021-09-22']}, {'103.228.53.155': ['tor', 'Malaysia', 'Asia', 55720, 'Gigabit Hosting Sdn Bhd', '2021-09-22']}, {'103.234.220.195': ['tor', 'Hong Kong', 'Asia', 9381, 'HKBN Enterprise Solutions HK Limited', '2021-09-22']}, {'103.236.201.88': ['tor', 'Indonesia', 'Asia', 136052, 'PT Cloud Hosting Indonesia', '2021-09-22']}]
```

We can push data easly with the script that I developed but there is a problem.

- Cosmos db uses key which shloud be unique so if you upload any data which is duplicate it will destroy the old data and create a new place
  - In the above example for the final data if you look there are many entries which are duplicate like ```tor``` ```701``` etc. 
  - There can be a senario where ips are also same 
 
## How can it be fixed ?

It can be fixed by the following methods

1)  Using the data for only One data

Suppose if we can run the script on daily basis and only keep the fresh final data and destory the old one then we can fix this issue by using set() function in our script which will hold out unqiue value and only push unqiue data

- For  example 
```python
values_array = [1, 1, 1, 2, 3, 3, 4, 4, 4, 5, 6, 7, 8, 8, 8, 9, 10, 10]
value_set = set()
for unique in values_array:
	if unique not in value_set:
		print(unique)
		value_set.add(unique)
```
Which gives us 

```
1
2
3
4
5
6
7
8
9
10
``` 
This data can be pushed since it's unique

2) Using DBs

We can utilize DBs calls to check for unique values if we  want old final data as well

We can use 

a) Dynamodb
b) sqllite (locally)

So check for unqiue data and push only which are unquie 





