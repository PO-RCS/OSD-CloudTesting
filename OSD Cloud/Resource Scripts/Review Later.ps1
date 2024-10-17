# Add any device drivers (.inf files) - this folder contains BroadcomWirelessWin8x64

Dism /Add-Driver /Image:"$WorkDir\mount" /Driver:"$HomeDir\Drivers\" /recurse

# For Wifi - http://www.msfn.org/board/topic/162453-winpe-40-enable-wireless-support/

Dism /Add-Driver /Image:"$WorkDir\mount" /Driver:"$env:SystemRoot\Inf\netnwifi.inf"
Dism /Add-Driver /Image:"$WorkDir\mount" /Driver:"$env:SystemRoot\Inf\netvwififlt.inf"
copy "$env:SystemRoot\Inf\netvwifibus.inf" "$WorkDir\mount\Windows\Inf\netvwifibus.inf"
copy "$env:SystemRoot\System32\Drivers\vwifibus.sys" "$WorkDir\mount\Windows\System32\Drivers\vwifibus.sys"	
copy "$env:SystemRoot\System32\Drivers\vwifibus.sys" "$WorkDir\mount\Windows\Inf\vwifibus.sys"

# Wifi adapter
Dism /Add-Driver /Image:"$WorkDir\mount" /Driver:"$HomeDir\Drivers\BroadcomWirelessWin8x64\bcmwl63.inf"

# Structure is taken from https://msdn.microsoft.com/en-us/library/windows/hardware/dn938390(v=vs.85).aspx
##########
# Only need to change this section if moving ADK install location etc.
# normally $ADK = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit" - default

$ADK = "D:\Windows Kits\10\Assessment and Deployment Kit"
$WinPE_Arch = "amd64"

$HomeDir = "D:\Make-PE"			# This is the work directory where the script is running
$ISOPath = "$HomeDir\WinPE.iso"	# Where the ISO goes
$ISOLabel="My Boot Disk"		# Name of ISOLabel	

# Display message variables
$message="Enter choice"
$choices=@("&Yes","&No")

# Environment Variables for script
$WorkDir = "$HomeDir\WinPE_+$WinPE_Arch"
$Source="$ADK\Windows Preinstallation Environment\$WinPE_Arch"
$FWFilesRoot="$ADK\Deployment Tools\$WinPE_Arch\Oscdimg"
$WIMSourcePath="$Source\en-us\winpe.wim"
$WinPE_OCs="$ADK\Windows Preinstallation Environment\$WinPE_Arch\WinPE_OCs" 	

##########
# GO !!
##########

# DISM options below only works on Windows 10.
$OS = Get-WmiObject Win32_OperatingSystem
If(-not $OS.Caption.Contains("10")) {Read-Host -Prompt "This script only works with Windows 10.  Press Enter to exit."; exit }

# If ISO exists, delete it or quit.
if  (Test-Path "$ISOPath") {
	Remove-Item $ISOPath -Recurse -Force -ErrorAction 0
	$caption="Destination file $ISOPath exists, overwrite it?"
	$choicedesc = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]
	$choices | foreach  { $choicedesc.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList $_))}
	$prompt = $Host.ui.PromptForChoice($caption, $message, $choicedesc, 1)
	Switch ($prompt)
	{	0 {	Remove-Item $ISOPath -Recurse -Force -ErrorAction 0}
		1 {	Write-Host "$ISOPath will not be overwritten; exiting"; exit}
	}
}

# Validate Source exists 
if (-not (Test-Path "$Source")) {Read-Host -Prompt "ERROR: The following processor architecture was not found: $WinPE_Arch"; exit}
if (-not (Test-Path "$FWFilesRoot")) {Read-Host -Prompt "ERROR: The following path for firmware files was not found: $FWFilesRoot"; exit}
if (-not (Test-Path "$WIMSourcePath")) {Read-Host -Prompt "ERROR: WinPE WIM file does not exist: $WIMSourcePath"; exit}

# Delete old working directory
$ProgressPreference = "SilentlyContinue"
dism /Remount-Image /MountDir:"$WorkDir\mount"
dism /Unmount-Image /MountDir:"$WorkDir\mount" /discard
dism /Cleanup-Mountpoints
$ProgressPreference = "Continue"
Remove-Item $WorkDir -Recurse -Force -ErrorAction 0

