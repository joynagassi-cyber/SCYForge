$ErrorActionPreference = 'SilentlyContinue'
$base = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc'
$root = $base.Length + 1
$results = @()

Get-ChildItem -Path $base -Filter '*.md' -Recurse -File | ForEach-Object {
  $f = $_
  $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
  $content = [System.Text.Encoding]::UTF8.GetString($bytes)
  $lines = $content -split "`n"
  $lineCount = $lines.Count

  # all non-empty lines
  $nonEmpty = @()
  foreach ($l in $lines) {
    if ($l.Trim()) { $nonEmpty += $l.Trim() }
  }

  # First meaningful line (title)
  $firstLine = ''
  if ($nonEmpty.Count -gt 0) { $firstLine = $nonEmpty[0] }

  # collect up to 10 non-empty lines for the opening summary
  $opening = @()
  foreach ($l in $nonEmpty) {
    if ($opening.Count -ge 10) { break }
    $opening += $l
  }
  $summary = [string]::Join(' ', $opening)
  if ($summary.Length -gt 400) { $summary = $summary.Substring(0, 397) + '...' }

  $rel = $f.DirectoryName.Substring($root)
  $dir = if ($rel) { $rel.TrimStart('\').Replace('\', '/') } else { '(root)' }

  $escaped = $firstLine -replace '\|','&#124;' -replace '`','' 
  $escaped2 = $summary -replace '\|','&#124;' -replace '`','' 
  $outLine = $dir + '|' + $f.Name + '|' + $lineCount + '|' + $escaped + '|' + $escaped2
  $results += $outLine
}

$results | Out-File -FilePath 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_catalogue2.tsv' -Encoding UTF8
Write-Host ('Total: ' + $results.Count + ' files catalogued')
