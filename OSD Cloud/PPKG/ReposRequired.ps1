
# Everything thats needed for OSD to image deployment


Install-PackageProvider NuGet -Force
Set-ExecutionPolicy RemoteSigned -Force
Install-Module OSD -Force
Install-Module AzureAD -Force
Install-Module Az.Accounts -Force
Install-Module Az.KeyVault -Force
Install-Module Az.Resources -Force
Install-Module Az.Storage -Force
Install-Module Microsoft.Graph.DeviceManagement -Force
Install-Script Chocolately



##Windows ADK
##Windows PE Add-on
