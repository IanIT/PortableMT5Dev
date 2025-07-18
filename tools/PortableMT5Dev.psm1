#requires -version 5.1

<#
.SYNOPSIS
    PowerShell module for Portable MT5 Development Environment.

.DESCRIPTION
    This module provides advanced functions for managing portable MetaTrader 5
    development environments, including compilation, symbolic link management,
    and environment validation.

.NOTES
    Author: Portable MT5 Development Environment
    Version: 1.0
    Module Name: PortableMT5Dev
#>

# Module variables
$script:ModuleRoot = $PSScriptRoot
$script:ProjectRoot = Split-Path $PSScriptRoot -Parent
$script:DefaultMT5Path = "C:\MetaTrader 5"
$script:LogLevel = "INFO"

# Export functions
$ExportedFunctions = @(
    'Get-MT5Installation',
    'Test-MT5Environment',
    'Invoke-MQL5Compilation',
    'New-FileSymlink',
    'Test-DevelopmentEnvironment',
    'Get-ProjectConfiguration',
    'Set-ProjectConfiguration',
    'Write-PortableLog'
)

#region Logging Functions

function Write-PortableLog {
    <#
    .SYNOPSIS
    Write formatted log messages with color coding.

    .PARAMETER Message
    The message to log.

    .PARAMETER Level
    The log level (INFO, WARNING, ERROR, SUCCESS).

    .PARAMETER NoTimestamp
    Skip timestamp in output.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS")]
        [string]$Level = "INFO",

        [switch]$NoTimestamp
    )

    $colors = @{
        "INFO"    = "White"
        "WARNING" = "Yellow"
        "ERROR"   = "Red"
        "SUCCESS" = "Green"
    }

    $prefix = if ($NoTimestamp) { "[$Level]" } else { "[$(Get-Date -Format 'HH:mm:ss')] [$Level]" }

    Write-Host "$prefix $Message" -ForegroundColor $colors[$Level]
}#endregion

#region Environment Functions

function Get-MT5Installation {
    <#
    .SYNOPSIS
    Detect and validate MetaTrader 5 installations.

    .PARAMETER Path
    Specific path to check. If not provided, auto-detection is performed.

    .PARAMETER IncludePortable
    Include portable installations in search.

    .EXAMPLE
    $mt5Info = Get-MT5Installation
    Write-Output "MT5 found at: $($mt5Info.Path)"
    #>
    [CmdletBinding()]
    param(
        [string]$Path = "",
        [switch]$IncludePortable = $true
    )

    if ($Path) {
        if (Test-Path $Path) {
            return Test-MT5Installation -Path $Path -ReturnObject
        } else {
            throw "Specified MT5 path does not exist: $Path"
        }
    }

    Write-PortableLog "Searching for MetaTrader 5 installations..." -Level INFO

    $searchPaths = @(
        "C:\Program Files\MetaTrader 5",
        "C:\Program Files (x86)\MetaTrader 5"
    )

    if ($IncludePortable) {
        $drives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
        foreach ($drive in $drives) {
            $searchPaths += @(
                "$($drive.DeviceID)\MetaTrader 5",
                "$($drive.DeviceID)\MT5",
                "$($drive.DeviceID)\MetaTrader5",
                "$($drive.DeviceID)\Portable\MetaTrader 5"
            )
        }
    }

    $installations = @()
    foreach ($searchPath in $searchPaths) {
        if (Test-Path $searchPath) {
            $installation = Test-MT5Installation -Path $searchPath -ReturnObject -Silent
            if ($installation) {
                $installations += $installation
            }
        }
    }

    if ($installations.Count -eq 0) {
        throw "No MetaTrader 5 installations found"
    }

    Write-PortableLog "Found $($installations.Count) MT5 installation(s)" -Level SUCCESS
    return $installations
}

