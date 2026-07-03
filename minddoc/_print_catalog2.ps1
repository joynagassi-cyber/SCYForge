$ErrorActionPreference='SilentlyContinue'
$file = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_catalogue2.tsv'
$outFile = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_INVENTAIRE_COMPLET.md'
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
$lines = $content -split "`n"

$sb = [System.Text.StringBuilder]::new()
$entries = @{}
$totalFiles = 0

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
    
    if (-not $entries.ContainsKey($dir)) { $entries[$dir] = @() }
    $flClean = $firstLine -replace '[`]','' -replace '\|',''
    $smClean = $summary -replace '[`]','' -replace '\|',''
    $entries[$dir] += "$name|$lineCount|$flClean|$smClean"
}

[void]$sb.AppendLine("# INVENTAIRE COMPLET - 610 FICHIERS MARKDOWN - MINDOC")
[void]$sb.AppendLine("")

$totalFiles = 0
$dirKeys = $entries.Keys | Sort-Object
foreach ($d in $dirKeys) {
    if ($d -eq '(root)') {
        [void]$sb.AppendLine("## 📁 DOSSIER RACINE (minddoc/)")
    } else {
        [void]$sb.AppendLine("## 📁 Dossier: $d")
    }
    $files = $entries[$d]
    $num = 0
    foreach ($f in $files) {
        $num++
        $totalFiles++
        $cols2 = $f.Split('|')
        $fn = $cols2[0]
        $lc = $cols2[1]
        $fl = if ($cols2.Count -gt 2) { $cols2[2] } else { '' }
        $sm = if ($cols2.Count -gt 3) { $cols2[3] } else { '' }
        if ($sm.Length -gt 300) { $sm = $sm.Substring(0, 297) + '...' }
        
        $sep = "---"
        [void]$sb.AppendLine($sep)
        [void]$sb.AppendLine("**[$num] Fichier:** $fn  ")
        [void]$sb.AppendLine("**Chemin complet:** `C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\$d\$fn  ")
        [void]$sb.AppendLine("**Lignes:** $lc  ")
        [void]$sb.AppendLine("**Titre:** $fl  ")
        if ($sm) { [void]$sb.AppendLine("**Resume:** $sm  ") }
        [void]$sb.AppendLine("")
    }
}

[void]$sb.AppendLine("---")
[void]$sb.AppendLine("TOTAL: $totalFiles fichiers Markdown dans `C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\")

[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host "OK - Inventaire ecrit: $totalFiles fichiers, 1 dossier racine, $($dirKeys.Count) dossiers"
