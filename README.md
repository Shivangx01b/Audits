### Aduit report for SAFE SUPPORT SERVICE

## Contents
- Date

- Scope

- Vulnerabilites
  
 - Critical Impact
    - Remote Code Execution via csv download.


    
## Date
A pentest aduit was performed for the **SAFE SUPPORT SERVICE** at **Wednesday, 2 December 2020**

## Scope
We started with: **mng.safety-support-service.jp**

## Vulnerabilites
Vulnerabilites founded are listed according to their impact levels, explanations, and potential recommendations.

### Critical Impact
##### Remote Code Execution from csv download.
It was found that the csv download functionality located at **https://mng.safety-support-service.jp/journals/journal** is vulnerable to rce.

###### Steps To Reproduce:

1) Visit **https://mng.safety-support-service.jp/journals/vehicle** try to resgister a car name as something like **@SUM(1+1)*cmd|' /C calc'!A0**
![Alt Text](https://i.ibb.co/jMPvzw4/cmd.png)

2) Download the csv

3) Open it MS Excel will ask permission to enable view ..click ok... cmd.exe will pop up 

###### Impact:
Attacker can make victim download csv file and if user is not very techincal he/she will enable the view mode in Excel thus can lead to full rce

###### Recommendation:
Before passing data to csv user input should be propely snatized 
