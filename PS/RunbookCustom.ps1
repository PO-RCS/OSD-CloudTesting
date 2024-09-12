$WindowsImage = "C:\Users\Administrator\Desktop\OSD-CloudTesting\Custom.wim"
$Destination = "$(Get-OSDCloudWorkspace)\Media\OSDCloud\OS"
New-Item -Path $Destination -ItemType Directory -Force
Copy-Item -Path $WindowsImage -Destination "$Destination\CustomImage.wim" -Force
New-OSDCloudISOi
Edit-OSDCloudWinPE -Wallpaper C:\Users\Administrator\Desktop\OSD-CloudTesting\RCSLogo.jpg -StartOSDCloud '-OSBuild 22H2 -OSEdition Enterprise -OSLanguage en-us -OSActivation Retail' -Brand 'Rvercity OSD' -CloudDriver * -WifiProfile C:\WiFiProfiles\Wi-Fi-RCS-Guest.xml -WirelessConnect -DriverPath C:\Users\Administrator\Desktop\OSD-CloudTesting\WiFi-23.70.2-Driver64-Win10-Win11.exe

#Cleanup OSDCloud Workspace Media
$KeepTheseDirs = @('boot','efi','en-us','sources','fonts','resources')
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media\Boot' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media\EFI\Microsoft\Boot' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force


New-OSDCloudTemplate -Name 'Perfect Image'

Set-OSDCloudWorkspace -WorkspacePath 'C:\ProgramData\OSDCloud\Templates\Generic'

Get-OSDCloudTemplateNames

Set-OSDCloudTemplate -Name 'Generic'

Get-WiFiActiveProfileSSID
Get-WifiProfileKey RCS-Guest

#Image location in WinPE D:\OSDCloud\OSD\CustomImage.wim

Set-OSDCloudWorkspace -WorkspacePath C:\OSDCloud
Edit-OSDCloudWinPE -WirelessConnect
$(Get-OSDCloudWorkspace)\Media\OSDCloud\Automate