
$ServerList = ".\ipList.txt"
$OutputPath = ".\pingOutput.csv"
Clear-Content $OutputPath
Get-Content $ServerList | ForEach-Object { 
    $server = $_
    if (Test-Connection $Server -Count 1 -Quiet) { 
        $status = 'True' 
        Write-Host $server is Online -ForegroundColor Green 
    }
    else {
        $status = 'False' 
        Write-Host $server is Offline -ForegroundColor Red 
    } 
    New-Object -TypeName psobject -Property @{ 
        ComputerName = $Server 
        Status       = $status 
    } | Select-Object ComputerName, Status | Export-Csv -Path "$OutputPath" -Append -NoTypeInformation 
}

