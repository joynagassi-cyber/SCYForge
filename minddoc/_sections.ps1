$ErrorActionPreference='SilentlyContinue'
$path='C:\Users\joyda\ZCodeProject\UsersjoydaZCodeProjectSCYForge\minddoc\_INVENTAIRE_FINAL.md'
$fileCount=0
$sectionNames=@()
$section=0
$prevWasSection=$false
$prevLine=''

Get-Content $path -Encoding UTF8 | ForEach-Object {
    $line = $_
    if ($line -match '^## (.+)$') {
        $section++
        Write-Output ('## ' + $Matches[1])
        $prevWasSection = $true
    } elseif ($line -match '^### \[(\d+)\] (.+)$') {
        $fileCount = [int]$Matches[1]
        $fn = $Matches[2]
        if (-not $prevWasSection) {
            Write-Output ('## (root) section continued')
        }
        Write-Output ('  [' + $fileCount + '] ' + $fn)
        $prevWasSection = $false
    }
    $prevLine = $line
}
