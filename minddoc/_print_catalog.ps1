$ErrorActionPreference='SilentlyContinue'
$file = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_catalogue2.tsv'
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
$lines = $content -split "`n"

# Parse: dir|name|linecount|firstline|summary
$entries = @{}
$flat = @()
foreach ($line in $lines) {
    $line = $line.Trim()
    if (-not $line) { continue }
    $cols = $line.Split('|')
    if ($cols.Count -lt 4) { continue }
    $dir = $cols[0]
    $name = $cols[1]
    $lineCount = $cols[2]
    $firstLine = $cols[3]
    $summary = if ($cols.Count -gt 4) { $cols[4] } else { '' }
    if ($summary.Length -gt 250) { $summary = $summary.Substring(0, 247) + '...' }
    
    if (-not $entries.ContainsKey($dir)) { $entries[$dir] = @() }
    $entries[$dir] += "$name|$lineCount|$firstLine|$summary"
}

# Output: tree + files per dir
$totalFiles = 0
$dirKeys = $entries.Keys | Sort-Object
foreach ($d in $dirKeys) {
    $color = if ($d -eq '(root)') { '' } else { '  ' }
    Write-Output "$color=== $d ==="
    $files = $entries[$d]
    $num = 0
    foreach ($f in $files) {
        $num++
        $cols2 = $f.Split('|')
        $fn = $cols2[0]
        $lc = $cols2[1]
        $fl = $cols2[2]
        $sm = if ($cols2.Count -gt 3) { $cols2[3] } else { '' }
        $totalFiles++
        Write-Output "$color  [$num] $fn  ($lc lignes)"
        Write-Output "$color       Titre: $fl"
        if ($sm) { Write-Output "$color       Resume: $sm" }
    }
}
Write-Output "TOTAL: $totalFiles fichiers Markdown"
