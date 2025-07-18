#requires -version 5.1
<#
.SYNOPSIS
    Creates file-level symbolic links for MQL5 projects with portable MetaTrader 5.

.DESCRIPTION
    This script creates individual symbolic links for MQL5 files, avoiding the problems
    associated with folder-level symbolic links. It includes conflict prevention through
    file prefixing and comprehensive validation.

.PARAMETER ProjectRoot
    Path to the project root directory containing MQL5 files.

.PARAMETER MT5Root
    Path to the portable MetaTrader 5 MQL5 directory.

.PARAMETER FilePrefix
    Prefix to add to files to prevent naming conflicts (e.g., "MYEA_").

.PARAMETER DryRun
    Preview mode - shows what would be done without making changes.

.EXAMPLE
    .\Create-FileSymlinks.ps1 -ProjectRoot "N:\MyProject" -FilePrefix "MYEA_"
    Creates symbolic links for a project with conflict prevention.

.EXAMPLE
    .\Create-FileSymlinks.ps1 -DryRun
    Preview what changes would be made without executing them.

.NOTES
    Author: Portable MT5 Development Environment
    Version: 1.0
    Requires: Administrator privileges for symbolic link creation
    
    This approach uses file-level symbolic links instead of folder-level links
    to provide better control, conflict prevention, and easier maintenance.
#>

param(
    [string]$ProjectRoot = "",
    [string]$MT5Root = "C:\MetaTrader 5\MQL5",
    [string]$FilePrefix = "MYEA_",
    [switch]$DryRun = $false
)

$ErrorActionPreference = 'Stop'

# Auto-detect project root if not provided
if ([string]::IsNullOrEmpty($ProjectRoot)) {
    $currentPath = $PSScriptRoot
    while ($currentPath -and $currentPath -ne [System.IO.Path]::GetPathRoot($currentPath)) {
        if (Get-ChildItem -Path $currentPath -Filter "*.mq5" -ErrorAction SilentlyContinue) {
            $ProjectRoot = $currentPath
            break
        }
        $currentPath = Split-Path $currentPath -Parent
    }
    
    if ([string]::IsNullOrEmpty($ProjectRoot)) {
        throw "❌ Could not auto-detect project root. Please specify -ProjectRoot parameter."
    }
}

$projectName = Split-Path $ProjectRoot -Leaf
$scanFolders = @("Experts", "Include", "Scripts", "Files", "Indicators")

Write-Host "`n🔗 MQL5 File-Level Symbolic Link Creator" -ForegroundColor Cyan
Write-Host "📁 Project Root: $ProjectRoot" -ForegroundColor Yellow
Write-Host "📁 Project Name: $projectName" -ForegroundColor Yellow
Write-Host "🎯 MT5 Target: $MT5Root" -ForegroundColor Yellow
Write-Host "🏷️  File Prefix: $FilePrefix" -ForegroundColor Yellow
if ($DryRun) { Write-Host "🧪 DRY RUN MODE - No changes will be made" -ForegroundColor Yellow }
Write-Host ""

# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ This script requires Administrator privileges to create symbolic links" -ForegroundColor Red
    Write-Host "💡 Please run PowerShell as Administrator and try again" -ForegroundColor Yellow
    return
}

$createdLinks = @()

# Create symbolic links for each folder
foreach ($folder in $scanFolders) {
    $sourceDir = Join-Path $ProjectRoot $folder
    $targetDir = Join-Path $MT5Root $folder
    
    if (!(Test-Path $sourceDir)) {
        Write-Host "⏭️  Skipping $folder (not present in project)" -ForegroundColor Gray
        continue
    }
    
    # Ensure target directory exists
    if (!(Test-Path $targetDir)) {
        if ($DryRun) {
            Write-Host "  📁 [DRY RUN] Would create directory: $targetDir" -ForegroundColor Gray
        } else {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            Write-Host "  📁 Created directory: $targetDir" -ForegroundColor Green
        }
    }
    
    Write-Host "📂 Processing folder: $folder" -ForegroundColor Cyan
    
    Get-ChildItem -Path $sourceDir -Filter "*.mq*" -File | ForEach-Object {
        $sourceFile = $_.FullName
        $fileName = $_.Name
        
        # Add prefix if not already present
        if (-not $fileName.StartsWith($FilePrefix)) {
            $fileName = "$FilePrefix$fileName"
        }
        
        $linkTarget = Join-Path $targetDir $fileName
        
        if (Test-Path $linkTarget) {
            $existingItem = Get-Item $linkTarget
            if ($existingItem.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                Write-Host "  🔗 Symlink already exists: $fileName" -ForegroundColor Gray
            } else {
                Write-Host "  ⚠️  Real file exists at target: $fileName" -ForegroundColor Yellow
                if ($DryRun) {
                    Write-Host "      [DRY RUN] Would backup and replace: $linkTarget" -ForegroundColor Gray
                } else {
                    # Backup existing file and create symlink
                    $backupPath = "$linkTarget.backup"
                    Move-Item -Path $linkTarget -Destination $backupPath -Force
                    Write-Host "      Backed up existing file to: $backupPath" -ForegroundColor Yellow
                    New-Item -ItemType SymbolicLink -Path $linkTarget -Target $sourceFile | Out-Null
                    Write-Host "  ✅ Created symlink (replaced real file): $fileName" -ForegroundColor Green
                    $createdLinks += $linkTarget
                }
            }
        } else {
            if ($DryRun) {
                Write-Host "  🔗 [DRY RUN] Would create symlink: $fileName" -ForegroundColor Gray
                $createdLinks += $linkTarget
            } else {
                try {
                    New-Item -ItemType SymbolicLink -Path $linkTarget -Target $sourceFile | Out-Null
                    Write-Host "  ✅ Created symlink: $fileName" -ForegroundColor Green
                    $createdLinks += $linkTarget
                } catch {
                    Write-Host "  ❌ Failed to create symlink for $fileName : $_" -ForegroundColor Red
                }
            }
        }
    }
}

# Summary
Write-Host "`n📊 SUMMARY:" -ForegroundColor Cyan
Write-Host "  🔗 Symlinks created/verified: $($createdLinks.Count)" -ForegroundColor Green

if ($DryRun) {
    Write-Host "`n🧪 DRY RUN COMPLETED - No actual changes were made" -ForegroundColor Yellow
    Write-Host "   Run without -DryRun to execute the changes" -ForegroundColor Gray
} else {
    Write-Host "`n✅ File-level symlinks created successfully!" -ForegroundColor Green
    Write-Host "   MT5 Terminal and MetaEditor should now see all files" -ForegroundColor Gray
}

Write-Host "`n💡 Why File-Level Symlinks?" -ForegroundColor Cyan
Write-Host "  • Precise control over individual files" -ForegroundColor Gray
Write-Host "  • Naming conflicts prevented with prefixes" -ForegroundColor Gray
Write-Host "  • Easy to debug and maintain" -ForegroundColor Gray
Write-Host "  • Multiple projects can coexist safely" -ForegroundColor Gray
