# Compilation Guide

This guide covers the compilation process for MQL5 files in the Portable MT5 Development Environment.

## Overview

The compilation system uses MetaEditor's command-line interface with the crucial `/portable` flag to ensure proper operation with portable MT5 installations.

## Quick Start

### Using VS Code

1. **Action Button Method** (Recommended)
   - Install the "Action Buttons" extension
   - Click the "🔨 Build MQL5" button in the status bar
   - View results in the integrated terminal

2. **Command Palette Method**
   - Press `Ctrl+Shift+P`
   - Type "Tasks: Run Task"
   - Select "Build MQL5"

3. **Keyboard Shortcut**
   - Press `Ctrl+Shift+B` (Build shortcut)
   - Select "Build MQL5" from the list

### Using PowerShell

```powershell
# Navigate to project directory
cd "N:\YourProject"

# Run build script
.\tools\Build-MQL5.ps1
```

## Build Script Reference

### Basic Usage

```powershell
.\tools\Build-MQL5.ps1 [parameters]
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-SourceFiles` | String[] | Auto-detect | Specific files to compile |
| `-MT5Path` | String | "C:\MetaTrader 5" | Path to MT5 installation |
| `-IncludePath` | String | "Include" | Additional include directory |
| `-Verbose` | Switch | False | Enable detailed output |
| `-CleanBuild` | Switch | False | Clean before building |

### Examples

```powershell
# Compile all files
.\tools\Build-MQL5.ps1

# Compile specific files
.\tools\Build-MQL5.ps1 -SourceFiles @("Experts\MyEA.mq5", "Scripts\MyScript.mq5")

# Use custom MT5 path
.\tools\Build-MQL5.ps1 -MT5Path "D:\MT5-Custom"

# Verbose output
.\tools\Build-MQL5.ps1 -Verbose

# Clean build
.\tools\Build-MQL5.ps1 -CleanBuild
```

## Compilation Process

### Step-by-Step Process

1. **Environment Validation**
   - Check MT5 installation
   - Verify MetaEditor64.exe
   - Validate source files

2. **File Discovery**
   - Scan for .mq5 files
   - Check include dependencies
   - Validate file accessibility

3. **Compilation Execution**
   - Use `/portable` flag
   - Pass include paths
   - Capture output and errors

4. **Result Processing**
   - Parse compilation output
   - Report success/failure
   - Display warnings and errors

### Compilation Command

The actual MetaEditor command used:

```cmd
MetaEditor64.exe /portable /compile:"SourceFile.mq5" /inc:"Include" /log
```

### Key Flags

- `/portable`: Essential for portable installations
- `/compile`: Specifies the file to compile
- `/inc`: Additional include directories
- `/log`: Enable detailed logging

## File Organization

### Source File Structure

```
Project/
├── Experts/
│   ├── MyEA.mq5           # Will compile to MyEA.ex5
│   └── AnotherEA.mq5      # Will compile to AnotherEA.ex5
├── Scripts/
│   ├── Utility.mq5        # Will compile to Utility.ex5
│   └── Test.mq5           # Will compile to Test.ex5
├── Indicators/
│   └── Custom.mq5         # Will compile to Custom.ex5
└── Include/
    ├── Common.mqh         # Include file (not compiled)
    └── Library.mqh        # Include file (not compiled)
```

### Compiled Output Location

Compiled files (.ex5) are placed in the MT5 directory structure:

```
C:\MetaTrader 5\MQL5\
├── Experts\
│   ├── PREFIX_MyEA.ex5
│   └── PREFIX_AnotherEA.ex5
├── Scripts\
│   ├── PREFIX_Utility.ex5
│   └── PREFIX_Test.ex5
└── Indicators\
    └── PREFIX_Custom.ex5
```

## Error Handling

### Common Compilation Errors

1. **Syntax Errors**
   ```
   Error: Syntax error at line 45
   Solution: Check code syntax at the specified line
   ```

2. **Include File Not Found**
   ```
   Error: Cannot open include file 'MyLibrary.mqh'
   Solution: Verify include file exists and path is correct
   ```

3. **Function Not Declared**
   ```
   Error: 'MyFunction' - function not declared
   Solution: Add function declaration or include proper header
   ```

4. **Invalid Property**
   ```
   Error: Invalid property directive
   Solution: Check #property statements syntax
   ```

### MetaEditor-Specific Errors

1. **MetaEditor Not Found**
   ```
   Error: MetaEditor64.exe not found at specified path
   Solution: Check MT5 installation and update path in script
   ```

2. **Portable Flag Not Supported**
   ```
   Error: Unknown command line option '/portable'
   Solution: Update MetaEditor or check MT5 version
   ```

3. **File Access Denied**
   ```
   Error: Cannot access source file
   Solution: Check file permissions and symlink validity
   ```

### Build Script Errors

1. **PowerShell Execution Policy**
   ```
   Error: Execution policy prevents script running
   Solution: Set-ExecutionPolicy RemoteSigned
   ```

2. **Administrator Privileges**
   ```
   Error: Access denied creating symbolic links
   Solution: Run PowerShell as Administrator
   ```

## Advanced Compilation

### Custom Include Paths

```powershell
# Add multiple include directories
.\tools\Build-MQL5.ps1 -IncludePath @("Include", "Libraries", "External")
```

### Conditional Compilation

Use preprocessor directives for different builds:

