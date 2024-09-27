# Function to set default application
function Set-DefaultApp {
    param (
        [string]$AppUserModelId,
        [string]$Extension
    )

    # Set the default app for the specified extension
    $appKeyPath = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\$Extension\UserChoice"
    New-Item -Path $appKeyPath -Force | Out-Null
    Set-ItemProperty -Path $appKeyPath -Name "ProgId" -Value $AppUserModelId
}

# Example applications - replace with your actual application identifiers
$defaultApps = @{
    ".txt" = "Applications.Notepad.exe"
    ".jpg" = "Applications.Photos.exe"
    ".pdf" = "Applications.AdobeAcrobat.exe"
}

# Loop through each file type and set the default application
foreach ($extension in $defaultApps.Keys) {
    $appId = $defaultApps[$extension]
    Set-DefaultApp -AppUserModelId $appId -Extension $extension
}

# Set default browser (example)
$browserId = "Applications.Chrome.exe"
Set-DefaultApp -AppUserModelId $browserId -Extension "http"

# Notify user of completion
Write-Host "Default applications set successfully."