@ECHO OFF
wpeinit
cd\
title OSD 23.5.21.1
PowerShell -Nol -C Initialize-OSDCloudStartnet
@ECHO OFF
start PowerShell -NoL
exit