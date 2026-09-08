<#
.SYNOPSIS
    Deploys Hornbill Flowcode Advanced Builder to IIS Tools directory.

.DESCRIPTION
    Copies the standalone HTML application to \\wdc-tsadmin02\F$\Hornbill IIS\Tools\FlowcodeHelper
    as index.html (the IIS default document) and creates a timestamped backup of the previous version.

.EXAMPLE
    .\deploy.ps1
    .\deploy.ps1 -WhatIf
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$TargetDir = "\\wdc-tsadmin02\F$\Hornbill IIS\Tools\FlowcodeHelper",
    [string]$SourceFile = "Hornbill Flowcode Advanced Builder.html",
    [switch]$NoBackup
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

# 3. Create Backup of Existing index.html
$targetIndexPath = Join-Path $TargetDir "index.html"
if ((Test-Path $targetIndexPath) -and (-not $NoBackup)) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = Join-Path $TargetDir "index.html.$timestamp.bak"
    if ($PSCmdlet.ShouldProcess($targetIndexPath, "Backup to $backupPath")) {
        Copy-Item -Path $targetIndexPath -Destination $backupPath -Force
        Write-Host "[BACKUP] Created backup: $backupPath" -ForegroundColor DarkGray
    }
}

# 4. Deploy Files
$destFiles = @("index.html", $SourceFile)
foreach ($destName in $destFiles) {
    $destPath = Join-Path $TargetDir $destName
    if ($PSCmdlet.ShouldProcess($sourcePath, "Copy to $destPath")) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "[DEPLOYED] $destName -> $destPath" -ForegroundColor Green
    }
}

Write-Host "`nDeployment complete successfully!" -ForegroundColor Green
Write-Host "IIS URL: http://wdc-tsadmin02/Tools/FlowcodeHelper/ (or custom IIS binding)`n" -ForegroundColor Cyan
