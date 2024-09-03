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

    # Retrieve BIOS information
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
        # Requires work!
        Write-Output "This step hasn't been set up yet..."
    }
    "Unknown" {
        # What output do we want?
        Write-Output "This step hasn't been set up yet..."
    }
}