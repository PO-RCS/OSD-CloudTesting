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
    "notepadplusplus",
    "7zip",
    "zoom",
    "zoom-outlook",
    "adobecreativecloud",
    "microsoft-teams-new-bootstrapper",
    "logioptionsplus",
    "teamviewer",
    "msvisualcplusplus2008-redist",
    "msvisualcplusplus2010-redist",
    "msvisualcplusplus2012-redist",
    "vcredist140"
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