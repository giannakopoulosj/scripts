$portToChecks = '80', '443'
$myName = $env:computername

Get-Content .\IpInput.txt | ForEach-Object {
    foreach ($portToCheck in $portToChecks) {
        $server_name = $_
        If ( Test-Connection $_ -Quiet -Count 1 ) {
            try {       
                $null = New-Object System.Net.Sockets.TCPClient -ArgumentList  $server_name, $portToCheck
            
                $props = @{
                    Result = $server_name + ',' + $portToCheck + ',Yes,' + $myName
                }
                Write-Host "$server_name , $portToCheck set" -b Green
            }
            catch {
                $props = @{
                    Result = $server_name + ',' + $portToCheck + ',No,' + $myName
                }    
                Write-Host "$server_name , $portToCheck not set" -b Red
            }
        }
        Else {
            $props = @{
                Result = $server_name + ',' + $portToCheck + ',No ping,' + $probeName
            }
            Write-Host "$server_name $portToCheck No ping" -b Red
        }
        New-Object PsObject -Property $props
    } 
} | Set-Content -Path ".\IpOutputResults.txt"
