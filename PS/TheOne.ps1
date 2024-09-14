
# Purpose of this script is to deploy and test on an OOBE device

## Current runsheet
# Install missing scripts and modules needed to run everything 
# Change Hibernation Settings
# Discovery and update drivers that were missed during Windows Pre-Environment
## Additional step in HP segment, to uninstall bloatware
# Chocolately to install standard cross company applications
## Still requires work
### Self note, get wifi intergration working on either WinPE or WinRE. We need to be able to deploy majority of the images over a single GUI. OSD Cloud won't be able to store the images locally since we're aiming for a Cloud solution


winget install --id Microsoft.Powershell --source winget
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

# Change Hibernation settings for OOBE deploment
powercfg -change monitor-timeout-dc 0
powercfg -change monitor-timeout-ac 0
powercfg -change standby-timeout-dc 0
powercfg -change standby-timeout-ac 0

# Create "Support" folder for general use
New-Item -Path "C:\Support" -ItemType Directory

# Search and list missing drivers
try {
    $Session = New-Object -ComObject Microsoft.Update.Session
    $Searcher = $Session.CreateUpdateSearcher() 

    $Searcher.ServiceID = '7971f918-a847-4430-9279-4a52d1efe18d'
    $Searcher.SearchScope = 1 # MachineOnly
    $Searcher.ServerSelection = 3 # Third Party

    $Criteria = "IsInstalled=0 and Type='Driver' and IsHidden=0"
    Write-Host('Searching Windows/Driver Updates') -ForegroundColor Green  
    $SearchResult = $Searcher.Search($Criteria)          

if ($SearchResult.Updates.Count -eq 0) {
    Write-Host('No Windows/Driver found') -ForegroundColor Green
    }

    $Updates = $SearchResult.Updates

    # Show available Drivers
    Write-Host('Available Driver Updates:') -ForegroundColor Green
    $Updates | Select-Object Title, DriverModel, DriverVerDate, DriverClass, DriverManufacturer | Format-List

    # Download the Drivers from Microsoft
    $UpdatesToDownload = New-Object -Com Microsoft.Update.UpdateColl
    $Updates | ForEach-Object { $UpdatesToDownload.Add($_) | Out-Null }
    Write-Host('Downloading Drivers...') -ForegroundColor Yellow

    $UpdateSession = New-Object -Com Microsoft.Update.Session
    $Downloader = $UpdateSession.CreateUpdateDownloader()
    $Downloader.Updates = $UpdatesToDownload
    
try {
    $Downloader.Download()
    } catch {
    Write-Host("Error downloading drivers: $_") -ForegroundColor Red
}

    # Check if the Drivers are all downloaded and trigger the Installation
    $UpdatesToInstall = New-Object -Com Microsoft.Update.UpdateColl
    $Updates | ForEach-Object { if ($_.IsDownloaded) { $UpdatesToInstall.Add($_) | Out-Null } }

Write-Host('Installing Drivers...') -ForegroundColor Yellow  
    $Installer = $UpdateSession.CreateUpdateInstaller()
    $Installer.Updates = $UpdatesToInstall
    
try {
$InstallationResult = $Installer.Install()
if ($InstallationResult.RebootRequired) {  

    Write-Host('Reboot required! Please reboot now..') -ForegroundColor Red  
    } else { 
    Write-Host('Drivers installed successfully..') -ForegroundColor Green 
}
    } catch {
    Write-Host("Error installing drivers: $_") -ForegroundColor Red
}

    } catch {
    Write-Host("An error occurred: $_") -ForegroundColor Red
}

# List installed drivers
Write-Host('Listing Installed Drivers...') -ForegroundColor Green

# Get installed drivers
try {
    $drivers = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, DriverVersion, Manufacturer

    # Display the list of installed drivers
    $drivers | ForEach-Object {
        Write-Host "Device Name: $($_.DeviceName)"
        Write-Host "Driver Version: $($_.DriverVersion)"
        Write-Host "Manufacturer: $($_.Manufacturer)"
        Write-Host "-----------------------------"
    }
    } catch {
    Write-Host("Error listing drivers: $_") -ForegroundColor Red
    }

    # Retrieve Device information
    $manufacturer = Get-ItemPropertyValue HKLM:\HARDWARE\DESCRIPTION\System\BIOS -Name SystemManufacturer
    $family = Get-ItemPropertyValue HKLM:\HARDWARE\DESCRIPTION\System\BIOS -Name SystemFamily
    $productName = Get-ItemPropertyValue HKLM:\HARDWARE\DESCRIPTION\System\BIOS -Name SystemProductName

# Display retrieved information for debugging purposes
Write-Output "Manufacturer: $manufacturer"
Write-Output "Family: $family"
Write-Output "Product Name: $productName"

    # Determine the brand based on the manufacturer
    $brand = ""