function Test-MT5Environment {
    <#
    .SYNOPSIS
    Comprehensive test of MT5 development environment.

    .PARAMETER MT5Path
    Path to MetaTrader 5 installation.

    .PARAMETER TestCompilation
    Test compilation capabilities.

    .EXAMPLE
    $result = Test-MT5Environment -MT5Path "C:\MetaTrader 5" -TestCompilation
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$MT5Path,

        [switch]$TestCompilation
    )

    $result = @{
        Valid = $true
        Issues = @()
        Details = @{}
    }

    try {
        # Test basic installation
        $installation = Test-MT5Installation -Path $MT5Path -ReturnObject
        $result.Details.Installation = $installation

        # Test compilation if requested
        if ($TestCompilation) {
            $testFile = Join-Path $MT5Path "MQL5\Experts\TestEA.mq5"
            if (Test-Path $testFile) {
                $compileResult = Invoke-MQL5Compilation -FilePath $testFile -Silent
                $result.Details.Compilation = $compileResult

                if (-not $compileResult.Success) {
                    $result.Issues += "Compilation test failed"
                }
            } else {
                $result.Issues += "No test file available for compilation"
            }
        }

        # Test symbolic link capabilities
        $tempDir = Join-Path $env:TEMP "MT5DevTest"
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force
        }
        New-Item -Path $tempDir -ItemType Directory -Force | Out-Null

        $testFile = Join-Path $tempDir "test.txt"
        $linkFile = Join-Path $tempDir "test_link.txt"
        "test content" | Out-File -FilePath $testFile

        try {
            New-Item -Path $linkFile -ItemType SymbolicLink -Value $testFile -Force | Out-Null
            $result.Details.SymbolicLinks = $true
            Remove-Item $tempDir -Recurse -Force
        } catch {
            $result.Details.SymbolicLinks = $false
            $result.Issues += "Symbolic link creation failed - Administrator privileges required"
        }

    } catch {
        $result.Valid = $false
        $result.Issues += $_.Exception.Message
    }

    if ($result.Issues.Count -gt 0) {
        $result.Valid = $false
    }

    return $result
}

function Test-MT5Installation {
    <#
    .SYNOPSIS
    Validate a MetaTrader 5 installation.

    .PARAMETER Path
    Path to MT5 installation.

    .PARAMETER ReturnObject
    Return detailed object instead of boolean.

    .PARAMETER Silent
    Suppress error messages.

    .EXAMPLE
    $isValid = Test-MT5Installation -Path "C:\MetaTrader 5"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [switch]$ReturnObject,
        [switch]$Silent
    )

    $result = @{
        Valid = $false
        Path = $Path
        IsPortable = $false
        Version = $null
        Components = @{}
        Issues = @()
    }

    try {
        if (-not (Test-Path $Path)) {
            throw "Path does not exist: $Path"
        }

        # Check required files
        $requiredFiles = @{
            "MetaEditor64.exe" = "MetaEditor executable"
            "terminal64.exe" = "Terminal executable"
        }

        foreach ($file in $requiredFiles.Keys) {
            $filePath = Join-Path $Path $file
            if (Test-Path $filePath) {
                $result.Components[$file] = $filePath
            } else {
                $result.Issues += "Missing required file: $file"
            }
        }

        # Check required directories
        $requiredDirs = @{
            "MQL5" = "MQL5 source directory"
            "MQL5\Experts" = "Expert Advisors directory"
            "MQL5\Include" = "Include files directory"
        }

        foreach ($dir in $requiredDirs.Keys) {
            $dirPath = Join-Path $Path $dir
            if (Test-Path $dirPath) {
                $result.Components[$dir] = $dirPath
            } else {
                $result.Issues += "Missing required directory: $dir"
            }
        }

        # Check if portable
        $configFile = Join-Path $Path "config\common.ini"
        $result.IsPortable = Test-Path $configFile

        # Try to get version
        $terminalPath = Join-Path $Path "terminal64.exe"
        if (Test-Path $terminalPath) {
            try {
                $versionInfo = Get-ItemProperty -Path $terminalPath
                $result.Version = $versionInfo.VersionInfo.ProductVersion
            } catch {
                # Version detection failed, but not critical
            }
        }

        $result.Valid = $result.Issues.Count -eq 0

    } catch {
        $result.Issues += $_.Exception.Message
    }

    if (-not $Silent -and $result.Issues.Count -gt 0) {
        foreach ($issue in $result.Issues) {
            Write-PortableLog $issue -Level ERROR
        }
    }

    return if ($ReturnObject) { $result } else { $result.Valid }
}

#endregion

#region Compilation Functions

