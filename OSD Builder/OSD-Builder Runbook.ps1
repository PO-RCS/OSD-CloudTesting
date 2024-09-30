Install-Module -Name OSDBuilder -Force
Import-Module -Name OSDBuilder -Force

New-OSDBuilderContentPack -Name "MultiLang FOD NetFx3" -ContentType OS
New-OSBuildTask -TaskName Frogger -AddContentPacks
New-OSBuildTask -TaskName OSDProject -AddContentPacks

Import-OSMedia -ImageName 'WinRE' -SkipGrid -Update -BuildNetFX

Import-OSMedia
OSDBuilder -Download ContentPacks