if ($manufacturer -match "Dell") {
    $brand = "Dell"
} elseif ($manufacturer -match "HP") {
    $brand = "HP"
} elseif ($manufacturer -match "Lenovo") {
    $brand = "Lenovo"
} elseif ($manufacturer -match "ASUS") {
    $brand = "ASUS"
} elseif ($manufacturer -match "Acer") {
    $brand = "Acer"
} else {
    $brand = "Unknown"
}

# Output the detected brand for verification
Write-Output "Detected Brand: $brand"

# Conditional logic based on the detected brand
switch ($brand) {
    "Dell" {
        # Installs DriverPackFromDell
        Write-Output "Running Dell-specific actions..." 
        Install-Script -Name Get-DriversPackFromDell
        .\Get-DriverPackFromDell.ps1 -models $productName
    }
    "HP" {
        # Define a progress bar for installation
            $totalSteps = 2
            $progress = 0

        # Install HPDrivers module
        Write-Progress -PercentComplete $progress -Status "Installing HPDrivers module" -CurrentOperation "Step 1 of $totalSteps"
        Install-Module -Name HPDrivers -Force -Scope CurrentUser
            $progress = [math]::Round(($progress + 100 / $totalSteps), 0)
        Write-Progress -PercentComplete $progress -Status "HPDrivers module installed" -CurrentOperation "Step 2 of $totalSteps"
        Write-Output "Fetching HP drivers..."
        Get-HPDrivers -NoPrompt
        Write-Progress -PercentComplete $progress -Status "Complete" -CurrentOperation "All steps completed"
        Write-Output "Listing All Installed Drivers..." 
            $drivers = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, DriverVersion, Manufacturer
            $drivers | ForEach-Object {
        Write-Output "Device Name: $($_.DeviceName)"
        Write-Output "Driver Version: $($_.DriverVersion)"
        Write-Output "Manufacturer: $($_.Manufacturer)"
        Write-Output "-----------------------------"
        }

# List of built-in apps to remove
$UninstallPackages = @(
    "AD2F1837.HPJumpStarts"
    "AD2F1837.HPPCHardwareDiagnosticsWindows"
    "AD2F1837.HPPowerManager"
    "AD2F1837.HPPrivacySettings"
    "AD2F1837.HPSupportAssistant"
    "AD2F1837.HPSureShieldAI"
    "AD2F1837.HPSystemInformation"
    "AD2F1837.HPQuickDrop"
    "AD2F1837.HPWorkWell"
    "AD2F1837.myHP"
    "AD2F1837.HPDesktopSupportUtilities"
    "AD2F1837.HPQuickTouch"
    "AD2F1837.HPEasyClean"
    "AD2F1837.HPSystemInformation"
)

# List of programs to uninstall
$UninstallPrograms = @(
    "HP Client Security Manager"
    "HP Connection Optimizer"
    "HP Documentation"
    "HP MAC Address Manager"
    "HP Notifications"
    "HP Security Update Service"
    "HP System Default Settings"
    "HP Sure Click"
    "HP Sure Click Security Browser"
    "HP Sure Run"
    "HP Sure Recover"
    "HP Sure Sense"
    "HP Sure Sense Installer"
    "HP Wolf Security"
    "HP Wolf Security Application Support for Sure Sense"
    "HP Wolf Security Application Support for Windows"
)

$HPidentifier = "AD2F1837"

$InstalledPackages = Get-AppxPackage -AllUsers `
            | Where-Object {($UninstallPackages -contains $_.Name) -or ($_.Name -match "^$HPidentifier")}

$ProvisionedPackages = Get-AppxProvisionedPackage -Online `
            | Where-Object {($UninstallPackages -contains $_.DisplayName) -or ($_.DisplayName -match "^$HPidentifier")}

$InstalledPrograms = Get-Package | Where-Object {$UninstallPrograms -contains $_.Name}

# Remove appx provisioned packages - AppxProvisionedPackage
ForEach ($ProvPackage in $ProvisionedPackages) {

    Write-Host -Object "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]..."

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host -Object "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]"
    }
    Catch {Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]"}
}

# Remove appx packages - AppxPackage
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
    }
    Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
}

# Remove installed programs
$InstalledPrograms | ForEach-Object {

    Write-Host -Object "Attempting to uninstall: [$($_.Name)]..."

    Try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction SilentlyContinue
        Write-Host -Object "Successfully uninstalled: [$($_.Name)]"
    }
    Catch {Write-Warning -Message "Failed to uninstall: [$($_.Name)]"}
}

