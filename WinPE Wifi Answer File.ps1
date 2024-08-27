$profilefile = "RCSBuild.xml"
$SSID = "RCS-Build"
$PW = "updateticketnotes"

function Get-ScriptPath()
{
    # If using PowerShell ISE
    if ($psISE)
    {
        $ScriptPath = Split-Path -Parent -Path $psISE.CurrentFile.FullPath
    }
    # If using PowerShell 3.0 or greater
    elseif($PSVersionTable.PSVersion.Major -gt 3)
    {
        $ScriptPath = $PSScriptRoot
    }
    # If using PowerShell 2.0 or lower
    else
    {
        $ScriptPath = split-path -parent $MyInvocation.MyCommand.Path
    }

    # If still not found
    # I found this can happen if running an exe created using PS2EXE module
    if(-not $ScriptPath) {
        $ScriptPath = [System.AppDomain]::CurrentDomain.BaseDirectory.TrimEnd('\')
    }

    # Return result
    return $ScriptPath
}

# Replace Unacceptable values in password
function FormatKey($key) {
    $key = $key.replace("""", "&quot;")
    $key = $key.replace("&", "&amp;")
    $key = $key.replace("'", "&pos;")
    $key = $key.replace("<", "&lt;")
    $key = $key.replace(">", "&gt;")
    return $key
}

$PW = FormatKey($PW)
$SSIDHEX = ($SSID.ToCharArray() |foreach-object {'{0:X}' -f ([int]$_)}) -join''
$xmlfile = "<?xml version=""1.0""?>
<WLANProfile xmlns=""http://www.microsoft.com/networking/WLAN/profile/v1"">
    <name>$SSID</name>
    <SSIDConfig>
        <SSID>
            <hex>$SSIDHEX</hex>
            <name>$SSID</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$PW</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"

#Create XML File
$XMLFILE > "$(Get-ScriptPath)\$profilefile"

#Create, display, then connect to the new network
netsh wlan add profile filename="$(Get-ScriptPath)\$profilefile" #user=all
netsh wlan show profiles $SSID key=clear
netsh wlan connect name=$SSID

# Delete the XML file we created
Remove-Item "$(Get-ScriptPath)\$profilefile" -Force
