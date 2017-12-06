#Requires -Version 3.0

Set-StrictMode -Version Latest

$logFile = Join-Path $env:TEMP -ChildPath "InstallNetFx47ScriptLog.txt"

# Download NetFx47
$setupFileSourceUri = "https://download.microsoft.com/download/D/D/3/DD35CC25-6E9C-484B-A746-C5BE0C923290/NDP47-KB3186497-x86-x64-AllOS-ENU.exe"
$setupFileLocalPath = Join-Path $env:TEMP -ChildPath "NDP47-KB3186497-Web.exe"

"$(Get-Date): Start to download NetFx 4.7 to $setupFileLocalPath." | Out-File -FilePath $logFile -Append

if(Test-Path $setupFileLocalPath)
{
    Remove-Item -Path $setupFileLocalPath -Force
}

$webClient = New-Object System.Net.WebClient

try {
    $webClient.DownloadFile($setupFileSourceUri, $setupFileLocalPath)
} 
catch {
    "$(Get-Date): It looks the internet network is not available now. Simply wait for 30 seconds and try again." | Out-File -FilePath $logFile -Append
    Start-Sleep -Second 30
    $webClient.DownloadFile($setupFileSourceUri, $setupFileLocalPath)
}

if(!(Test-Path $setupFileLocalPath))
{
    "$(Get-Date): Failed to download NetFx 4.7 setup package." | Out-File -FilePath $logFile -Append
    return
}

# Install NetFx47
$setupLogFilePath = Join-Path $env:TEMP -ChildPath "NetFx47SetupLog.txt"
$arguments = "/q /serialdownload /log $setupLogFilePath"

"$(Get-Date): Start to install NetFx 4.7." | Out-File -FilePath $logFile -Append
$process = Start-Process -FilePath $setupFileLocalPath -ArgumentList $arguments -Wait -PassThru

"$(Get-Date): Install NetFx finished with exit code : $($process.ExitCode)." | Out-File -FilePath $logFile -Append
