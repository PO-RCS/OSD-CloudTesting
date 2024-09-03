$WindowsImage = "C:\Users\Administrator\Desktop\OSD-CloudTesting\Custom.wim"
$Destination = "$(Get-OSDCloudWorkspace)\Media\OSDCloud\OS"
New-Item -Path $Destination -ItemType Directory -Force
Copy-Item -Path $WindowsImage -Destination "$Destination\CustomImage.wim" -Force
New-OSDCloudISO

Edit-OSDCloudWinPE -Wallpaper C:\Users\Administrator\Desktop\OSD-CloudTesting\RCSLogo.jpg -StartOSDCloudGUI -CloudDriver * 

#Cleanup OSDCloud Workspace Media
$KeepTheseDirs = @('boot','efi','en-us','sources','fonts','resources')
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media\Boot' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem 'C:\ProgramData\OSDCloud\Templates\Perfect Image\Media\EFI\Microsoft\Boot' | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force


New-OSDCloudTemplate -Name 'Perfect Image'

New-OSDCloudWorkspace -WorkspacePath 'C:\ProgramData\OSDCloud\Templates\Perfect Image'

Get-OSDCloudTemplateNames

Set-OSDCloudTemplate -Name 'Perfect Image'

#Image location in WinPE D:\OSDCloud\OSD\CustomImage.wim


