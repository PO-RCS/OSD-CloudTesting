Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation

choco install teamviewer vlc googlechrome firefox notepadplusplus 7zip zoom zoom-outlook adobecreativecloud microsoft-teams-new-bootstrapper logioptionsplus teamviewer msvisualcplusplus2008-redist msvisualcplusplus2010-redist msvisualcplusplus2012-redist msvisualcplusplus2013-redist vcredist140 -y

##choco uninstall vlc googlechrome firefox notepadplusplus 7zip zoom zoom-outlook microsoft-teams-new-bootstrapper logioptionsplus
##choco uninstall vlc.install googlechrome.install firefox.install notepadplusplus.install 7zip.install zoom.install zoom-outlook.install microsoft-teams-new-bootstrapper.install logioptionsplus.install