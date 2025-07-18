#requires -version 5.1
<#
.SYNOPSIS
    Automated test runner for the Portable MT5 Development Environment.

.DESCRIPTION
    This script runs comprehensive tests to validate the setup, compilation,
    and functionality of the portable MT5 development environment.

.PARAMETER TestType
    Type of tests to run: 'setup', 'compilation', 'functionality', or 'all'.

.PARAMETER MT5Path
    Path to the portable MetaTrader 5 installation.

.PARAMETER Verbose
    Enable detailed output for debugging.

.EXAMPLE
    .\Run-Tests.ps1 -TestType "all"
    Run all available tests.

.EXAMPLE
    .\Run-Tests.ps1 -TestType "compilation" -Verbose
    Run only compilation tests with detailed output.

.NOTES
    Author: Portable MT5 Development Environment
    Version: 1.0
    This script validates the entire development environment setup.
#>

param(
    [ValidateSet("setup", "compilation", "functionality", "all")]
    [string]$TestType = "all",
    [string]$MT5Path = "C:\MetaTrader 5",
    [switch]$Verbose = $false
)

$ErrorActionPreference = 'Continue'

# Auto-detect project root
$projectRoot = $PSScriptRoot
while ($projectRoot -and $projectRoot -ne [System.IO.Path]::GetPathRoot($projectRoot)) {
    if (Test-Path (Join-Path $projectRoot "tests")) {
        break
    }
    $projectRoot = Split-Path $projectRoot -Parent
}

if (-not $projectRoot) {
    $projectRoot = Split-Path $PSScriptRoot -Parent
}

$testResults = @{
    Passed = 0
    Failed = 0
    Skipped = 0
    Details = @()
}

function Write-TestResult {
    param(
        [string]$TestName,
        [string]$Status,  # "PASS", "FAIL", "SKIP"
        [string]$Message = "",
        [object]$Details = $null
    )
    
    $icon = switch ($Status) {
        "PASS" { "✅"; $script:testResults.Passed++ }
        "FAIL" { "❌"; $script:testResults.Failed++ }
        "SKIP" { "⏭️"; $script:testResults.Skipped++ }
    }
    
    $color = switch ($Status) {
        "PASS" { "Green" }
        "FAIL" { "Red" }
        "SKIP" { "Yellow" }
    }
    
    Write-Host "$icon [$Status] $TestName" -ForegroundColor $color
    if ($Message) {
        Write-Host "    $Message" -ForegroundColor Gray
    }
    
    if ($Verbose -and $Details) {
        Write-Host "    Details: $Details" -ForegroundColor Gray
    }
    
    $script:testResults.Details += @{
        Name = $TestName
        Status = $Status
        Message = $Message
        Details = $Details
    }
}

function Test-SetupEnvironment {
    Write-Host "`n🔧 SETUP TESTS" -ForegroundColor Cyan
    Write-Host "=" * 50
    
    # Test 1: Project structure
    $requiredDirs = @("tools", "setup", "examples", "templates", "documentation")
    foreach ($dir in $requiredDirs) {
        $path = Join-Path $projectRoot $dir
        if (Test-Path $path) {
            Write-TestResult "Project Directory: $dir" "PASS"
        } else {
            Write-TestResult "Project Directory: $dir" "FAIL" "Directory not found: $path"
        }
    }
    
    # Test 2: Required scripts
    $requiredScripts = @(
        "tools\Build-MQL5.ps1",
        "tools\Create-FileSymlinks.ps1",
        "setup\Setup-Environment.ps1"
    )
    
    foreach ($script in $requiredScripts) {
        $path = Join-Path $projectRoot $script
        if (Test-Path $path) {
            Write-TestResult "Required Script: $script" "PASS"
        } else {
            Write-TestResult "Required Script: $script" "FAIL" "Script not found: $path"
        }
    }
    
    # Test 3: MetaTrader 5 installation
    if (Test-Path $MT5Path) {
        Write-TestResult "MT5 Installation" "PASS" "Found at: $MT5Path"
        
        $metaEditor = Join-Path $MT5Path "MetaEditor64.exe"
        if (Test-Path $metaEditor) {
            Write-TestResult "MetaEditor64.exe" "PASS"
        } else {
            Write-TestResult "MetaEditor64.exe" "FAIL" "Not found at: $metaEditor"
        }
        
        $mql5Dir = Join-Path $MT5Path "MQL5"
        if (Test-Path $mql5Dir) {
            Write-TestResult "MQL5 Directory" "PASS"
        } else {
            Write-TestResult "MQL5 Directory" "FAIL" "Not found at: $mql5Dir"
        }
    } else {
        Write-TestResult "MT5 Installation" "FAIL" "Not found at: $MT5Path"
    }
    
    # Test 4: PowerShell execution policy
    $executionPolicy = Get-ExecutionPolicy
    if ($executionPolicy -eq "Unrestricted" -or $executionPolicy -eq "RemoteSigned" -or $executionPolicy -eq "Bypass") {
        Write-TestResult "PowerShell Execution Policy" "PASS" "Current policy: $executionPolicy"
    } else {
        Write-TestResult "PowerShell Execution Policy" "FAIL" "Current policy: $executionPolicy (may prevent script execution)"
    }
    
    # Test 5: Administrator privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($isAdmin) {
        Write-TestResult "Administrator Privileges" "PASS"
    } else {
        Write-TestResult "Administrator Privileges" "FAIL" "Required for symbolic link creation"
    }
}

