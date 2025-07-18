# Setup Guide

This guide will help you set up the Portable MT5 Development Environment for MQL5 development.

## Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- MetaTrader 5 (portable installation recommended)
- VS Code (optional but recommended)
- Administrator privileges (for symbolic link creation)

## Quick Setup

### Option 1: Automated Setup

1. Clone or download this repository
2. Open PowerShell as Administrator
3. Navigate to the project directory
4. Run the setup script:

```powershell
.\setup\Setup-Environment.ps1 -ProjectName "YourProjectName" -CreateSymlinks -SetupVSCode
```

### Option 2: Manual Setup

1. **Install MetaTrader 5**
   - Download MT5 from your broker
   - Install in portable mode (recommended: `C:\MetaTrader 5\`)

2. **Configure PowerShell**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Create Project Structure**
   ```
   YourProject/
   ├── Experts/        # Expert Advisors (.mq5)
   ├── Include/        # Include files (.mqh)
   ├── Scripts/        # Scripts (.mq5)
   ├── Indicators/     # Custom indicators (.mq5)
   ├── Files/          # Resource files
   ├── tools/          # Build and utility scripts
   └── .vscode/        # VS Code configuration
   ```

4. **Set up Build Tools**
   - Copy `tools/Build-MQL5.ps1` to your project
   - Modify the MT5 path in the script if needed

5. **Create Symbolic Links**
   ```powershell
   .\tools\Create-FileSymlinks.ps1 -ProjectRoot "." -FilePrefix "YOURPREFIX_"
   ```

## Detailed Configuration

### MetaTrader 5 Setup

1. **Portable Installation**
   ```
   C:\MetaTrader 5\
   ├── MetaEditor64.exe
   ├── terminal64.exe
   └── MQL5\
       ├── Experts\
       ├── Include\
       ├── Scripts\
       ├── Indicators\
       └── Files\
   ```

2. **Verify Installation**
   - Open MetaEditor64.exe
   - Check that it recognizes the portable configuration
   - Verify MQL5 directory structure

### VS Code Integration

1. **Install Required Extensions**
   - Action Buttons (seunlanlege.action-buttons)
   - PowerShell (ms-vscode.powershell)

2. **Configure Workspace**
   ```json
   // .vscode/settings.json
   {
     "actionButtons": {
       "commands": [
         {
           "name": "🔨 Build MQL5",
           "color": "green",
           "command": "powershell.exe -ExecutionPolicy Bypass -File tools/Build-MQL5.ps1"
         }
       ]
     }
   }
   ```

3. **Set up Build Tasks**
   ```json
   // .vscode/tasks.json
   {
     "version": "2.0.0",
     "tasks": [
       {
         "label": "Build MQL5",
         "type": "shell",
         "command": "powershell.exe",
         "args": ["-ExecutionPolicy", "Bypass", "-File", "tools/Build-MQL5.ps1"],
         "group": "build"
       }
     ]
   }
   ```

## File Organization

### Project Structure

```
YourProject/
├── Experts/
│   └── YourEA.mq5              # Your Expert Advisor
├── Include/
│   └── YourLibrary.mqh         # Your include files
├── Scripts/
│   └── YourScript.mq5          # Utility scripts
├── tools/
│   ├── Build-MQL5.ps1          # Main build script
│   └── Create-FileSymlinks.ps1 # Symlink creation
├── .vscode/
│   ├── settings.json           # VS Code settings
│   └── tasks.json              # Build tasks
└── README.md
```

### Naming Conventions

To prevent conflicts with other projects, use consistent prefixes:

- **Files**: `YOURPROJECT_FileName.mq5`
- **Classes**: `CYourProjectClassName`
- **Functions**: `YourProject_FunctionName()`
- **Variables**: `g_yourproject_variableName`

## Symbolic Links

### Why File-Level Symlinks?

1. **Precise Control**: Link individual files instead of entire directories
2. **Conflict Prevention**: Use prefixes to avoid naming conflicts
3. **Multiple Projects**: Different projects can coexist safely
4. **Easy Maintenance**: Clear visibility of which files are linked

### Creating Symlinks

```powershell
# Manual creation
New-Item -ItemType SymbolicLink -Path "C:\MetaTrader 5\MQL5\Experts\MYEA_Expert.mq5" -Target "N:\MyProject\Experts\Expert.mq5"

# Automated creation
.\tools\Create-FileSymlinks.ps1 -ProjectRoot "." -FilePrefix "MYEA_" -DryRun
```

### Managing Symlinks

```powershell
# List all symlinks
Get-ChildItem "C:\MetaTrader 5\MQL5" -Recurse | Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint}

