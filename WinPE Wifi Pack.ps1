# Add WiFi Services
if ($WifiRequired) {
# 
# http://pcloadletter.co.uk/2011/12/03/windows-pe-builder-script-for-waik-including-wifi-support/

mkdir $WorkDir\mount\Windows\schemas\AvailableNetwork
copy "$env:SystemRoot\schemas\AvailableNetwork\AvailableNetworkInfo.xsd" "$WorkDir\mount\Windows\schemas\AvailableNetwork\AvailableNetworkInfo.xsd"	

# exe
copy "$env:SystemRoot\system32\wifitask.exe" "$WorkDir\mount\Windows\system32\wifitask.exe"
copy "$env:SystemRoot\system32\wlanext.exe" "$WorkDir\mount\Windows\system32\wlanext.exe"	
copy "$env:SystemRoot\system32\en-US\wlanext.exe.mui" "$WorkDir\mount\Windows\system32\en-US\wlanext.exe.mui"

# wlan* Dlls
copy "$env:SystemRoot\system32\wlanapi.dll" "$WorkDir\mount\Windows\system32\wlanapi.dll"	
copy "$env:SystemRoot\system32\en-US\wlanapi.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlanapi.dll.mui"	
copy "$env:SystemRoot\system32\wlancfg.dll" "$WorkDir\mount\Windows\system32\wlancfg.dll"	
copy "$env:SystemRoot\system32\en-US\wlancfg.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlancfg.dll.mui"
copy "$env:SystemRoot\system32\WLanConn.dll" "$WorkDir\mount\Windows\system32\WLanConn.dll"
copy "$env:SystemRoot\system32\en-US\WLanConn.dll.mui" "$WorkDir\mount\Windows\system32\en-US\WLanConn.dll.mui"
copy "$env:SystemRoot\system32\wlandlg.dll" "$WorkDir\mount\Windows\system32\wlandlg.dll"
copy "$env:SystemRoot\system32\en-US\wlandlg.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlandlg.dll.mui"
copy "$env:SystemRoot\system32\wlangpui.dll" "$WorkDir\mount\Windows\system32\wlangpui.dll"	
copy "$env:SystemRoot\system32\en-US\wlangpui.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlangpui.dll.mui"
copy "$env:SystemRoot\system32\WLanHC.dll" "$WorkDir\mount\Windows\system32\WLanHC.dll"	
copy "$env:SystemRoot\system32\en-US\WLanHC.dll.mui" "$WorkDir\mount\Windows\system32\en-US\WLanHC.dll.mui"
copy "$env:SystemRoot\system32\wlanhlp.dll" "$WorkDir\mount\Windows\system32\wlanhlp.dll"
copy "$env:SystemRoot\system32\WlanMediaManager.dll" "$WorkDir\mount\Windows\system32\WlanMediaManager.dll"
copy "$env:SystemRoot\system32\WlanMM.dll" "$WorkDir\mount\Windows\system32\wlanmm.dll"	
copy "$env:SystemRoot\system32\en-US\WlanMM.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlanmm.dll.mui"	
copy "$env:SystemRoot\system32\wlanmsm.dll" "$WorkDir\mount\Windows\system32\wlanmsm.dll"
copy "$env:SystemRoot\system32\wlanpref.dll" "$WorkDir\mount\Windows\system32\wlanpref.dll"	
copy "$env:SystemRoot\system32\en-US\wlanpref.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlanpref.dll.mui"	
copy "$env:SystemRoot\system32\WlanRadioManager.dll" "$WorkDir\mount\Windows\system32\WlanRadioManager.dll"	
copy "$env:SystemRoot\system32\wlansec.dll" "$WorkDir\mount\Windows\system32\wlansec.dll"	
copy "$env:SystemRoot\system32\wlansvc.dll" "$WorkDir\mount\Windows\system32\wlansvc.dll"	
copy "$env:SystemRoot\system32\en-US\wlansvc.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlansvc.dll.mui"	
copy "$env:SystemRoot\system32\wlansvcpal.dll" "$WorkDir\mount\Windows\system32\wlansvcpal.dll"
copy "$env:SystemRoot\system32\wlanui.dll" "$WorkDir\mount\Windows\system32\wlanui.dll"	
copy "$env:SystemRoot\system32\en-US\wlanui.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlanui.dll.mui"

# Already in WinPE image
#copy "$env:SystemRoot\system32\wlanutil.dll" "$WorkDir\mount\Windows\system32\wlanutil.dll"	
#copy "$env:SystemRoot\system32\en-US\wlanutil.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlanutil.dll.mui"

# Wifi* dll
copy "$env:SystemRoot\system32\WiFiConfigSP.dll" "$WorkDir\mount\Windows\system32\WiFiConfigSP.dll"	
copy "$env:SystemRoot\system32\wificonnapi.dll" "$WorkDir\mount\Windows\system32\wificonnapi.dll"	
copy "$env:SystemRoot\system32\WiFiDisplay.dll" "$WorkDir\mount\Windows\system32\WiFiDisplay.dll"	
copy "$env:SystemRoot\system32\en-US\WiFiDisplay.dll.mui" "$WorkDir\mount\Windows\system32\en-US\WiFiDisplay.dll.mui"	
copy "$env:SystemRoot\system32\wifinetworkmanager.dll" "$WorkDir\mount\Windows\system32\wifinetworkmanager.dll"	
copy "$env:SystemRoot\system32\en-US\wifinetworkmanager.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wifinetworkmanager.dll.mui"
copy "$env:SystemRoot\system32\wifiprofilessettinghandler.dll" "$WorkDir\mount\Windows\system32\wifiprofilessettinghandler.dll"	

# Other dll
copy "$env:SystemRoot\system32\wfdprov.dll" "$WorkDir\mount\Windows\system32\wfdprov.dll"	
copy "$env:SystemRoot\system32\wlgpclnt.dll" "$WorkDir\mount\Windows\system32\wlgpclnt.dll"	
copy "$env:SystemRoot\system32\en-US\wlgpclnt.dll.mui" "$WorkDir\mount\Windows\system32\en-US\wlgpclnt.dll.mui"	
copy "$env:SystemRoot\System32\WcnNetsh.dll" "$WorkDir\mount\Windows\System32\WcnNetsh.dll"
copy "$env:SystemRoot\System32\en-US\WcnNetsh.dll.mui" "$WorkDir\mount\Windows\System32\en-US\WcnNetsh.dll.mui"
copy "$env:SystemRoot\System32\whhelper.dll" "$WorkDir\mount\Windows\System32\whhelper.dll"
copy "$env:SystemRoot\System32\en-US\whhelper.dll.mui" "$WorkDir\mount\Windows\System32\en-US\whhelper.dll.mui"

# drivers
copy "$env:SystemRoot\System32\Drivers\nwifi.sys" "$WorkDir\mount\Windows\System32\Drivers\nwifi.sys"	
copy "$env:SystemRoot\System32\Drivers\en-US\nwifi.sys.mui" "$WorkDir\mount\Windows\System32\Drivers\en-US\nwifi.sys.mui"

# net start NativeWifiP failed due to missing signatures.  These are from sysinternals sigcheck -i c:\Windows\System32\drivers\nwifi.sys etc
copy "$env:SystemRoot\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Package_297_for_KB3081444~31bf3856ad364e35~amd64~~10.0.1.0.cat" `
"$WorkDir\mount\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Package_297_for_KB3081444~31bf3856ad364e35~amd64~~10.0.1.0.cat"	
copy "$env:SystemRoot\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Client-Features-Package-AutoMerged-net~31bf3856ad364e35~amd64~en-US~10.0.10240.16384.cat" `
"$WorkDir\mount\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Client-Features-Package-AutoMerged-net~31bf3856ad364e35~amd64~en-US~10.0.10240.16384.cat"	
	
copy "$env:SystemRoot\System32\Drivers\vwififlt.sys" "$WorkDir\mount\Windows\System32\Drivers\vwififlt.sys"	
copy "$env:SystemRoot\System32\Drivers\vwifimp.sys" "$WorkDir\mount\Windows\System32\Drivers\vwifimp.sys"
copy "$env:SystemRoot\System32\Drivers\WdiWiFi.sys" "$WorkDir\mount\Windows\System32\Drivers\WdiWiFi.sys"

copy "$env:SystemRoot\Inf\netnwifi.inf" "$WorkDir\mount\Windows\Inf\netnwifi.inf"
Add-WindowsDriver -Path "$WorkDir\mount" -Driver "$env:SystemRoot\Inf\netnwifi.inf"
copy "$env:SystemRoot\Inf\netvwififlt.inf" "$WorkDir\mount\Windows\Inf\netvwififlt.inf"
Add-WindowsDriver -Path "$WorkDir\mount" -Driver "$env:SystemRoot\Inf\netvwififlt.inf"
copy "$env:SystemRoot\Inf\netvwifimp.inf" "$WorkDir\mount\Windows\Inf\netvwifimp.inf"
Add-WindowsDriver -Path "$WorkDir\mount" -Driver "$env:SystemRoot\Inf\netvwifimp.inf"

# http://www.msfn.org/board/topic/162453-winpe-40-enable-wireless-support/
copy "$env:SystemRoot\Inf\netvwifibus.inf" "$WorkDir\mount\Windows\Inf\netvwifibus.inf"
copy "$env:SystemRoot\System32\Drivers\vwifibus.sys" "$WorkDir\mount\Windows\System32\Drivers\vwifibus.sys"	
copy "$env:SystemRoot\System32\Drivers\en-US\vwifibus.sys.mui" "$WorkDir\mount\Windows\System32\Drivers\en-US\vwifibus.sys.mui"	
copy "$env:SystemRoot\System32\Drivers\vwifibus.sys" "$WorkDir\mount\Windows\Inf\vwifibus.sys"

# Dism fails if vwifibus.sys is not added to C:\Windows\INF
$AddedToInf = $False
if (-not(Test-Path $env:SystemRoot\Inf\netvwifibus.sys)){
	$AddedToInf = $True
	copy "$env:SystemRoot\System32\Drivers\vwifibus.sys" "$env:SystemRoot\Inf\vwifibus.sys"
	Write-Host "Added $env:SystemRoot\Inf\vwifibus.sys" -f Red
}
Add-WindowsDriver -Path "$WorkDir\mount" -Driver "$env:SystemRoot\Inf\netvwifibus.inf"
if ($AddedToInf) {
	Remove-Item "$env:SystemRoot\Inf\vwifibus.sys" -ErrorAction 0
	Write-Host "Deleted $env:SystemRoot\Inf\vwifibus.sys" -f Red
}

# L2Schemas - copy any missing files
robocopy /xc /xn /xo /copyall "$env:SystemRoot\L2Schemas" "$WorkDir\mount\Windows\L2Schemas"

# Registry Changes
reg load HKLM\WinPE_SYSTEM $WorkDir\mount\windows\system32\config\SYSTEM
reg load HKLM\WinPE_SOFTWARE $WorkDir\mount\windows\system32\config\SOFTWARE

$RegKey="HKLM\WinPE_SOFTWARE\Microsoft\NetSh"
reg add  $RegKey /v wlancfg /t REG_SZ /d wlancfg.dll /f

$RegKey="HKLM\WinPE_SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost"
reg add $RegKey /v LocalSystemNetworkRestricted /t REG_MULTI_SZ /d Netman\0hidserv\0svsvc\0dot3svc\0wlansvc /f

# wlansvc
reg add HKLM\WinPE_SOFTWARE\Microsoft\WlanSvc\bmr /ve
$RegKey="HKLM\WinPE_SOFTWARE\Microsoft\WlanSvc\PowerProfiles\ClassAC"
reg add $RegKey /v PowerIdle /t REG_DWORD /d 15 # numbers are decimal
reg add $RegKey /v PowerTail /t REG_DWORD /d 280
reg add $RegKey /v PowerTxRx /t REG_DWORD /d 400
reg add $RegKey /v TailDuration /t REG_DWORD /d 300
$RegKey="HKLM\WinPE_SOFTWARE\Microsoft\WlanSvc\PowerProfiles\ClassB"
reg add $RegKey /v PowerIdle /t REG_DWORD /d 15
reg add $RegKey /v PowerTail /t REG_DWORD /d 280
reg add $RegKey /v PowerTxRx /t REG_DWORD /d 400
reg add $RegKey /v TailDuration /t REG_DWORD /d 300
$RegKey="HKLM\WinPE_SOFTWARE\Microsoft\WlanSvc\PowerProfiles\ClassG"
reg add $RegKey /v PowerIdle /t REG_DWORD /d 15
reg add $RegKey /v PowerTail /t REG_DWORD /d 280
reg add $RegKey /v PowerTxRx /t REG_DWORD /d 400
reg add $RegKey /v TailDuration /t REG_DWORD /d 300
$RegKey="HKLM\WinPE_SOFTWARE\Microsoft\WlanSvc\PowerProfiles\ClassN"
reg add $RegKey /v PowerIdle /t REG_DWORD /d 15
reg add $RegKey /v PowerTail /t REG_DWORD /d 280
reg add $RegKey /v PowerTxRx /t REG_DWORD /d 400
reg add $RegKey /v TailDuration /t REG_DWORD /d 300

$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc"
reg add $RegKey /v DisplayName /d "@%SystemRoot%\System32\wlansvc.dll,-257" 
reg add $RegKey /v ErrorControl /t REG_DWORD /d 1
reg add $RegKey /v Group /d TDI
reg add $RegKey /v ImagePath /t REG_EXPAND_SZ /d "%SystemRoot%\system32\svchost.exe -k LocalSystemNetworkRestricted"
reg add $RegKey /v Start /t REG_DWORD /d 2 # (automatic start) in clean install system this is 3(manual start)
reg add $RegKey /v Type /t REG_DWORD /d 32
reg add $RegKey /v Description /d "@%SystemRoot%\System32\wlansvc.dll,-258" 

# Remove the Windows Connection Manager (wcmsvc) service dependany
reg add $RegKey /v DependOnService /t REG_MULTI_SZ /d nativewifip\0RpcSs\0Ndisuio
reg add $RegKey /v ObjectName /d LocalSystem
reg add $RegKey /v ServiceSidType /t REG_DWORD /d 1
reg add $RegKey /v RequiredPrivileges /t REG_MULTI_SZ /d "SeChangeNotifyPrivilege\0SeImpersonatePrivilege\0SeAuditPrivilege\0SeTcbPrivilege\0SeDebugPrivilege"
reg add $RegKey /v FailureActions /t REG_BINARY /d 805101000000000000000000030000001400000001000000c0d4010001000000e09304000000000000000000
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters"
reg add $RegKey /v ServiceDll /t REG_EXPAND_SZ /d "%SystemRoot%\System32\wlansvc.dll" 
reg add $RegKey /v ServiceDllUnloadOnStop /t REG_DWORD /d 1
reg add $RegKey /v ServiceMain /d WlanSvcMain
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters\ComInterfaceProviders"
reg add $RegKey /v IHNetIcsSettings /d "{46C166AA-3108-11D4-9348-00C04F8EEB71}"
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters\EapolKeyIpAddress"
reg add $RegKey /v LocalAddress /d "192.168.173.1"
reg add $RegKey /v PrefixLength /t REG_DWORD /d 24
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters\OEM\SystemCapabilities"
reg add $RegKey /ve #***************** no value
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters\OneXAuthenticator"
reg add $RegKey /ve /t REG_EXPAND_SZ /d "%SystemRoot%\System32\WcnEapAuthProxy.dll"
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters\VendorSpecificIEProviders\02166b50-0459-44d9-9ec1-073431b7d9c9"
reg add $RegKey /v Path /t REG_EXPAND_SZ /d "%SYSTEMROOT%\System32\TetheringIeProvider.dll" 
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters\VendorSpecificIEProviders\4D50EE01-EEE0-4E5D-9A41-2F5F32044192"
reg add $RegKey /v Path /t REG_EXPAND_SZ /d "%SYSTEMROOT%\System32\WlanSvc.dll" 
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters\VendorSpecificIEProviders\B7D94B4D-5DB1-4E70-B5C3-DD003EEEBE66"
reg add $RegKey /v Path /t REG_EXPAND_SZ /d "%SYSTEMROOT%\System32\WiFiDisplay.dll" 
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Parameters\WFDProvPlugin"
reg add $RegKey /ve /t REG_EXPAND_SZ /d "%SystemRoot%\System32\wfdprov.dll"
reg add $RegKey /v DllEntryPoint /d WFDProvGetInfo 
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Security"
reg add $RegKey /v Security /t REG_BINARY /d 0100048098000000a40000000000000014000000020084000500000000001400fd01020001010000000000051200000000001800ff010f0001020000000000052000000020020000000014008d010200010100000000000504000000000014008d01020001010000000000050600000000002800700000000106000000000005500000002e25d9e85a67cd58c504f3dc32c0cb09ab704571010100000000000512000000010100000000000512000000
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\VirtualizationManager"
reg add $RegKey /v WindowsPushNotificationPlatformClsid /d "0C9281F9-6DA1-4006-8729-DE6E6B61581C"

# Native Wifi Filter (dependancy of wlansvc)
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\NativeWifiP"
reg add $RegKey /v DisplayName /d "@%SystemRoot%\System32\drivers\nwifi.sys,-101" 
reg add $RegKey /v ErrorControl /t REG_DWORD /d 1
reg add $RegKey /v Group /d NDIS
reg add $RegKey /v ImagePath /t REG_EXPAND_SZ /d "system32\DRIVERS\nwifi.sys"
reg add $RegKey /v Start /t REG_DWORD /d 3
reg add $RegKey /v Type /t REG_DWORD /d 1

# vwififlt
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\vwififlt"
reg add $RegKey /v DisplayName /d "@%SystemRoot%\System32\drivers\vwififlt.sys,-259" 
reg add $RegKey /v ErrorControl /t REG_DWORD /d 1
reg add $RegKey /v Group /d NDIS
reg add $RegKey /v ImagePath /t REG_EXPAND_SZ /d "System32\drivers\vwififlt.sys"
reg add $RegKey /v Start /t REG_DWORD /d 1
reg add $RegKey /v Type /t REG_DWORD /d 1
reg add $RegKey /v Description /d "@%SystemRoot%\System32\drivers\vwififlt.sys,-260"
reg add $RegKey /v NdisMajorVersion /t REG_DWORD /d 6
reg add $RegKey /v NdisMinorVersion /t REG_DWORD /d 50
reg add $RegKey /v DriverMajorVersion /t REG_DWORD /d 1
reg add $RegKey /v DriverMinorVersion /t REG_DWORD /d 0
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\vwififlt\Parameters"
reg add $RegKey /v DefaultFilterSettings /t REG_DWORD /d 1

# vwifimp not in core image (not required)

# WdiWifi
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\wdiwifi"
reg add $RegKey /v DisplayName /d "WDI Driver Framework" 
reg add $RegKey /v ErrorControl /t REG_DWORD /d 1
reg add $RegKey /v ImagePath /t REG_EXPAND_SZ /d "system32\DRIVERS\wdiwifi.sys"
reg add $RegKey /v Start /t REG_DWORD /d 3
reg add $RegKey /v Type /t REG_DWORD /d 1

# legacy WiFi adapter - recommended by http://pcloadletter.co.uk/2011/12/03/windows-pe-builder-script-for-waik-including-wifi-support/
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\Enum\Root\LEGACY_WLANSVC"
reg add $RegKey /v NextInstance /t REG_DWORD /d 1 # numbers are decimal
reg add $RegKey\0000 /v Service /t REG_SZ /d Wlansvc
reg add $RegKey\0000 /v Legacy /t REG_DWORD /d 1
reg add $RegKey\0000 /v ConfigFlags /t REG_DWORD /d 0
reg add $RegKey\0000 /v Class /t REG_SZ /d LegacyDriver
reg add $RegKey\0000 /v ClassGUID /t REG_SZ /d "{8ECC055D-047F-11D1-A537-0000F8753ED1}"
reg add $RegKey\0000 /v DeviceDesc /t REG_SZ /d "@%SystemRoot%\System32\wlansvc.dll,-257"
$RegKey="HKLM\WinPE_SYSTEM\ControlSet001\services\WlanSvc\Enum"
reg add $RegKey /v 0 /t REG_SZ /d "Root\LEGACY_WLANSVC\0000"
reg add $RegKey /v Count /t REG_DWORD /d 1
reg add $RegKey /v NextInstance /t REG_DWORD /d 1

reg unload HKLM\WinPE_SYSTEM
reg unload HKLM\WinPE_SOFTWARE

# Windows Connection Manager - Wcmsvc ** Not required and removed as dependancy **

# Startup Wifi
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "netcfg -l %SystemRoot%\Inf\netnwifi.inf -c s -i MS_NativeWifiP"
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "netcfg -l %SystemRoot%\Inf\netvwififlt.inf -c s -i ms_vwifi"
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "net start dot3svc"
Add-Content "$WorkDir\mount\Windows\System32\Startnet.cmd" "net start wlansvc"
}