# Create new WinPE work directory (copied from copype.cmd in ADK)
mkdir "$WorkDir"
mkdir "$WorkDir\media"
mkdir "$WorkDir\mount"
mkdir "$WorkDir\fwfiles"
mkdir "$WorkDir\media\sources"

# Copy the boot files and WinPE WIM to the destination location
xcopy /herky "$Source\Media\Boot" "$WorkDir\media\Boot\"
xcopy /herky "$Source\Media\EFI" "$WorkDir\media\EFI\"
copy "$Source\Media\bootmgr*" "$WorkDir\media\"
copy "$WIMSourcePath" "$WorkDir\media\sources\boot.wim"

# Copy the boot sector files to enable ISO creation and boot
copy "$FWFilesRoot\efisys.bin" "$WorkDir\fwfiles"
if (Test-Path $FWFilesRoot\etfsboot.com) {copy "$FWFilesRoot\etfsboot.com" "$WorkDir\fwfiles"}

# Mount WIM
Dism /Mount-Image /ImageFile:"$WorkDir\media\sources\boot.wim" /index:1 /MountDir:"$WorkDir\mount"
##########
# Add any device drivers (.inf files)
Dism /Add-Driver /Image:"$WorkDir\mount" /Driver:"$HomeDir\Drivers\" /recurse

# For Wifi - http://www.msfn.org/board/topic/162453-winpe-40-enable-wireless-support/
Dism /Add-Driver /Image:"$WorkDir\mount" /Driver:"$env:SystemRoot\Inf\netnwifi.inf"
Dism /Add-Driver /Image:"$WorkDir\mount" /Driver:"$env:SystemRoot\Inf\netvwififlt.inf"
copy "$env:SystemRoot\Inf\netvwifibus.inf" "$WorkDir\mount\Windows\Inf\netvwifibus.inf"
copy "$env:SystemRoot\System32\Drivers\vwifibus.sys" "$WorkDir\mount\Windows\System32\Drivers\vwifibus.sys"	
copy "$env:SystemRoot\System32\Drivers\vwifibus.sys" "$WorkDir\mount\Windows\Inf\vwifibus.sys"

# Wifi adapter
Dism /Add-Driver /Image:"$WorkDir\mount" /Driver:"$HomeDir\Drivers\BroadcomWirelessWin8x64\bcmwl63.inf"
	
# copy profile to PE as it will be needed
netsh wlan export profile name = $WifiProfile "Hali" folder="D:\Make-PE\Documents" key=clear

# Verify Drivers and give option to quit if incorrect
Dism /Get-Drivers /Image:"$WorkDir\mount"

$caption="Correct Drivers?  Continue?"
$choicedesc = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]
$choices | foreach  { $choicedesc.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList $_))}
$prompt = $Host.ui.PromptForChoice($caption, $message, $choicedesc, 0)
Switch ($prompt) {1	{exit}}
##########
# Change background image
if (Test-Path "$HomeDir\winpe.jpg") {
	takeown /f "$WorkDir\mount\Windows\System32\winpe.jpg"
	icacls "$WorkDir\mount\Windows\System32\winpe.jpg" /grant Administrators:F  /q
	copy "$HomeDir\winpe.jpg" "$WorkDir\mount\Windows\System32\winpe.jpg"
}
##########
# Add packages/languages/optional components/.cab files

# WinPE-HTA provides HTML Application (HTA) support to create GUI applications through the Windows Internet Explorer® script engine and HTML services.
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\WinPE-HTA.cab"  
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\en-us\WinPE-HTA_en-us.cab"

# WinPE-WMI contains a subset of the Windows Management Instrumentation (WMI) providers that enable minimal system diagnostics
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\WinPE-WMI.cab"
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\en-us\WinPE-WMI_en-us.cab"

# WinPE-NetFX contains a subset of the .NET Framework 4.5 that is designed for client applications.
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\WinPE-NetFX.cab"
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\en-us\WinPE-NetFX_en-us.cab"
 
# WinPE-Scripting contains a multiple-language scripting environment
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\WinPE-Scripting.cab"
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\en-us\WinPE-Scripting_en-us.cab"