# Fallback attempt 1 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x "{0E2E04B0-9EDD-11EB-B38C-10604B96B11E}" /qn /norestart
    Write-Host -Object "Fallback to MSI uninistall for HP Wolf Security initiated"
}
Catch {
    Write-Warning -Object "Failed to uninstall HP Wolf Security using MSI - Error message: $($_.Exception.Message)"
}

# Fallback attempt 2 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x "{4DA839F0-72CF-11EC-B247-3863BB3CB5A8}" /qn /norestart
    Write-Host -Object "Fallback to MSI uninistall for HP Wolf 2 Security initiated"
}
Catch {
    Write-Warning -Object  "Failed to uninstall HP Wolf Security 2 using MSI - Error message: $($_.Exception.Message)"
}

# Fallback attempt 3 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x "{6A8A920B-BFE1-4195-86B0-0FEFA77EF406}" /qn /norestart
    Write-Host -Object "Fallback to MSI uninistall for HP Wolf Security initiated"
}
Catch {
    Write-Warning -Object "Failed to uninstall HP Wolf Security using MSI - Error message: $($_.Exception.Message)"
}

# Uninstall HP Secuirty Update Service
Try {
    MsiExec /x "{6CC3B2F8-3BC4-49B5-BDD4-8D587132D14E}" /qn /norestart
}
Catch {
    Write-Warning -Object "Failed to uninstall HP Secuirty Update Service using MSI - Error message: $($_.Exception.Message)"
}

# Uninstall HP Sure Run Module
Try {
    MsiExec /x "{3BB90A9F-A90F-4ED8-9F33-D28C41C8D4DC}" /qn /norestart
}
Catch {
    Write-Warning -Object "Failed to uninstall HP Sure RUn Module using MSI - Error message: $($_.Exception.Message)"
}

# Uninstall HP Sure Run Module
Try {
    MsiExec /x "{87F28156-6A7F-4FE9-8699-FD969A316CF2}" /qn /norestart
}
Catch {
    Write-Warning -Object "Failed to uninstall HP Sure RUn Module using MSI - Error message: $($_.Exception.Message)"
}

# Uninstall HP Connection Optimiser
Try {
    MsiExec /x "{6468C4A5-E47E-405F-B675-A70A70983EA6}" /qn /norestart
}
Catch {
    Write-Warning -Object "Failed to uninstall HP Connection Optimiser using MSI - Error message: $($_.Exception.Message)"
}
        return

    }
    "Lenovo" {
        # Lenovo-specific actions
        Write-Output "Running Lenovo-specific actions..." -ForegroundColor Green 

        # Define a progress bar for installation
            $progress = 0
            $totalSteps = 2 

        # Install LSUClient module
        Write-Progress -PercentComplete $progress -Status "Installing LSUClient module" -CurrentOperation "Step 1 of $totalSteps" -Activity "Module Installation"
        Install-Module -Name LSUClient -Force 
            $progress = [math]::Round(($progress + 100 / $totalSteps), 0)
        Write-Progress -PercentComplete $progress -Status "Installation complete" -CurrentOperation "Step 2 of $totalSteps" -Activity "Module Installation"
        Write-Progress -PercentComplete $progress -Status "Running LSUpdate" -CurrentOperation "Step 2 of $totalSteps" -Activity "Update"
        Get-LSUpdate -Model $productName -All
            $progress = [math]::Round(($progress + 100 / $totalSteps), 0)
        Write-Progress -PercentComplete $progress -Status "Complete" -CurrentOperation "All steps completed" -Activity "Update"
        return

    }
    "Acer" {
        # Is this needed in our fleet?
        Write-Output "Acer step."
    }
    "Unknown" {
        # What output do we want?
        Write-Output "This step hasn't been set up yet..."
    }
}

choco install 
# Ensure Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Define the list of applications to install
## Need to include additional application support, as well as installer stubs for TL, Automate, Huntress and SentinelOne
$applications = @(
    "vlc",
    "googlechrome",
    "firefox",
    "7zip",
    "zoom",
    "zoom-outlook",
    "adobecreativecloud",
    "adobeeader",
    "microsoft-teams-new-bootstrapper",
    "office365business",
    "msvisualcpluplu2008",
    "msvisualcpluplu2010",
    "msvisualcpluplu2012"
)

# Install each application and capture the result
$results =@{}
foreach ($app in $applications) {
    Write-Output "Installing $app..."
    try {
        # Capture the installation output
        $output = choco install $app -y | Out-String
        # Store the result in the hashtable
        $results[$app] = $output
    } catch {
        $results[$app] = "Failed to install $app. Error: $_"
    }
}

# Display the results
Write-Output "Installation Results:"
foreach ($app in $results.Keys) {
    Write-Output "`n$app Installation Result:`n"
    Write-Output $results[$app]
}