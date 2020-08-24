$serviceName= "HealthService"
If (Get-Service $serviceName -ErrorAction Silently Continue) {
if ((Get-Service $serviceName).Status -eq 'Running') {
Stop-Service -Name "HealthService"
Set-Service -Name "HealthService" -Startuptype Manual
Get-Service HealthService | Select-Object -Property Name, StartType, Status
}Else {
Set-Service -Name "HealthService" -Startuptype Manual
Get-Service HealthService | Select-Object -Property Name, StartType, Status
}Else {
Write-Host "$serviceName not found"
}

}