function Invoke-MQL5Compilation {
    <#
    .SYNOPSIS
    Compile MQL5 files using MetaEditor with portable flag.

    .PARAMETER FilePath
    Path to the MQL5 file to compile.

    .PARAMETER MT5Path
    Path to MetaTrader 5 installation.

    .PARAMETER OutputPath
    Optional output path for compiled file.

    .PARAMETER Silent
    Suppress output messages.

    .EXAMPLE
    $result = Invoke-MQL5Compilation -FilePath "C:\MT5\MQL5\Experts\MyEA.mq5"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [string]$MT5Path = $script:DefaultMT5Path,
        [string]$OutputPath = "",
        [switch]$Silent
    )

    $result = @{
        Success = $false
        OutputFile = ""
        ExitCode = -1
        Duration = 0
        Issues = @()
    }

    try {
        $startTime = Get-Date

        # Validate inputs
        if (-not (Test-Path $FilePath)) {
            throw "Source file not found: $FilePath"
        }

        $metaeditorPath = Join-Path $MT5Path "MetaEditor64.exe"
        if (-not (Test-Path $metaeditorPath)) {
            throw "MetaEditor not found: $metaeditorPath"
        }

        # Determine output file
        if (-not $OutputPath) {
            $OutputPath = $FilePath -replace '\.mq5$', '.ex5'
        }
        $result.OutputFile = $OutputPath

        # Clean previous output
        if (Test-Path $OutputPath) {
            Remove-Item $OutputPath -Force
        }

        if (-not $Silent) {
            Write-PortableLog "Compiling: $(Split-Path $FilePath -Leaf)" -Level INFO
        }

        # Execute compilation
        $processArgs = @("/portable", "/compile:`"$FilePath`"", "/log")
        $process = Start-Process -FilePath $metaeditorPath -ArgumentList $processArgs -Wait -PassThru -NoNewWindow

        $result.ExitCode = $process.ExitCode
        $result.Duration = (Get-Date) - $startTime

        # Check if compilation succeeded
        if (Test-Path $OutputPath) {
            $result.Success = $true
            if (-not $Silent) {
                Write-PortableLog "Compilation successful: $(Split-Path $OutputPath -Leaf)" -Level SUCCESS
            }
        } else {
            $result.Issues += "Compilation failed - no output file created"
            if (-not $Silent) {
                Write-PortableLog "Compilation failed" -Level ERROR
            }
        }

    } catch {
        $result.Issues += $_.Exception.Message
        if (-not $Silent) {
            Write-PortableLog $_.Exception.Message -Level ERROR
        }
    }

    return $result
}

#endregion

#region Symbolic Link Functions

function New-FileSymlink {
    <#
    .SYNOPSIS
    Create file-level symbolic links for MQL5 development.

    .PARAMETER SourcePath
    Source directory containing MQL5 files.

    .PARAMETER TargetPath
    Target directory (usually MT5 MQL5 directory).

    .PARAMETER Prefix
    Prefix for symbolic link files to prevent conflicts.

    .PARAMETER FileTypes
    Array of file extensions to create links for.

    .EXAMPLE
    New-FileSymlink -SourcePath ".\src" -TargetPath "C:\MT5\MQL5\Experts" -Prefix "MYEA_"
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath,

        [string]$Prefix = "DEV_",
        [string[]]$FileTypes = @("*.mq5", "*.mqh")
    )    if (-not (Test-Path $SourcePath)) {
        throw "Source path does not exist: $SourcePath"
    }

    if (-not (Test-Path $TargetPath)) {
        throw "Target path does not exist: $TargetPath"
    }

    $linksCreated = 0
    $errors = @()

    foreach ($fileType in $FileTypes) {
        $sourceFiles = Get-ChildItem -Path $SourcePath -Filter $fileType -Recurse

        foreach ($sourceFile in $sourceFiles) {
            try {
                $linkName = "$Prefix$($sourceFile.Name)"
                $linkPath = Join-Path $TargetPath $linkName

                # Remove existing link if it exists
                if (Test-Path $linkPath) {
                    Remove-Item $linkPath -Force
                }

                # Create symbolic link
                if ($PSCmdlet.ShouldProcess($linkPath, "Create symbolic link")) {
                    New-Item -Path $linkPath -ItemType SymbolicLink -Value $sourceFile.FullName -Force | Out-Null

                    Write-PortableLog "Created link: $linkName -> $($sourceFile.Name)" -Level SUCCESS
                    $linksCreated++
                }            } catch {
                $errors += "Failed to create link for $($sourceFile.Name): $($_.Exception.Message)"
                Write-PortableLog "Failed to create link for $($sourceFile.Name)" -Level ERROR
            }
        }
    }

    Write-PortableLog "Created $linksCreated symbolic links" -Level SUCCESS

    if ($errors.Count -gt 0) {
        Write-PortableLog "Encountered $($errors.Count) errors during link creation" -Level WARNING
        return @{
            Success = $false
            LinksCreated = $linksCreated
            Errors = $errors
        }
    }

    return @{
        Success = $true
        LinksCreated = $linksCreated
        Errors = @()
    }
}

#endregion

#region Configuration Functions

function Get-ProjectConfiguration {
    <#
    .SYNOPSIS
    Get project configuration from project.json file.

    .PARAMETER ProjectPath
    Path to project directory.

    .EXAMPLE
    $config = Get-ProjectConfiguration
    #>
    [CmdletBinding()]
    param(
        [string]$ProjectPath = $script:ProjectRoot
    )

    $configPath = Join-Path $ProjectPath "project.json"

    if (-not (Test-Path $configPath)) {
        throw "Project configuration file not found: $configPath"
    }

    try {
        $config = Get-Content $configPath | ConvertFrom-Json
        return $config
    } catch {
        throw "Failed to parse project configuration: $($_.Exception.Message)"
    }
}

function Set-ProjectConfiguration {
    <#
    .SYNOPSIS
    Update project configuration.

    .PARAMETER Configuration
    Configuration object to save.

    .PARAMETER ProjectPath
    Path to project directory.

    .EXAMPLE
    Set-ProjectConfiguration -Configuration $config
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [object]$Configuration,

        [string]$ProjectPath = $script:ProjectRoot
    )    $configPath = Join-Path $ProjectPath "project.json"

    try {
        $Configuration | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -Encoding UTF8 -Force
        Write-PortableLog "Project configuration updated: $configPath" -Level SUCCESS
    } catch {
        throw "Failed to save project configuration: $($_.Exception.Message)"
    }
}

#endregion

#region Testing Functions

function Test-DevelopmentEnvironment {
    <#
    .SYNOPSIS
    Run comprehensive tests on the development environment.

    .PARAMETER MT5Path
    Path to MetaTrader 5 installation.

    .PARAMETER TestCompilation
    Test compilation capabilities.

    .PARAMETER TestSymlinks
    Test symbolic link creation.

    .EXAMPLE
    $result = Test-DevelopmentEnvironment -TestCompilation -TestSymlinks
    #>
    [CmdletBinding()]
    param(
        [string]$MT5Path = $script:DefaultMT5Path,
        [switch]$TestCompilation,
        [switch]$TestSymlinks
    )

    $testResult = @{
        OverallResult = $true
        TestsPassed = 0
        TestsFailed = 0
        Details = @{}
    }

    Write-PortableLog "Running development environment tests..." -Level INFO

    # Test MT5 installation
    try {
        $mt5Test = Test-MT5Environment -MT5Path $MT5Path -TestCompilation:$TestCompilation
        $testResult.Details.MT5Environment = $mt5Test

        if ($mt5Test.Valid) {
            $testResult.TestsPassed++
            Write-PortableLog "MT5 Environment: PASS" -Level SUCCESS
        } else {
            $testResult.TestsFailed++
            $testResult.OverallResult = $false
            Write-PortableLog "MT5 Environment: FAIL" -Level ERROR
        }
    } catch {
        $testResult.TestsFailed++
        $testResult.OverallResult = $false
        $testResult.Details.MT5Environment = @{ Valid = $false; Issues = @($_.Exception.Message) }
        Write-PortableLog "MT5 Environment: FAIL - $($_.Exception.Message)" -Level ERROR
    }

    # Test PowerShell environment
    try {
        $psVersion = $PSVersionTable.PSVersion
        $requiredVersion = [Version]"5.1"

        if ($psVersion -ge $requiredVersion) {
            $testResult.TestsPassed++
            Write-PortableLog "PowerShell Version: PASS ($psVersion)" -Level SUCCESS
        } else {
            $testResult.TestsFailed++
            $testResult.OverallResult = $false
            Write-PortableLog "PowerShell Version: FAIL (Required: $requiredVersion, Found: $psVersion)" -Level ERROR
        }
    } catch {
        $testResult.TestsFailed++
        $testResult.OverallResult = $false
        Write-PortableLog "PowerShell Version: FAIL - $($_.Exception.Message)" -Level ERROR
    }

    return $testResult
}

#endregion

# Export functions
Export-ModuleMember -Function $ExportedFunctions

# Module initialization
Write-PortableLog "Portable MT5 Development Environment Module loaded" -Level SUCCESS -NoTimestamp
