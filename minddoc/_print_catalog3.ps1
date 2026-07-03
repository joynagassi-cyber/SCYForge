$ErrorActionPreference='SilentlyContinue'
$catalogue = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_catalogue2.tsv'
$outFile = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_INVENTAIRE_COMPLET.md'
$content = [System.IO.File]::ReadAllText($catalogue, [System.Text.Encoding]::UTF8)
$lines = $content -split "`n"

$sb = [System.Text.StringBuilder]::new()
$entries = @{"(root)"=@()}
$totalFiles = 0

foreach ($line in $lines) {
    $line = $line.Trim()
    if (-not $line) { continue }
    $p1 = $line.IndexOf('|')
    $p2 = $line.IndexOf('|', $p1+1)
    $p3 = $line.IndexOf('|', $p2+1)
    $p4 = $line.IndexOf('|', $p3+1)
    if ($p1 -lt 0 -or $p2 -lt 0 -or $p3 -lt 0) { continue }
    $dir = $line.Substring(0, $p1)
    $name = $line.Substring($p1+1, $p2-$p1-1)
    $lc = $line.Substring($p2+1, $p3-$p2-1)
    $firstLine = if ($p4 -gt 0) { $line.Substring($p3+1, $p4-$p3-1) } else { $line.Substring($p3+1) }
    $summary = if ($p4 -gt 0) { $line.Substring($p4+1) } else { '' }
    if ($summary.Length -gt 280) { $summary = $summary.Substring(0, 277) + '...' }
    if (-not $entries.ContainsKey($dir)) { $entries[$dir] = @() }
    $entries[$dir] += "$name|$lc|$firstLine|$summary"
}

[void]$sb.AppendLine("INVENTAIRE COMPLET - TOUS LES FICHIERS .md DE MINDOC")
[void]$sb.AppendLine("Total: 610 fichiers Markdown")
[void]$sb.AppendLine("")

$total = 0
$dirKeys = $entries.Keys | Sort-Object
foreach ($d in $dirKeys) {
    if ($d -eq '(root)') {
        [void]$sb.AppendLine("=== (root) DOSSIER RACINE minddoc/ ===")
    } else {
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("=== $d ===")
    }
    $files = $entries[$d]
    $num = 0
    foreach ($f in $files) {
        $num++
        $total++
        $cols2 = $f.Split('|')
        $fn = $cols2[0]
        $lc = $cols2[1]
        $fl = if ($cols2.Count -gt 2) { $cols2[2] } else { '' }
        $sm = if ($cols2.Count -gt 3) { $cols2[3] } else { '' }
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("[$num] $fn   |   $lc lignes")
        [void]$sb.AppendLine("  Titre: $fl")
        if ($sm) { [void]$sb.AppendLine("  Resume: $sm") }
    }
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("TOTAL: $total fichiers Markdown catalogues.")

[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host ("OK: $total fichiers ecrits dans inventaire")
