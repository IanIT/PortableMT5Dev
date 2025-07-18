#requires -version 5.1
<#
.SYNOPSIS
    Simple and reliable MQL5 compilation script for portable MetaTrader 5 installations.

.DESCRIPTION
    This script compiles MQL5 files using MetaEditor's command-line interface with the
    undocumented /portable flag that ensures portable installations work correctly.

.PARAMETER FilePath
    Path to the .mq5 file to compile. Defaults to the SPSEA SpreadBetScalperEA.

.PARAMETER MetaEditorPath
    Path to MetaEditor64.exe. Defaults to portable installation location.

.EXAMPLE
    .\Build-MQL5.ps1
    Compiles the default MQL5 file using portable MetaTrader 5.

.EXAMPLE
    .\Build-MQL5.ps1 -FilePath "C:\MetaTrader 5\MQL5\Experts\MyEA.mq5"
    Compiles a specific MQL5 file.

.NOTES
    Author: Portable MT5 Development Environment
    Version: 1.0
    Requires: MetaTrader 5 portable installation
    
    This script represents a breakthrough in portable MT5 development by using the
    undocumented /portable flag that forces MetaEditor CLI to use portable paths
    instead of AppData paths.
#>

param(
    [string]$FilePath = "C:\MetaTrader 5\MQL5\Experts\SPSEA_SpreadBetScalperEA.mq5",
    [string]$MetaEditorPath = "C:\MetaTrader 5\MetaEditor64.exe"
)

Write-Host "=== Compiling MQL5 Expert Advisor ===" -ForegroundColor Cyan
Write-Host "File: $FilePath" -ForegroundColor Yellow

# Validate MetaEditor exists
if (-not (Test-Path $MetaEditorPath)) {
    Write-Host "❌ MetaEditor not found at: $MetaEditorPath" -ForegroundColor Red
    Write-Host "💡 Please ensure MetaTrader 5 is installed at the correct location" -ForegroundColor Yellow
    return
}

# Validate source file exists
if (-not (Test-Path $FilePath)) {
    Write-Host "❌ Source file not found: $FilePath" -ForegroundColor Red
    Write-Host "💡 Please ensure the MQL5 file exists and the path is correct" -ForegroundColor Yellow
    return
}

# Determine output file path
$OutputFile = $FilePath -replace '\.mq5$', '.ex5'

# Remove existing output file for clean test
if (Test-Path $OutputFile) {
    Remove-Item $OutputFile -Force
    Write-Host "Removed existing output file" -ForegroundColor Yellow
}

Write-Host "Command: $MetaEditorPath /portable /compile:`"$FilePath`" /log" -ForegroundColor Gray

try {
    # BREAKTHROUGH: Use Start-Process with /portable flag for reliable compilation
    Write-Host "Attempting compilation..." -ForegroundColor Yellow
    
    $ProcessInfo = Start-Process -FilePath $MetaEditorPath -ArgumentList "/portable", "/compile:`"$FilePath`"", "/log" -Wait -PassThru -NoNewWindow
    
    Write-Host "Process exit code: $($ProcessInfo.ExitCode)" -ForegroundColor Gray
    
    # Wait a moment for file system to update
    Start-Sleep -Seconds 2
    
    # Check if compilation was successful
    if (Test-Path $OutputFile) {
        Write-Host "✅ Compilation successful!" -ForegroundColor Green
        Write-Host "Output: $OutputFile" -ForegroundColor Green
        
        # Show file details
        $FileInfo = Get-Item $OutputFile
        Write-Host "File size: $($FileInfo.Length) bytes" -ForegroundColor Gray
        Write-Host "Created: $($FileInfo.CreationTime)" -ForegroundColor Gray
    } else {
        Write-Host "❌ Compilation failed - no output file created" -ForegroundColor Red
        Write-Host "💡 Check MetaEditor logs for error details" -ForegroundColor Yellow
        
        # Check for recent log files
        $LogPath = "C:\MetaTrader 5\Logs"
        if (Test-Path $LogPath) {
            $LogFiles = Get-ChildItem $LogPath -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 3
            if ($LogFiles) {
                Write-Host "Recent log files:" -ForegroundColor Gray
                $LogFiles | ForEach-Object { Write-Host "  - $($_.Name) ($($_.LastWriteTime))" -ForegroundColor Gray }
            }
        }
    }
} catch {
    Write-Host "❌ Error executing MetaEditor: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Ensure MetaTrader 5 is properly installed and accessible" -ForegroundColor Yellow
}

Write-Host "=== Compilation Complete ===" -ForegroundColor Cyan
