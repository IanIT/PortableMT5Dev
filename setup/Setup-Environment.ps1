#requires -version 5.1
<#
.SYNOPSIS
    Quick setup script for portable MetaTrader 5 development environment.

.DESCRIPTION
    This script handles the complete setup of a portable MT5 development environment
    including file symlinks, VS Code configuration, and build tools.

.PARAMETER ProjectName
    Name of the project (used for file prefixes).

.PARAMETER MT5Path
    Path to the portable MetaTrader 5 installation.

.PARAMETER CreateSymlinks
    Create symbolic links to MT5 MQL5 directory.

.PARAMETER SetupVSCode
    Configure VS Code with build tasks and action buttons.

.PARAMETER DryRun
    Preview mode - shows what would be done without making changes.

.EXAMPLE
    .\Setup-Environment.ps1 -ProjectName "MyEA" -CreateSymlinks -SetupVSCode
    Complete setup for a new project.

.EXAMPLE
    .\Setup-Environment.ps1 -DryRun
    Preview what the setup would do.

.NOTES
    Author: Portable MT5 Development Environment
    Version: 1.0
    Requires: Administrator privileges for symbolic link creation
#>

param(
    [string]$ProjectName = "MYEA",
    [string]$MT5Path = "C:\MetaTrader 5",
    [switch]$CreateSymlinks = $false,
    [switch]$SetupVSCode = $false,
    [switch]$DryRun = $false
)

$ErrorActionPreference = 'Stop'

# Auto-detect project root
$projectRoot = $PSScriptRoot
while ($projectRoot -and $projectRoot -ne [System.IO.Path]::GetPathRoot($projectRoot)) {
    if (Test-Path (Join-Path $projectRoot "setup")) {
        break
    }
    $projectRoot = Split-Path $projectRoot -Parent
}

if (-not $projectRoot) {
    $projectRoot = Split-Path $PSScriptRoot -Parent
}

Write-Host "`n🚀 PortableMT5Dev Setup" -ForegroundColor Cyan
Write-Host "📁 Project Root: $projectRoot" -ForegroundColor Yellow
Write-Host "🏷️  Project Name: $ProjectName" -ForegroundColor Yellow
Write-Host "🎯 MT5 Path: $MT5Path" -ForegroundColor Yellow
if ($DryRun) { Write-Host "🧪 DRY RUN MODE - No changes will be made" -ForegroundColor Yellow }
Write-Host ""

# Check prerequisites
$prerequisites = @{
    "MT5 Installation" = (Test-Path $MT5Path)
    "MetaEditor64.exe" = (Test-Path (Join-Path $MT5Path "MetaEditor64.exe"))
    "Administrator Rights" = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Write-Host "🔍 Prerequisites Check:" -ForegroundColor Cyan
foreach ($check in $prerequisites.GetEnumerator()) {
    $status = if ($check.Value) { "✅" } else { "❌" }
    Write-Host "  $status $($check.Key)" -ForegroundColor $(if ($check.Value) { "Green" } else { "Red" })
}

$failedChecks = $prerequisites.GetEnumerator() | Where-Object { -not $_.Value }
if ($failedChecks.Count -gt 0) {
    Write-Host "`n❌ Prerequisites not met. Please resolve the issues above." -ForegroundColor Red
    return
}

# Create symbolic links if requested
if ($CreateSymlinks) {
    Write-Host "`n🔗 Creating File Symlinks..." -ForegroundColor Cyan
    
    $symlinkScript = Join-Path $PSScriptRoot "Create-FileSymlinks.ps1"
    if (Test-Path $symlinkScript) {
        $filePrefix = "${ProjectName}_"
        $symlinkArgs = @{
            ProjectRoot = $projectRoot
            MT5Root = Join-Path $MT5Path "MQL5"
            FilePrefix = $filePrefix
            DryRun = $DryRun
        }
        
        & $symlinkScript @symlinkArgs
    } else {
        Write-Host "  ❌ Create-FileSymlinks.ps1 not found" -ForegroundColor Red
    }
}

# Setup VS Code configuration if requested
if ($SetupVSCode) {
    Write-Host "`n⚙️ Setting up VS Code..." -ForegroundColor Cyan
    
    $vscodeDir = Join-Path $projectRoot ".vscode"
    if ($DryRun) {
        Write-Host "  📁 [DRY RUN] Would create .vscode directory" -ForegroundColor Gray
    } else {
        if (!(Test-Path $vscodeDir)) {
            New-Item -ItemType Directory -Path $vscodeDir -Force | Out-Null
            Write-Host "  📁 Created .vscode directory" -ForegroundColor Green
        }
    }
    
    # Create tasks.json
    $tasksJson = @"
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build MQL5",
            "type": "shell",
            "command": "powershell.exe",
            "args": [
                "-ExecutionPolicy", "Bypass",
                "-File", "tools/Build-MQL5.ps1"
            ],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": []
        }
    ]
}
"@
    
    $tasksFile = Join-Path $vscodeDir "tasks.json"
    if ($DryRun) {
        Write-Host "  📄 [DRY RUN] Would create tasks.json" -ForegroundColor Gray
    } else {
        Set-Content -Path $tasksFile -Value $tasksJson -Encoding UTF8
        Write-Host "  📄 Created tasks.json" -ForegroundColor Green
    }
    
    # Create action buttons configuration
    $actionButtonsJson = @"
{
    "actionButtons": {
        "defaultColor": "#007acc",
        "loadNpmCommands": false,
        "reloadButton": "🔄",
        "commands": [
            {
                "cwd": "`${workspaceFolder}",
                "name": "🔨 Build MQL5",
                "color": "green",
                "singleInstance": true,
                "command": "powershell.exe -ExecutionPolicy Bypass -File tools/Build-MQL5.ps1"
            }
        ]
    }
}
"@
    
    $settingsFile = Join-Path $vscodeDir "settings.json"
    if ($DryRun) {
        Write-Host "  📄 [DRY RUN] Would create settings.json with Action Buttons" -ForegroundColor Gray
    } else {
        Set-Content -Path $settingsFile -Value $actionButtonsJson -Encoding UTF8
        Write-Host "  📄 Created settings.json with Action Buttons" -ForegroundColor Green
    }
}

# Summary
Write-Host "`n📊 SETUP SUMMARY:" -ForegroundColor Cyan
Write-Host "  🏷️  Project Name: $ProjectName" -ForegroundColor Green
Write-Host "  📁 Project Root: $projectRoot" -ForegroundColor Green
Write-Host "  🎯 MT5 Path: $MT5Path" -ForegroundColor Green

if ($CreateSymlinks) {
    Write-Host "  🔗 Symbolic Links: Configured" -ForegroundColor Green
}

if ($SetupVSCode) {
    Write-Host "  ⚙️  VS Code Integration: Configured" -ForegroundColor Green
}

if ($DryRun) {
    Write-Host "`n🧪 DRY RUN COMPLETED - No actual changes were made" -ForegroundColor Yellow
    Write-Host "   Run without -DryRun to execute the setup" -ForegroundColor Gray
} else {
    Write-Host "`n✅ Setup completed successfully!" -ForegroundColor Green
    Write-Host "`n🚀 Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. Install 'Action Buttons' extension in VS Code" -ForegroundColor Gray
    Write-Host "  2. Reload VS Code to activate the build button" -ForegroundColor Gray
    Write-Host "  3. Click the '🔨 Build MQL5' button in the status bar" -ForegroundColor Gray
    Write-Host "  4. Check the compiled files in MT5 terminal" -ForegroundColor Gray
}
