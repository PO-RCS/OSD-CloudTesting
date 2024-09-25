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
    "adobereader",
    "microsoft-teams-new-bootstrapper",
    "office365business",
    "msvisualcpluplu2008",
    "logioptionsplus",
    "teamviewer"
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