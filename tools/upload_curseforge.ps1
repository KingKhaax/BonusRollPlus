<#
Uploads BonusRoll Plus to CurseForge with the upload API.
Dry run by default; add -Upload to publish.
  powershell -NoProfile -ExecutionPolicy Bypass -File tools/upload_curseforge.ps1 -ProjectId 123456 [-Upload]
The token is read from the CURSEFORGE_API_TOKEN environment variable (never stored in files).
The changelog is the file given in -ChangelogFile (default: tools/changelog-en.md).
#>
param(
    [Parameter(Mandatory = $true)][string]$ProjectId,
    [switch]$Upload,
    [ValidateSet("alpha", "beta", "release")][string]$ReleaseType = "release",
    [string]$GameVersions = "1.60.1",
    [string]$Zip,
    [string]$ChangelogFile
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$token = $env:CURSEFORGE_API_TOKEN
if (-not $token) { $token = [Environment]::GetEnvironmentVariable("CURSEFORGE_API_TOKEN", "User") }
if (-not $token) { throw "CURSEFORGE_API_TOKEN is not set." }
$headers = @{ "X-Api-Token" = $token }
$base = "https://wow.curseforge.com/api"

$toc = Get-Content (Join-Path $root "BonusRollPlus\BonusRollPlus.toc")
$version = (($toc | Where-Object { $_ -match '^## Version:' }) -replace '^## Version:\s*', '').Trim()
if (-not $Zip) { $Zip = Join-Path $env:USERPROFILE "Desktop\BonusRollPlus\BonusRollPlus-$version.zip" }
if (-not $ChangelogFile) { $ChangelogFile = Join-Path $PSScriptRoot "changelog-en.md" }
if (-not (Test-Path $Zip)) { throw "Zip not found: $Zip" }
if (-not (Test-Path $ChangelogFile)) { throw "Changelog not found: $ChangelogFile" }

$all = Invoke-RestMethod -Uri "$base/game/versions" -Headers $headers
$ids = @()
foreach ($name in ($GameVersions -split ',\s*')) {
    $hit = $all | Where-Object { $_.name -eq $name } | Select-Object -First 1
    if ($hit) { $ids += [int]$hit.id } else { Write-Warning "Game version $name was not found on CurseForge; skipped." }
}
if ($ids.Count -eq 0) { throw "No matching game versions." }

$changelog = (Get-Content $ChangelogFile -Raw -Encoding UTF8).Trim()
$zipInfo = Get-Item $Zip
$metadata = @{
    changelog     = $changelog
    changelogType = "markdown"
    displayName   = "BonusRollPlus-$version"
    gameVersions  = $ids
    releaseType   = $ReleaseType
} | ConvertTo-Json -Depth 5

Write-Host "Project:       $ProjectId"
Write-Host "Version:       $version ($ReleaseType)"
Write-Host "Game versions: $GameVersions  ->  $($ids -join ', ')"
Write-Host "File:          $($zipInfo.FullName) ($([math]::Round($zipInfo.Length / 1KB)) KB)"
Write-Host "Changelog:     $($changelog.Length) characters"
if (-not $Upload) {
    Write-Host "`nDry run: nothing was uploaded. Add -Upload to publish."
    return
}

$metaFile = New-TemporaryFile
try {
    [IO.File]::WriteAllText($metaFile.FullName, $metadata, (New-Object Text.UTF8Encoding($false)))
    $response = & curl.exe -sS -X POST "$base/projects/$ProjectId/upload-file" `
        -H "X-Api-Token: $token" `
        -F "metadata=<$($metaFile.FullName);type=application/json" `
        -F "file=@$($zipInfo.FullName)"
    Write-Host "Response: $response"
} finally {
    Remove-Item $metaFile.FullName -Force -ErrorAction SilentlyContinue
}