# Remove specific symlink
Remove-Item "C:\MetaTrader 5\MQL5\Experts\MYEA_Expert.mq5"
```

## Compilation Process

### Build Script Features

- **Portable Support**: Uses `/portable` flag for MetaEditor
- **Error Handling**: Comprehensive error reporting
- **File Detection**: Automatically finds .mq5 files
- **Output Parsing**: Extracts compilation results
- **VS Code Integration**: Works with Action Buttons

### Manual Compilation

```powershell
# Basic compilation
.\tools\Build-MQL5.ps1

# With specific files
.\tools\Build-MQL5.ps1 -SourceFiles @("Experts\MyEA.mq5", "Scripts\MyScript.mq5")

# Verbose output
.\tools\Build-MQL5.ps1 -Verbose
```

### Troubleshooting Compilation

1. **Path Issues**
   ```
   Error: File not found
   Solution: Check that symlinks are created correctly
   ```

2. **Permission Issues**
   ```
   Error: Access denied
   Solution: Run PowerShell as Administrator
   ```

3. **MetaEditor Issues**
   ```
   Error: MetaEditor not found
   Solution: Verify MT5 installation path
   ```

## Testing

### Running Tests

```powershell
# Run all tests
.\tests\Run-Tests.ps1 -TestType "all"

# Run specific test category
.\tests\Run-Tests.ps1 -TestType "compilation"

# Verbose output
.\tests\Run-Tests.ps1 -TestType "all" -Verbose
```

### Test Categories

1. **Setup Tests**: Verify environment configuration
2. **Compilation Tests**: Check build system functionality
3. **Functionality Tests**: Validate features and integration

## Common Issues

### PowerShell Execution Policy

```powershell
# Problem: Scripts cannot be executed
Get-ExecutionPolicy

# Solution: Change execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Symbolic Link Creation

```powershell
# Problem: Cannot create symbolic links
# Solution: Run as Administrator
Start-Process powershell -Verb RunAs
```

### MetaEditor Path Issues

```powershell
# Problem: MetaEditor not found
# Solution: Update path in Build-MQL5.ps1
$metaEditorPath = "C:\YourCustomPath\MetaEditor64.exe"
```

## Advanced Configuration

### Custom Build Profiles

Create multiple build configurations:

```powershell
# Development build
.\tools\Build-MQL5.ps1 -CompilerFlags @("/inc:Include", "/log:dev.log")

# Production build
.\tools\Build-MQL5.ps1 -CompilerFlags @("/inc:Include", "/log:prod.log", "/optimize")
```

### Integration with CI/CD

```yaml
# GitHub Actions example
- name: Build MQL5
  run: |
    powershell -ExecutionPolicy Bypass -File tools/Build-MQL5.ps1
  shell: cmd
```

### Multiple MT5 Installations

```powershell
# Build for different MT5 versions
.\tools\Build-MQL5.ps1 -MT5Path "C:\MetaTrader5-Broker1"
.\tools\Build-MQL5.ps1 -MT5Path "C:\MetaTrader5-Broker2"
```

## Support

### Getting Help

1. Check the troubleshooting section above
2. Review the example files in the `examples/` directory
3. Run the test suite to diagnose issues
4. Check the MT5 compilation logs

### Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

### Resources

- [MQL5 Documentation](https://docs.mql5.com/)
- [MetaTrader 5 Help](https://www.metatrader5.com/en/help)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [VS Code Documentation](https://code.visualstudio.com/docs)
