$myDesktop=[Environment]::GetFolderPath("Desktop")
$baseURL    = "https://download.virtualbox.org/virtualbox/"
$latesversiontURL  = $baseURL+"LATEST.TXT"

#Get the URL of Latest Version and construct Latest URL for the exe
$latestURL=$baseURL+ (Invoke-WebRequest -Uri $latesversiontURL -Method GET).Content
$latestBinary = (Invoke-WebRequest -Uri $latestURL).Links.href | Select-String exe
$latestBinaryURL = ($latestURL+ "/" + $latestBinary) -replace("`n","")

#Download
$myDownloadPath = $myDesktop + "\" +$latestBinary
wget $latestBinaryURL -OutFile $myDownloadPath