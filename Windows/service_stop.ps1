$serviceName = "HealthService"
If (Get-Service $serviceName -ErrorAction SilentlyContinue) {
    if ((Get-Service $serviceName).Status -eq 'Running') {
        Write-Host "Stopping $serviceName and set to Manual"
        Stop-Service -Name $serviceName
        Set-Service -Name $serviceName -Startuptype Manual
        Get-Service $serviceName | Select-Object -Property Name, StartType, Status
    }
    Else {
        Write-Host "$serviceName set to Manual"
        Set-Service -Name $serviceName -Startuptype Manual
        Get-Service $serviceName | Select-Object -Property Name, StartType, Status
    }
}
Else {
    Write-Host "$serviceName not found"
}
  