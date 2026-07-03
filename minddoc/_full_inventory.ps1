$ErrorActionPreference = 'SilentlyContinue'
$base = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc'
$outFile = 'C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_INVENTAIRE_FINAL.md'
$sb = [System.Text.StringBuilder]::new()

$dirs = Get-ChildItem -Path $base -Recurse -Directory | Sort-Object FullName
$allFiles = Get-ChildItem -Path $base -Filter '*.md' -Recurse -File | Sort-Object FullName

$currentDir = ''
$totalCount = 0

[void]$sb.AppendLine("INVENTAIRE COMPLET - TOUS LES FICHIERS .md")
[void]$sb.AppendLine("Dossier: C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\")
[void]$sb.AppendLine("Total fichiers: " + $allFiles.Count)
[void]$sb.AppendLine("Date: " + (Get-Date -Format "yyyy-MM-dd"))
[void]$sb.AppendLine("")

foreach ($f in $allFiles) {
    $relFull = $f.FullName.Substring($base.Length).TrimStart('\')
    $slashPos = $relFull.LastIndexOf('\')
    if ($slashPos -gt 0) {
        $dRel = $relFull.Substring(0, $slashPos).Replace('\', '/')
    } else {
        $dRel = '(root)'
    }
    
    if ($dRel -ne $currentDir) {
        $currentDir = $dRel
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("## " + $dRel)
        [void]$sb.AppendLine("")
    }
    
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $splitLines = $content -split "`n"
    $lCount = $splitLines.Count
    
    $firstLine = ''
    foreach ($ln in $splitLines) {
        if ($ln.Trim()) { $firstLine = $ln.Trim(); break }
    }
    
    $para = ''
    foreach ($ln in $splitLines) {
        $st = $ln.Trim()
        if (-not $st) { break }
        if ($para) { $para = $para + ' ' }
        $para = $para + $st
    }
    if ($para.Length -gt 350) { $para = $para.Substring(0, 347) + '...' }
    
    $totalCount++
    $fullPath = $f.FullName
    
    [void]$sb.AppendLine("### [" + $totalCount + "] " + $f.Name)
    [void]$sb.AppendLine("- **Chemin:** " + $fullPath)
    [void]$sb.AppendLine("- **Lignes:** " + $lCount)
    [void]$sb.AppendLine("- **Titre:** " + $firstLine)
    [void]$sb.AppendLine("- **Resume:** " + $para)
    [void]$sb.AppendLine("")
}

[void]$sb.AppendLine("")
[void]$sb.AppendLine("TOTAL: " + $totalCount + " fichiers Markdown")
[void]$sb.AppendLine("Structure complete de C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\")

[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host ("Done: " + $totalCount + " fichiers, " + $dirs.Count + " dossiers")
