#Variables
$my_dns = "1.2.3.4"
$my_user=((Get-WmiObject win32_computersystem).username).split('\')[1]
$ip = Get-Content C:\Users\$my_user\Desktop\ip.txt
$my_reverse = ""
$my_reverse_host =""


Write-Output "We will use DNS`: $my_dns"
Write-Output "MyIP,ReverseRecord,ARecordFromReverse"
foreach ($my_ip in $ip) {

#Get Host from IP
$my_reverse = nslookup $my_ip | select-string -pattern "Name:" 
$my_reverse = ($my_reverse -split":")[1].trim()

#Get IP form Host
$my_reverse_host = nslookup $my_reverse  | select-string -pattern "Address:" | Select-String -pattern $my_dns -NotMatch
$my_reverse_host = ($my_reverse_host -split":")[1].trim()


Write-Output " $my_ip`,$my_reverse`,$my_reverse_host "

}
