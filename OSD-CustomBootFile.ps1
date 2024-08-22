#Currently this isn't displaying correctly within WinPE, on trying to open RAW URL. It's credential blocking.
cls
Write-Host "===================== Main Menu =======================" -ForegroundColor Yellow
Write-Host "1: Client 1" -ForegroundColor Yellow
Write-Host "2: Client 2" -ForegroundColor Yellow
Write-Host "3: Client 3" -ForegroundColor Yellow
Write-Host "4: Default Image"-ForegroundColor Yellow
Write-Host "5: Exit`n"-ForegroundColor Yellow
$input = Read-Host "Please make a selection"

Write-Host  -ForegroundColor Yellow "Loading OSDCloud..."

Import-Module OSD -Force
Install-Module OSD -Force

# Need to modify below output to instead point to custom ISO files per client for in house imaging
switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI } 
    '3' { Start-OSDCloud	} 
    '4' { Exit		}
}

wpeutil reboot
