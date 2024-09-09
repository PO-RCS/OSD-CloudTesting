Mount-VHD -Path "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\The Perfect Image - Copy.vhdx"

# Get the disk number for the mounted VHDX
$disk = Get-Disk | Where-Object { $_.Path -eq 'C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\The Perfect Image - Copy.vhdx' }

# Get the partition on the disk
$partition = Get-Partition -DiskNumber $disk.Number

# Assign a drive letter (e.g., X)
$partition | Set-Partition -NewDriveLetter H
Get-Partition

Dismount-VHD -Path "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\The Perfect Image - Copy.vhdx"
