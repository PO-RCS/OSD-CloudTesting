# Add WiFi Services
if ($WifiRequired) {
    # Define directories and files
    $sourceSysRoot = $env:SystemRoot
    $destinationDir = "$WorkDir\mount\Windows"

    # Create necessary directories
    $wifiDirs = @(
        "schemas\AvailableNetwork",
        "system32\en-US",
        "System32\Drivers",
        "Inf",
        "L2Schemas"
    )
    
    foreach ($dir in $wifiDirs) {
        $fullPath = Join-Path $destinationDir $dir
        if (-not (Test-Path $fullPath)) {
            New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
        }
    }

    # Files to copy
    $files = @(
        @{ Source = "$sourceSysRoot\schemas\AvailableNetwork\AvailableNetworkInfo.xsd"; Destination = "schemas\AvailableNetwork\AvailableNetworkInfo.xsd" },
        @{ Source = "$sourceSysRoot\system32\wifitask.exe"; Destination = "system32\wifitask.exe" },
        @{ Source = "$sourceSysRoot\system32\wlanext.exe"; Destination = "system32\wlanext.exe" },
        @{ Source = "$sourceSysRoot\system32\en-US\wlanext.exe.mui"; Destination = "system32\en-US\wlanext.exe.mui" }
        # Add other files here in a similar format
    )

    # Copy files
    foreach ($file in $files) {
        Copy-Item -Path $file.Source -Destination (Join-Path $destinationDir $file.Destination) -Force
    }

    # Drivers and INF files
    $driversInf = @(
        @{ Source = "$sourceSysRoot\System32\Drivers\nwifi.sys"; Destination = "System32\Drivers\nwifi.sys" },
        @{ Source = "$sourceSysRoot\System32\Drivers\en-US\nwifi.sys.mui"; Destination = "System32\Drivers\en-US\nwifi.sys.mui" }
        # Add other drivers and INF files here in a similar format
    )

    foreach ($driver in $driversInf) {
        Copy-Item -Path $driver.Source -Destination (Join-Path $destinationDir $driver.Destination) -Force
        Add-WindowsDriver -Path "$WorkDir\mount" -Driver (Join-Path $destinationDir "Inf\netnwifi.inf")
    }

    # Copy missing L2Schemas files
    robocopy /xc /xn /xo /copyall "$sourceSysRoot\L2Schemas" "$destinationDir\L2Schemas"

    # Registry Changes
    $regHivePaths = @{
        "HKLM\WinPE_SYSTEM" = "$WorkDir\mount\windows\system32\config\SYSTEM"
        "HKLM\WinPE_SOFTWARE" = "$WorkDir\mount\windows\system32\config\SOFTWARE"
    }

    foreach ($hive in $regHivePaths.GetEnumerator()) {
        reg load $hive.Key $hive.Value
    }

    # Add necessary registry keys and values
    $registryEntries = @(
        @{ Key = "HKLM\WinPE_SOFTWARE\Microsoft\NetSh"; Value = @{ wlancfg = "wlancfg.dll" } },
        @{ Key = "HKLM\WinPE_SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost"; Value = @{ LocalSystemNetworkRestricted = "Netman\0hidserv\0svsvc\0dot3svc\0wlansvc" } }
        # Add other registry entries here
    )

    foreach ($entry in $registryEntries) {
        foreach ($value in $entry.Value.GetEnumerator()) {
            reg add $entry.Key /v $value.Key /t REG_SZ /d $value.Value /f
        }
    }

    # Unload registry hives
    foreach ($hive in $regHivePaths.Keys) {
        reg unload $hive
    }

    # Configure network startup commands
    $startnetCmd = "$WorkDir\mount\Windows\System32\Startnet.cmd"
    Add-Content -Path $startnetCmd -Value "netcfg -l %SystemRoot%\Inf\netnwifi.inf -c s -i MS_NativeWifiP"
    Add-Content -Path $startnetCmd -Value "netcfg -l %SystemRoot%\Inf\netvwififlt.inf -c s -i ms_vwifi"
    Add-Content -Path $startnetCmd -Value "net start dot3svc"
    Add-Content -Path $startnetCmd -Value "net start wlansvc"
}