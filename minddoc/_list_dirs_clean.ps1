$ErrorActionPreference='SilentlyContinue'
$base='C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc'
Get-ChildItem $base -Directory | ForEach-Object { $_.Name }
