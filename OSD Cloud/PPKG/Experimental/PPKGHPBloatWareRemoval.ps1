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

# # Uncomment this section to see what is left behind
# Write-Host "Checking stuff after running script"
# Write-Host "For Get-AppxPackage -AllUsers"
# Get-AppxPackage -AllUsers | where {$_.Name -like "*HP*"}
# Write-Host "For Get-AppxProvisionedPackage -Online"
# Get-AppxProvisionedPackage -Online | where {$_.DisplayName -like "*HP*"}
# Write-Host "For Get-Package"
# Get-Package | select Name, FastPackageReference, ProviderName, Summary | Where {$_.Name -like "*HP*"} | Format-List

# # Feature - Ask for reboot after running the script
# $input = Read-Host "Restart computer now [y/n]"
# switch($input){
#           y{Restart-computer -Force -Confirm:$false}
#           n{exit}
#     default{write-warning "Skipping reboot."}
# }