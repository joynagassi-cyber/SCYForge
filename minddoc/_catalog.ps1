$ErrorActionPreference = 'SilentlyContinue'
$base = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc'
$root = $base.Length + 1
$results = @()

Get-ChildItem -Path $base -Filter '*.md' -Recurse -File | ForEach-Object {
  $f = $_
  $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
  $lines = $content -split "`n"
  $lineCount = $lines.Count
 
  $firstLine = ''
  foreach ($l in $lines) {
    if ($l.Trim()) { $firstLine = $l.Trim(); break }
  }
  $paragraph = ''
  foreach ($l in $lines) {
    $t = $l.Trim()
    if (-not $t) { break }
    if ($paragraph) { $paragraph += ' ' }
    $paragraph += $t
  }
  if ($paragraph.Length -gt 300) { $paragraph = $paragraph.Substring(0, 297) + '...' }
  $rel = $f.DirectoryName.Substring($root)
  $dir = if ($rel) { $rel.TrimStart('\').Replace('\', '/') } else { '(root)' }
  $outLine = $f.Name + '|' + $dir + '|' + $lineCount + '|' + $firstLine + '|' + $paragraph
  $results += $outLine
}

$results | Out-File -FilePath 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_catalogue.tsv' -Encoding UTF8
Write-Host ('Total: ' + $results.Count + ' files catalogued')
