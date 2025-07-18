#requires -version 5.1
#requires -RunAsAdministrator
<#
.SYNOPSIS
    Initialize a new portable MetaTrader 5 development environment.

.DESCRIPTION
    This script performs the initial setup for a portable MT5 development environment,
    including environment validation, dependency checks, and project initialization.
    This is the primary entry point for new users.

.PARAMETER ProjectName
    Name of the project (used for file prefixes and organization).

.PARAMETER MT5Path
    Path to the portable MetaTrader 5 installation. If not specified, will attempt auto-detection.

.PARAMETER SkipValidation
    Skip environment validation checks.

.PARAMETER Force
    Force initialization even if environment already exists.

.EXAMPLE
    .\Initialize-Environment.ps1 -ProjectName "MyTradingBot"
    Initialize a new project with auto-detection.

.EXAMPLE
    .\Initialize-Environment.ps1 -ProjectName "ScalpEA" -MT5Path "D:\MT5Portable" -Force
    Initialize with specific MT5 path and force overwrite.

.NOTES
    Author: Portable MT5 Development Environment
    Version: 1.0
    Requires: Administrator privileges for symbolic link creation
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ProjectName,

    [string]$MT5Path = "",
    [switch]$SkipValidation = $false,
    [switch]$Force = $false
)

$ErrorActionPreference = 'Stop'

# Script configuration
$script:LogLevel = "INFO"
$script:ProjectRoot = Split-Path -Parent $PSScriptRoot

function Write-Log {
    <#
    .SYNOPSIS
    Write formatted log messages with color coding.

    .PARAMETER Message
    The message to log.

    .PARAMETER Level
    The log level (INFO, WARNING, ERROR, SUCCESS).
    #>
    param(
        [string]$Message,
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $colors = @{
        "INFO"    = "White"
        "WARNING" = "Yellow"
        "ERROR"   = "Red"
        "SUCCESS" = "Green"
    }

    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $colors[$Level]
}

function Test-Administrator {
    <#
    .SYNOPSIS
    Check if running as administrator.
    #>
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-PowerShellVersion {
    <#
    .SYNOPSIS
    Validate PowerShell version compatibility.
    #>
    $requiredVersion = [Version]"5.1"
    $currentVersion = $PSVersionTable.PSVersion

    if ($currentVersion -lt $requiredVersion) {
        throw "PowerShell version $requiredVersion or higher is required. Current version: $currentVersion"
    }

    Write-Log "PowerShell version check passed: $currentVersion" "SUCCESS"
}

function Find-MT5Installation {
    <#
    .SYNOPSIS
    Auto-detect MetaTrader 5 installation.
    #>
    param([string]$HintPath = "")

    Write-Log "Searching for MetaTrader 5 installation..." "INFO"

    $searchPaths = @()

    if ($HintPath -and (Test-Path $HintPath)) {
        $searchPaths += $HintPath
    }

    # Common installation paths
    $searchPaths += @(
        "C:\Program Files\MetaTrader 5",
        "C:\Program Files (x86)\MetaTrader 5",
        "C:\MetaTrader 5",
        "D:\MetaTrader 5",
        "E:\MetaTrader 5"
    )

    # Search portable installations
    $drives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
    foreach ($drive in $drives) {
        $searchPaths += "$($drive.DeviceID)\MT5"
        $searchPaths += "$($drive.DeviceID)\MetaTrader5"
        $searchPaths += "$($drive.DeviceID)\MetaTrader 5"
        $searchPaths += "$($drive.DeviceID)\Portable\MetaTrader 5"
    }

    foreach ($path in $searchPaths) {
        if (Test-Path $path) {
            $metaeditorPath = Join-Path $path "MetaEditor64.exe"
            if (Test-Path $metaeditorPath) {
                Write-Log "Found MetaTrader 5 at: $path" "SUCCESS"
                return $path
            }
        }
    }

    Write-Log "MetaTrader 5 installation not found in standard locations" "WARNING"
    return $null
}

function Test-MT5Installation {
    <#
    .SYNOPSIS
    Validate MetaTrader 5 installation.
    #>
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "MetaTrader 5 path does not exist: $Path"
    }

    $requiredFiles = @(
        "MetaEditor64.exe",
        "terminal64.exe"
    )

    $requiredDirs = @(
        "MQL5"
    )

    foreach ($file in $requiredFiles) {
        $filePath = Join-Path $Path $file
        if (-not (Test-Path $filePath)) {
            throw "Required file not found: $filePath"
        }
    }

    foreach ($dir in $requiredDirs) {
        $dirPath = Join-Path $Path $dir
        if (-not (Test-Path $dirPath)) {
            throw "Required directory not found: $dirPath"
        }
    }

    Write-Log "MetaTrader 5 installation validation passed" "SUCCESS"
}

function Test-VSCodeInstallation {
    <#
    .SYNOPSIS
    Check if VS Code is installed and accessible.
    #>
    try {
        $vscodeVersion = & code --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Log "VS Code found: $($vscodeVersion[0])" "SUCCESS"
            return $true
        }
    }
    catch {
        Write-Log "VS Code not found in PATH" "WARNING"
    }

    Write-Log "VS Code not found in PATH. Please install VS Code and ensure it's in PATH." "WARNING"
    return $false
}

