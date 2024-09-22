﻿$WindowsImage = "C:\Users\Administrator\Desktop\OSD-CloudTesting\Custom.wim"
$Destination = "$(Get-OSDCloudWorkspace)\Media\OSDCloud\OS"
New-Item -Path $Destination -ItemType Directory -Force
Copy-Item -Path $WindowsImage -Destination "$Destination\CustomImage.wim" -Force
New-OSDCloudISOi
Edit-OSDCloudWinPE -Wallpaper C:\Users\Administrator\Desktop\OSD-CloudTesting\RCSLogo.jpg -StartOSDCloud '-OSBuild 22H2 -OSEdition Enterprise -OSLanguage en-us -OSActivation Retail' -Brand 'Rvercity OSD' -CloudDriver HP -WifiProfile C:\WiFiProfiles\Wi-Fi-RCS-Guest.xml -WirelessConnect -DriverPath C:\ProgramData\OSDCloud\WifiDrivers

#Cleanup OSDCloud Workspace Media
$KeepTheseDirs = @('boot','efi','en-us','sources','fonts','resources')
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media\Boot' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media\EFI\Microsoft\Boot' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force

NEW-OSDCloudTemplate -WinRE -Name 'WinRE'
Edit-OSDCloudWinPE -Wallpaper C:\Users\Administrator\Desktop\OSD-CloudTesting\RCSLogo.jpg -StartOSDCloud '-OSVersion Windows 10 -OSBuild 22H2 -OSEdition Enterprise -OSLanguage en-us -OSActivation Retail' -Brand 'Rvercity OSD' -CloudDriver HP -WifiProfile C:\WiFiProfiles\Wi-Fi-RCS-Guest.xml -WirelessConnect 
New-OSDCloudTemplate -Name 'Perfect Image'

Set-OSDCloudWorkspace -WorkspacePath 'C:\ProgramData\OSDCloud\Templates\Generic'
Set-OSDCloudWorkspace -WorkspacePath 'C:\ProgramData\OSDCloud\Templates\WinRE Testing'

Get-OSDCloudTemplateNames

Set-OSDCloudTemplate -Name 'Generic'
Set-OSDCloudTemplate -Name 'WinRE Testing'

Get-WiFiActiveProfileSSID
Get-WifiProfileKey RCS-Guest

#Image location in WinPE D:\OSDCloud\OSD\CustomImage.wim

Set-OSDCloudWorkspace -WorkspacePath C:\OSDCloud
Edit-OSDCloudWinPE -WirelessConnect
$(Get-OSDCloudWorkspace)\Media\OSDCloud\Automate

Get-Module -ListAvailable
Microsoft.Powershell.Archive,Microsoft.Powershell.Dianostics,Microsoft.Powershell.Host,Microsoft.Powershell.LocalAccounts,Microsoft.Powershell.Management,Microsoft.Powershell.ODataUtils,Microsoft.Powershell.Security,Microsoft.Powershell.Utility

dism /mount-image /imagefile:C:\winre\boot.wim /index:1 /mountdir:C:\winre\mount
dism /image:C:\winre\mount /add-package /packagepath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-WMI_en-us.cab"
xcopy C:\Windows\System32\WindowsPowerShell\v1.0\* C:\winre\mount\Windows\System32\WindowsPowerShell\v1.0 /s /e
dism /Unmount-Wim /MountDir:C:\winre\mount /Commit

Mount-DiskImage -imagepath "C:\ProgramData\OSDCloud\Templates\WinRE Testing\OSDCloud_NoPrompt.iso"