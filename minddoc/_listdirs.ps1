$base = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc'
$root = $base.Length
$lines = @()
Get-ChildItem -Path $base -Recurse -Directory | ForEach-Object {
  $rel = $_.FullName.Substring($root).TrimStart('\')
  $lines += $rel
}
$lines | Out-File -FilePath 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_dirs_list.txt' -Encoding UTF8
Write-Host ('Found ' + $lines.Count + ' subdirectories')
