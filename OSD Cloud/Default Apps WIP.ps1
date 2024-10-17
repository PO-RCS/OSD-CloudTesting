# Function to set default application for a specific user
function Set-DefaultAppForUser {
    param (
        [string]$UserProfilePath,
        [string]$AppUserModelId,
        [string]$Extension
    )

    $appKeyPath = "$UserProfilePath\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\$Extension\UserChoice"
    New-Item -Path $appKeyPath -Force | Out-Null
    Set-ItemProperty -Path $appKeyPath -Name "ProgId" -Value $AppUserModelId
}

# Example applications - replace with your actual application identifiers
$defaultApps = @(
    @{ Extension = ".txt"; AppUserModelId = "Applications.Notepad.exe" },
    @{ Extension = ".jpg"; AppUserModelId = "Applications.Photos.exe" },
    @{ Extension = ".pdf"; AppUserModelId = "Applications.AdobeAcrobat.exe" }
    @{ Extension = ".pdx"; AppUserModelId = "Applications.AdobeAcrobat.exe" }
)

# Get all local user profiles excluding default and system accounts
$localProfiles = Get-WmiObject Win32_UserProfile | Where-Object {
    $_.LocalPath -and
    $_.Special -eq $false -and
    $_.LocalPath -notlike "*Default*" -and
    $_.LocalPath -notlike "*Public*" -and
    $_.LocalPath -notlike "*SID*" # Exclude SID accounts
}

# Loop through each profile and set the default applications
foreach ($profile in $localProfiles) {
    $userProfilePath = $profile.LocalPath
    foreach ($app in $defaultApps) {
        Set-DefaultAppForUser -UserProfilePath $userProfilePath -AppUserModelId $app.AppUserModelId -Extension $app.Extension
    }
}

# Set default browser (example) for all local accounts
$browserId = "Applications.Chrome.exe"
foreach ($profile in $localProfiles) {
    $userProfilePath = $profile.LocalPath
    Set-DefaultAppForUser -UserProfilePath $userProfilePath -AppUserModelId $browserId -Extension "http"
}
