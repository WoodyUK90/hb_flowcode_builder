<#
.SYNOPSIS
    Deploys Hornbill Flowcode Advanced Builder to IIS Tools directory.

.DESCRIPTION
    Copies the standalone HTML application to \\wdc-tsadmin02\F$\Hornbill IIS\Tools\FlowcodeHelper
    exclusively as index.html (the IIS default document) without generating backup artifacts (.bak)
    or extraneous filenames in the production directory. Version history is preserved in Git.

.EXAMPLE
    .\deploy.ps1
    .\deploy.ps1 -WhatIf
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$TargetDir = "\\wdc-tsadmin02\F$\Hornbill IIS\Tools\FlowcodeHelper",
    [string]$SourceFile = "Hornbill Flowcode Advanced Builder.html"
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== Hornbill Flowcode Advanced Builder Deployment ===" -ForegroundColor Cyan

# 1. Verify Source File
$currentDir = $PSScriptRoot
if (-not $currentDir) { $currentDir = (Get-Location).Path }
$sourcePath = Join-Path $currentDir $SourceFile

if (-not (Test-Path $sourcePath)) {
    Write-Error "Source file not found: $sourcePath"
    exit 1
}

$sourceFileInfo = Get-Item $sourcePath
Write-Host "Source File: $sourcePath ($([math]::Round($sourceFileInfo.Length / 1KB, 1)) KB)" -ForegroundColor Gray

# 2. Verify Target Directory
Write-Host "Target Share: $TargetDir" -ForegroundColor Gray
if (-not (Test-Path $TargetDir)) {
    Write-Host "Target directory not found. Attempting to create..." -ForegroundColor Yellow
    if ($PSCmdlet.ShouldProcess($TargetDir, "Create Directory")) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }
}

# 3. Clean up any legacy .bak files or original filename in target directory
$legacyFiles = Get-ChildItem -Path $TargetDir -File -Filter "*.bak" -ErrorAction SilentlyContinue
$legacyHtml = Join-Path $TargetDir $SourceFile
if (Test-Path $legacyHtml) {
    if ($PSCmdlet.ShouldProcess($legacyHtml, "Remove legacy file")) {
        Remove-Item -Path $legacyHtml -Force
        Write-Host "[CLEANUP] Removed legacy file: $SourceFile" -ForegroundColor Yellow
    }
}
foreach ($bak in $legacyFiles) {
    if ($PSCmdlet.ShouldProcess($bak.FullName, "Remove legacy backup")) {
        Remove-Item -Path $bak.FullName -Force
        Write-Host "[CLEANUP] Removed legacy backup: $($bak.Name)" -ForegroundColor Yellow
    }
}

# 4. Deploy strictly as index.html
$targetIndexPath = Join-Path $TargetDir "index.html"
if ($PSCmdlet.ShouldProcess($sourcePath, "Deploy to $targetIndexPath")) {
    Copy-Item -Path $sourcePath -Destination $targetIndexPath -Force
    Write-Host "[DEPLOYED] index.html -> $targetIndexPath" -ForegroundColor Green
}

Write-Host "`nDeployment complete successfully! Target directory contains solely index.html." -ForegroundColor Green
Write-Host "IIS URL: http://wdc-tsadmin02/Tools/FlowcodeHelper/ (or custom IIS binding)`n" -ForegroundColor Cyan