function Test-CompilationSystem {
    Write-Host "`n🔨 COMPILATION TESTS" -ForegroundColor Cyan
    Write-Host "=" * 50
    
    # Test 1: Build script functionality
    $buildScript = Join-Path $projectRoot "tools\Build-MQL5.ps1"
    if (Test-Path $buildScript) {
        try {
            # Test syntax by loading the script
            $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $buildScript -Raw), [ref]$null)
            Write-TestResult "Build Script Syntax" "PASS"
        } catch {
            Write-TestResult "Build Script Syntax" "FAIL" $_.Exception.Message
        }
    } else {
        Write-TestResult "Build Script Syntax" "SKIP" "Build script not found"
    }
    
    # Test 2: Example files compilation
    $exampleFiles = Get-ChildItem -Path (Join-Path $projectRoot "examples") -Filter "*.mq5" -ErrorAction SilentlyContinue
    if ($exampleFiles.Count -gt 0) {
        foreach ($file in $exampleFiles) {
            Write-TestResult "Example File Found" "PASS" $file.Name
            
            # Test if file has basic MQL5 structure
            $content = Get-Content $file.FullName -Raw
            if ($content -match "#property\s+copyright" -and $content -match "void OnStart\(\)|int OnInit\(\)|void OnTick\(\)") {
                Write-TestResult "Example File Structure" "PASS" "$($file.Name) has valid MQL5 structure"
            } else {
                Write-TestResult "Example File Structure" "FAIL" "$($file.Name) missing required MQL5 elements"
            }
        }
    } else {
        Write-TestResult "Example Files" "SKIP" "No .mq5 files found in examples directory"
    }
    
    # Test 3: Portable flag support
    $metaEditor = Join-Path $MT5Path "MetaEditor64.exe"
    if (Test-Path $metaEditor) {
        try {
            # Test if MetaEditor accepts the /portable flag
            $testArgs = @("/portable", "/help")
            $process = Start-Process -FilePath $metaEditor -ArgumentList $testArgs -WindowStyle Hidden -PassThru -Wait
            
            if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 1) {
                Write-TestResult "Portable Flag Support" "PASS" "MetaEditor accepts /portable flag"
            } else {
                Write-TestResult "Portable Flag Support" "FAIL" "MetaEditor may not support /portable flag"
            }
        } catch {
            Write-TestResult "Portable Flag Support" "FAIL" $_.Exception.Message
        }
    } else {
        Write-TestResult "Portable Flag Support" "SKIP" "MetaEditor not found"
    }
}