```mql5
#ifdef DEBUG
    Print("Debug mode enabled");
#endif

#ifdef PRODUCTION
    // Production-specific code
#endif
```

Build with defines:

```powershell
# Debug build
.\tools\Build-MQL5.ps1 -CompilerFlags @("/define:DEBUG")

# Production build
.\tools\Build-MQL5.ps1 -CompilerFlags @("/define:PRODUCTION")
```

### Optimization Settings

```powershell
# Optimized build
.\tools\Build-MQL5.ps1 -CompilerFlags @("/optimize")

# Debug build with symbols
.\tools\Build-MQL5.ps1 -CompilerFlags @("/debug")
```

## Integration with Development Tools

### VS Code Integration

#### tasks.json Configuration

```json
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
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": {
                "pattern": {
                    "regexp": "^(.*)\\((\\d+),(\\d+)\\):\\s+(warning|error)\\s+(\\w+):\\s+(.*)$",
                    "file": 1,
                    "line": 2,
                    "column": 3,
                    "severity": 4,
                    "code": 5,
                    "message": 6
                }
            }
        }
    ]
}
```

#### Action Buttons Configuration

```json
{
    "actionButtons": {
        "defaultColor": "#007acc",
        "commands": [
            {
                "name": "🔨 Build MQL5",
                "color": "green",
                "singleInstance": true,
                "command": "powershell.exe -ExecutionPolicy Bypass -File tools/Build-MQL5.ps1"
            },
            {
                "name": "🧹 Clean Build",
                "color": "orange",
                "command": "powershell.exe -ExecutionPolicy Bypass -File tools/Build-MQL5.ps1 -CleanBuild"
            }
        ]
    }
}
```

### Git Integration

#### Pre-commit Hooks

```bash
#!/bin/sh
# .git/hooks/pre-commit

# Compile all MQL5 files before commit
powershell.exe -ExecutionPolicy Bypass -File tools/Build-MQL5.ps1

if [ $? -ne 0 ]; then
    echo "Compilation failed. Commit aborted."
    exit 1
fi
```

#### GitHub Actions

```yaml
name: Build MQL5

on: [push, pull_request]

jobs:
  build:
    runs-on: windows-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup MetaTrader 5
      run: |
        # Download and setup MT5
        # (Implementation depends on your setup)
    
    - name: Build MQL5 Files
      run: |
        powershell -ExecutionPolicy Bypass -File tools/Build-MQL5.ps1
```

## Performance Optimization

### Build Speed Optimization

1. **Parallel Compilation**
   ```powershell
   # Enable parallel builds for multiple files
   .\tools\Build-MQL5.ps1 -Parallel
   ```

2. **Incremental Builds**
   ```powershell
   # Only compile changed files
   .\tools\Build-MQL5.ps1 -Incremental
   ```

3. **Exclude Unchanged Files**
   ```powershell
   # Skip files that haven't changed
   .\tools\Build-MQL5.ps1 -SkipUnchanged
   ```

### Memory Usage

- Large projects may require increasing MetaEditor memory limits
- Consider splitting large files into smaller modules
- Use forward declarations to reduce compilation dependencies

## Debugging Compilation Issues

### Verbose Output

```powershell
.\tools\Build-MQL5.ps1 -Verbose
```

This shows:
- File discovery process
- MetaEditor command line
- Full compilation output
- Error details

### Manual Compilation

For troubleshooting, compile manually:

```cmd
cd "C:\MetaTrader 5"
MetaEditor64.exe /portable /compile:"N:\Project\Experts\MyEA.mq5" /inc:"N:\Project\Include" /log
```

### Log Files

Check MetaEditor log files:
- Location: `%APPDATA%\MetaQuotes\Terminal\<ID>\MQL5\Logs\`
- Files: `YYYYMMDD.log`

### Common Debug Steps

1. **Verify File Paths**
   ```powershell
   Test-Path "N:\Project\Experts\MyEA.mq5"
   ```

2. **Check Symlinks**
   ```powershell
   Get-ChildItem "C:\MetaTrader 5\MQL5\Experts" | Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint}
   ```

3. **Test MetaEditor**
   ```cmd
   MetaEditor64.exe /portable /help
   ```

## Best Practices

### Code Organization

1. **Modular Design**
   - Separate functionality into include files
   - Use clear naming conventions
   - Document dependencies

2. **Include Management**
   ```mql5
   // Use relative paths
   #include "Common\Utilities.mqh"
   #include "Trading\OrderManager.mqh"
   ```

3. **Conditional Compilation**
   ```mql5
   #ifdef DEBUG
       #include "Debug\DebugUtils.mqh"
   #endif
   ```

### Build Automation

1. **Consistent Environment**
   - Use same MT5 version across team
   - Document required includes
   - Version control build scripts

2. **Error Handling**
   - Always check compilation results
   - Log build outputs
   - Fail fast on errors

3. **Testing Integration**
   - Compile before running tests
   - Validate in different environments
   - Automate regression testing

### Project Structure

```
Project/
├── src/
│   ├── Experts/
│   ├── Include/
│   └── Scripts/
├── tests/
│   ├── unit/
│   └── integration/
├── docs/
├── tools/
│   ├── Build-MQL5.ps1
│   └── Deploy.ps1
└── .vscode/
    ├── tasks.json
    └── settings.json
```

This structure provides:
- Clear separation of concerns
- Easy build automation
- Consistent development environment
- Scalable project organization