# WinPE-PowerShell contains Windows PowerShell–based diagnostics
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\WinPE-PowerShell.cab"
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\en-us\WinPE-PowerShell_en-us.cab"

# WinPE-DismCmdlets contains the DISM PowerShell module
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\WinPE-DismCmdlets.cab"
Dism /Add-Package /Image:"$WorkDir\mount" /PackagePath:"$WinPE_OCs\en-us\WinPE-DismCmdlets_en-us.cab"

##########
# Add files and folders
# Copy files and folders into the C:\WinPE_amd64\mount folder.
if (Test-Path "$HomeDir\Documents") {xcopy  /herky "$HomeDir\Documents" "$Work Dir\mount\Users\Public\Documents"}
##########
# DLL's needed..
copy "$env:SystemRoot\System32\wlancfg.dll" "$WorkDir\mount\Windows\System32\wlancfg.dll"
copy "$env:SystemRoot\System32\en-US\wlancfg.dll.mui" "$WorkDir\mount\Windows\System32\en-US\wlancfg.dll.mui"
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "reg add HKLM\Software\Microsoft\NetSh /v wlancfg /t REG_SZ /d wlancfg.dll /f"
#Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "regsvr32 /s wlancfg.dll"

copy "$env:SystemRoot\System32\WcnNetsh.dll" "$WorkDir\mount\Windows\System32\WcnNetsh.dll"
copy "$env:SystemRoot\System32\en-US\WcnNetsh.dll.mui" "$WorkDir\mount\Windows\System32\en-US\WcnNetsh.dll.mui"
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "reg add HKLM\Software\Microsoft\NetSh /v WcnNetsh /t REG_SZ /d WcnNetsh.dll /f"
#Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "regsvr32 /s WcnNetsh.dll"
##########
# Add a startup script
# Modify the Startnet.cmd script to include your customized commands.
# This file is located at C:\WinPE_amd64\mount\Windows\System32\Startnet.cmd.

# Startup programs
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "`"%PROGRAMFILES%\macrium\peexplorer.exe`""
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "`"%PROGRAMFILES%\macrium\taskbar.exe`""
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "%SYSTEMROOT%\System32\cmd.exe"
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "%SYSTEMROOT%\Explorer++.exe"
##########
# Add an app - call it from X:\Windows\<MyApp> when booted from PE
Write-Host "Copying Windows"
Xcopy /s "$HomeDir\Windows\*"             "$WorkDir\mount\Windows"
Write-Host "Copying Program Files"
Xcopy /s "$HomeDir\Program Files\*"       "$WorkDir\mount\Program Files"
Write-Host "Copying Program Files (x86)"
Xcopy /s "$HomeDir\Program Files (x86)\*" "$WorkDir\mount\Program Files (x86)"
##########
# Add temporary storage (scratch space)
Dism /Set-ScratchSpace:512 /Image:"$WorkDir\mount"

# Unmount the WinPE image
Dism /Unmount-Image /MountDir:"$WorkDir\mount" /commit

# Validate Work Directories
if (-not (Test-Path "$WorkDir")) {Read-Host -Prompt "ERROR: Working directory does not exist: $WorkDir"; exit}
if (-not (Test-Path "$WorkDir/media")) {Read-Host -Prompt "ERROR: Working directory is not valid:: $WorkDir"; exit}

#Validate ISO doesn't already exist (again)
if (Test-Path "$ISOPath") {Read-Host -Prompt "ERROR: Destination directory exists: $WorkDir"; exit}

# Set the correct boot argument based on availability of boot apps
if (Test-Path "$WorkDir\fwfiles\etfsboot.com") {$BOOTDATA="2#p0,e,b`"$WorkDir\fwfiles\etfsboot.com`"#pEF,e,b`"$WorkDir\fwfiles\efisys.bin`""}
else {$BOOTDATA="1#pEF,e,b`"$WorkDir\fwfiles\efisys.bin`""}

# Make ISO
$command="$ADK\Deployment Tools\$WinPE_Arch\Oscdimg\oscdimg.exe"
Write-Host "Creating $ISOPath ..."
&$command  -l:$ISOLabel -h -m -o -u1 -bootdata:$bootdata "$WorkDir\media" "$ISOPath"
		
# Finished
Write-Host
Read-Host -Prompt "Press enter to exit."