function Initialize-ProjectStructure {
    <#
    .SYNOPSIS
    Create the basic project structure.
    #>
    param([string]$ProjectName, [string]$RootPath)

    Write-Log "Initializing project structure for: $ProjectName" "INFO"

    $projectDirs = @(
        "src",
        "include",
        "config",
        "logs",
        "backup"
    )

    foreach ($dir in $projectDirs) {
        $dirPath = Join-Path $RootPath $dir
        if (-not (Test-Path $dirPath)) {
            New-Item -Path $dirPath -ItemType Directory -Force | Out-Null
            Write-Log "Created directory: $dir" "INFO"
        }
    }

    # Create project configuration file
    $configPath = Join-Path $RootPath "config\project.json"
    $projectConfig = @{
        name = $ProjectName
        version = "1.0.0"
        created = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        mt5Path = $MT5Path
        prefix = $ProjectName.ToUpper()
    } | ConvertTo-Json -Depth 3

    $projectConfig | Out-File -FilePath $configPath -Encoding UTF8 -Force
    Write-Log "Created project configuration: $configPath" "SUCCESS"
}

function Show-Summary {
    <#
    .SYNOPSIS
    Display initialization summary.
    #>
    param([string]$ProjectName, [string]$MT5Path)

    Write-Host "`n" -NoNewline
    Write-Host "🎉 Environment Initialization Complete!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "📦 Project Name: " -NoNewline -ForegroundColor White
    Write-Host $ProjectName -ForegroundColor Yellow
    Write-Host "📂 MT5 Path: " -NoNewline -ForegroundColor White
    Write-Host $MT5Path -ForegroundColor Yellow
    Write-Host "📁 Workspace: " -NoNewline -ForegroundColor White
    Write-Host $script:ProjectRoot -ForegroundColor Yellow
    Write-Host "`n" -NoNewline
    Write-Host "🚀 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Run setup script: " -NoNewline -ForegroundColor White
    Write-Host ".\setup\Setup-Environment.ps1 -ProjectName '$ProjectName' -CreateSymlinks -SetupVSCode" -ForegroundColor Green
    Write-Host "   2. Open VS Code: " -NoNewline -ForegroundColor White
    Write-Host "code ." -ForegroundColor Green
    Write-Host "   3. Start developing your MQL5 projects!" -ForegroundColor White
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
}

# Main execution
try {
    Write-Host "🚀 Portable MetaTrader 5 Development Environment Initializer" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan

    # Environment validation
    if (-not $SkipValidation) {
        Write-Log "Performing environment validation..." "INFO"

        if (-not (Test-Administrator)) {
            throw "This script must be run as Administrator for symbolic link creation"
        }

        Test-PowerShellVersion
        Test-VSCodeInstallation
    }

    # MT5 path detection/validation
    if (-not $MT5Path) {
        $MT5Path = Find-MT5Installation
        if (-not $MT5Path) {
            $MT5Path = Read-Host "Please enter the path to your MetaTrader 5 installation"
        }
    }

    Test-MT5Installation -Path $MT5Path

    # Check if already initialized
    $configPath = Join-Path $script:ProjectRoot "config\project.json"
    if ((Test-Path $configPath) -and (-not $Force)) {
        Write-Log "Environment already initialized. Use -Force to reinitialize." "WARNING"
        $continue = Read-Host "Continue anyway? (y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            Write-Log "Initialization cancelled by user" "INFO"
            exit 0
        }
    }

    # Initialize project structure
    Initialize-ProjectStructure -ProjectName $ProjectName -RootPath $script:ProjectRoot

    # Show completion summary
    Show-Summary -ProjectName $ProjectName -MT5Path $MT5Path

    Write-Log "Environment initialization completed successfully!" "SUCCESS"

} catch {
    Write-Log "Environment initialization failed: $($_.Exception.Message)" "ERROR"
    exit 1
}