function Test-FunctionalitySystem {
    Write-Host "`n⚙️ FUNCTIONALITY TESTS" -ForegroundColor Cyan
    Write-Host "=" * 50
    
    # Test 1: Symlink creation script
    $symlinkScript = Join-Path $projectRoot "tools\Create-FileSymlinks.ps1"
    if (Test-Path $symlinkScript) {
        try {
            # Test dry run functionality
            $result = & $symlinkScript -DryRun -ProjectRoot $projectRoot -MT5Root (Join-Path $MT5Path "MQL5") 2>&1
            if ($LASTEXITCODE -eq 0 -or $result -match "DRY RUN") {
                Write-TestResult "Symlink Script Dry Run" "PASS"
            } else {
                Write-TestResult "Symlink Script Dry Run" "FAIL" "Script execution failed"
            }
        } catch {
            Write-TestResult "Symlink Script Dry Run" "FAIL" $_.Exception.Message
        }
    } else {
        Write-TestResult "Symlink Script Dry Run" "SKIP" "Symlink script not found"
    }
    
    # Test 2: VS Code configuration templates
    $vscodeTemplates = @(
        "templates\vscode\tasks.json",
        "templates\vscode\settings.json"
    )
    
    foreach ($template in $vscodeTemplates) {
        $path = Join-Path $projectRoot $template
        if (Test-Path $path) {
            try {
                $content = Get-Content $path -Raw | ConvertFrom-Json
                Write-TestResult "VS Code Template: $template" "PASS" "Valid JSON structure"
            } catch {
                Write-TestResult "VS Code Template: $template" "FAIL" "Invalid JSON: $($_.Exception.Message)"
            }
        } else {
            Write-TestResult "VS Code Template: $template" "FAIL" "Template not found"
        }
    }
    
    # Test 3: Documentation completeness
    $requiredDocs = @(
        "README.md",
        "documentation\SETUP_GUIDE.md",
        "documentation\COMPILATION_GUIDE.md"
    )
    
    foreach ($doc in $requiredDocs) {
        $path = Join-Path $projectRoot $doc
        if (Test-Path $path) {
            $content = Get-Content $path -Raw
            if ($content.Length -gt 100) {
                Write-TestResult "Documentation: $doc" "PASS" "Contains substantial content"
            } else {
                Write-TestResult "Documentation: $doc" "FAIL" "Content too brief"
            }
        } else {
            Write-TestResult "Documentation: $doc" "FAIL" "Document not found"
        }
    }
}

function Show-TestSummary {
    Write-Host "`n📊 TEST SUMMARY" -ForegroundColor Cyan
    Write-Host "=" * 50
    
    $total = $testResults.Passed + $testResults.Failed + $testResults.Skipped
    
    Write-Host "Total Tests: $total" -ForegroundColor White
    Write-Host "✅ Passed: $($testResults.Passed)" -ForegroundColor Green
    Write-Host "❌ Failed: $($testResults.Failed)" -ForegroundColor Red
    Write-Host "⏭️ Skipped: $($testResults.Skipped)" -ForegroundColor Yellow
    
    $passRate = if ($total -gt 0) { [math]::Round(($testResults.Passed / $total) * 100, 1) } else { 0 }
    Write-Host "Pass Rate: $passRate%" -ForegroundColor $(if ($passRate -ge 80) { "Green" } elseif ($passRate -ge 60) { "Yellow" } else { "Red" })
    
    if ($testResults.Failed -gt 0) {
        Write-Host "`n❌ FAILED TESTS:" -ForegroundColor Red
        $failedTests = $testResults.Details | Where-Object { $_.Status -eq "FAIL" }
        foreach ($test in $failedTests) {
            Write-Host "  • $($test.Name): $($test.Message)" -ForegroundColor Red
        }
        
        Write-Host "`n💡 RECOMMENDATIONS:" -ForegroundColor Yellow
        Write-Host "  1. Check the setup requirements in README.md" -ForegroundColor Gray
        Write-Host "  2. Ensure MetaTrader 5 is properly installed" -ForegroundColor Gray
        Write-Host "  3. Run PowerShell as Administrator" -ForegroundColor Gray
        Write-Host "  4. Verify all required files are present" -ForegroundColor Gray
    } else {
        Write-Host "`n🎉 All tests passed! The environment is ready for use." -ForegroundColor Green
    }
}

# Main execution
Write-Host "🧪 Portable MT5 Development Environment Test Runner" -ForegroundColor Cyan
Write-Host "Project Root: $projectRoot" -ForegroundColor Yellow
Write-Host "MT5 Path: $MT5Path" -ForegroundColor Yellow
Write-Host "Test Type: $TestType" -ForegroundColor Yellow
Write-Host ""

# Run tests based on type
switch ($TestType) {
    "setup" { Test-SetupEnvironment }
    "compilation" { Test-CompilationSystem }
    "functionality" { Test-FunctionalitySystem }
    "all" {
        Test-SetupEnvironment
        Test-CompilationSystem
        Test-FunctionalitySystem
    }
}

Show-TestSummary

# Exit with appropriate code
if ($testResults.Failed -gt 0) {
    exit 1
} else {
    exit 0
}
