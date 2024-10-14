$WindowsImage = "C:\Users\Administrator\Desktop\OSD-CloudTesting\Custom.wim"
$Destination = "$(Get-OSDCloudWorkspace)\Media\OSDCloud\OS"
New-Item -Path $Destination -ItemType Directory -Force
Copy-Item -Path $WindowsImage -Destination "$Destination\CustomImage.wim" -Force
New-OSDCloudISO

Edit-OSDCloudWinPE -Wallpaper 'C:\Users\Administrator\Desktop\OSD-CloudTesting\OSD Cloud\RCSLogo.jpg' -StartOSDCloud "-OSBuild 22H2 -OSEdition Enterprise -OSLanguage en-us -OSActivation Retail"  -CloudDriver * -DriverPath C:\ProgramData\OSDCloud\WifiDrivers -Add7Zip
Edit-OSDCloudWinPE -Wallpaper 'C:\Users\Administrator\Desktop\OSD-CloudTesting\OSD Cloud\RCSLogo.jpg' -StartOSDCloudGUI -Brand 'Rivercity OSD' -CloudDriver HP

#Cleanup OSDCloud Workspace Media
$KeepTheseDirs = @('boot','efi','en-us','sources','fonts','resources')
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\WinRE\Media' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\WinRE\Media\Boot' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\WinRE\Media\EFI\Microsoft\Boot' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force

NEW-OSDCloudTemplate -Name 'WinPE'
Edit-OSDCloudWinPE -Wallpaper C:\Users\Administrator\Desktop\OSD-CloudTesting\RCSLogo.jpg -StartOSDCloud '-OSVersion Windows 10 -OSBuild 22H2 -OSEdition Enterprise -OSLanguage en-us -OSActivation Retail' -Brand 'Rvercity OSD' -CloudDriver HP -WifiProfile C:\WiFiProfiles\Wi-Fi-RCS-Guest.xml -WirelessConnect 
New-OSDCloudTemplate -Name 'Perfect Image'

Set-OSDCloudWorkspace -WorkspacePath 'C:\ProgramData\OSDCloud\Templates\WinPE'
Set-OSDCloudWorkspace -WorkspacePath 'C:\ProgramData\OSDCloud\Templates\WinRE'

Get-OSDCloudTemplateNames

Set-OSDCloudTemplate -Name 'WinPE'
Set-OSDCloudTemplate -Name 'WinRE'

Get-WiFiActiveProfileSSID
Get-WifiProfileKey RCS-Guest

#Image location in WinPE D:\OSDCloud\OSD\CustomImage.wim

Set-OSDCloudWorkspace -WorkspacePath C:\OSDCloud
Edit-OSDCloudWinPE -WirelessConnect
$(Get-OSDCloudWorkspace)\Media\OSDCloud\Automate

Get-Module -ListAvailable
Microsoft.Powershell.Archive,Microsoft.Powershell.Dianostics,Microsoft.Powershell.Host,Microsoft.Powershell.LocalAccounts,Microsoft.Powershell.Management,Microsoft.Powershell.ODataUtils,Microsoft.Powershell.Security,Microsoft.Powershell.Utility

dism /mount-image /imagefile:C:\ProgramData\OSDCloud\Templates\WinPE\Media\sources\boot.wim /index:1 /mountdir:C:\mount
copy /y C:\Windows\System32\Recovery\Winre.wim C:\mount

copy /y C:\Windows\System32\dmcmnutils.dll C:\mount\Windows\System32
copy /y C:\Windows\System32\mdmregistration.dll  C:\mount\Windows\System32

Copy-Item -Path C:\Windows\System32\dmcmnutils.dll -Destination C:\mount\Windows\System32 -Force
Copy-Item -Path C:\Windows\System32\mdmregistration.dll -Destination C:\mount\Windows\System32 -Force



dism /Image:C:\Mount /Get-features
dism /Get-Packages /Image:C:\mount
DISM /Online /Image:"C:\mount" /Enable-Feature /FeatureName:NetFx3 /All 
DISM /Image:C:\Mount\install.wim /Add-Driver /Driver:C:\Images\NetFX3-EN-US.cab /recurse

DISM /Image:C:\mount /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:C:\sources\sxs


DISM /Image:c:\mount /Get-Features /Format:Table


C:\Images\NetFX3-EN-US.cab
dism /image:C:\winre\mount /add-package /packagepath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-WMI_en-us.cab"
xcopy C:\Windows\System32\WindowsPowerShell\v1.0\* C:\winre\mount\Windows\System32\WindowsPowerShell\v1.0 /s /e
dism /Unmount-Wim /MountDir:C:\mount /Commit
C:\ProgramData\OSDCloud\Templates\WinRE\Media\sources
Mount-DiskImage -imagepath "C:\ProgramData\OSDCloud\Templates\WinRE Testing\OSDCloud_NoPrompt.iso"