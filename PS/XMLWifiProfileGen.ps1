# Define the directory where the XML files will be saved
$outputDirectory = "C:\WiFiProfiles"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory | Out-Null
}

# Retrieve the list of Wi-Fi profiles
$profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
    $_.ToString().Split(":")[1].Trim()
}

# Iterate over each profile and export it to an XML file
foreach ($profile in $profiles) {
    $profileName = $profile -replace '[\\/:*?"<>|]', '_'  # Replace invalid characters in profile names
    $xmlFilePath = Join-Path -Path $outputDirectory -ChildPath "$profileName.xml"
    
    # Export the profile to an XML file
    netsh wlan export profile name="$profile" folder="$outputDirectory" key=clear
    
    # Rename the exported XML file to include the profile name
    $exportedFile = Join-Path -Path $outputDirectory -ChildPath "$profileName.xml"
    Rename-Item -Path $exportedFile -NewName "$profileName.xml"
}

Write-Host "Wi-Fi profiles have been exported to $outputDirectory"