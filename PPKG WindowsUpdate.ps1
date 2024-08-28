
#Grabs device information (Brand/ModelName/ModelNumber) 

Get-ItemPropertyValue HKLM:\HARDWARE\DESCRIPTION\System\BIOS -Name SystemManufacturer
Get-ItemPropertyValue HKLM:\HARDWARE\DESCRIPTION\System\BIOS -Name SystemFamily
Get-ItemPropertyValue HKLM:\HARDWARE\DESCRIPTION\System\BIOS -Name SystemProductName









##This fills the gap for Windows OS drivers, but not device drivers. Might be able to use line 39-45 to instead point at HP/Lenovo/Dell for driver installs
##Line 52 to 58 might not be needed, this script will run at a ppkg level with windows configuration designer

#search and list all missing Drivers

$Session = New-Object -ComObject Microsoft.Update.Session           
$Searcher = $Session.CreateUpdateSearcher() 

$Searcher.ServiceID = '7971f918-a847-4430-9279-4a52d1efe18d'
$Searcher.SearchScope =  1 # MachineOnly
$Searcher.ServerSelection = 3 # Third Party

$Criteria = "IsInstalled=0 and Type='Driver' and ISHidden=0"
Write-Host('Searching Driver-Updates...') -Fore Green  
$SearchResult = $Searcher.Search($Criteria)          
$Updates = $SearchResult.Updates

#Show available Drivers

$Updates | select Title, DriverModel, DriverVerDate, Driverclass, DriverManufacturer | fl

#Download the Drivers from Microsoft

$UpdatesToDownload = New-Object -Com Microsoft.Update.UpdateColl
$updates | % { $UpdatesToDownload.Add($_) | out-null }
Write-Host('Downloading Drivers...')  -Fore Green  
$UpdateSession = New-Object -Com Microsoft.Update.Session
$Downloader = $UpdateSession.CreateUpdateDownloader()
$Downloader.Updates = $UpdatesToDownload
$Downloader.Download()

#Check if the Drivers are all downloaded and trigger the Installation

$UpdatesToInstall = New-Object -Com Microsoft.Update.UpdateColl
$updates | % { if($_.IsDownloaded) { $UpdatesToInstall.Add($_) | out-null } }

Write-Host('Installing Drivers...')  -Fore Green  
$Installer = $UpdateSession.CreateUpdateInstaller()
$Installer.Updates = $UpdatesToInstall
$InstallationResult = $Installer.Install()
if($InstallationResult.RebootRequired) {  
Write-Host('Reboot required! please reboot now..') -Fore Red  
} else { Write-Host('Done..') -Fore Green }