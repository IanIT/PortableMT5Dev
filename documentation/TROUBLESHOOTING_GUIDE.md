# Troubleshooting Guide

This guide helps resolve common issues encountered in the Portable MT5 Development Environment.

## Quick Diagnosis

Run the automated test suite to identify issues:

```powershell
.\tests\Run-Tests.ps1 -TestType "all" -Verbose
```

## Common Issues

### 1. Compilation Failures

#### MetaEditor Not Found

**Symptoms:**
```
Error: MetaEditor64.exe not found at specified path
```

**Solutions:**

1. **Check MT5 Installation Path**
   ```powershell
   # Verify MT5 directory exists
   Test-Path "C:\MetaTrader 5\MetaEditor64.exe"
   
   # Find MetaEditor if installed elsewhere
   Get-ChildItem -Path "C:\" -Recurse -Name "MetaEditor64.exe" -ErrorAction SilentlyContinue
   ```

2. **Update Build Script Path**
   ```powershell
   # Edit tools/Build-MQL5.ps1
   $metaEditorPath = "D:\YourCustomPath\MetaEditor64.exe"  # Update this line
   ```

3. **Reinstall MetaTrader 5**
   - Download from your broker
   - Install in portable mode
   - Verify installation completes successfully

#### Portable Flag Not Recognized

**Symptoms:**
```
Error: Unknown command line option '/portable'
```

**Solutions:**

1. **Update MetaTrader 5**
   - Older versions may not support `/portable` flag
   - Download latest version from broker
   - Verify version supports portable operation

2. **Alternative Compilation Method**
   ```powershell
   # Fallback compilation without portable flag
   & $metaEditorPath /compile:"$sourceFile" /log
   ```

3. **Check MetaEditor Version**
   ```cmd
   MetaEditor64.exe /help
   ```

#### Access Denied Errors

**Symptoms:**
```
Error: Access denied to source file
Error: Cannot create output file
```

**Solutions:**

1. **Run as Administrator**
   ```powershell
   # Start PowerShell as Administrator
   Start-Process powershell -Verb RunAs
   ```

2. **Check File Permissions**
   ```powershell
   # Verify file access
   Get-Acl "N:\Project\Experts\MyEA.mq5"
   
   # Fix permissions if needed
   $acl = Get-Acl "N:\Project\Experts\MyEA.mq5"
   $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME,"FullControl","Allow")
   $acl.SetAccessRule($accessRule)
   Set-Acl "N:\Project\Experts\MyEA.mq5" $acl
   ```

3. **Check Antivirus Software**
   - Exclude MT5 directory from real-time scanning
   - Exclude project directory from scanning
   - Temporarily disable antivirus for testing

### 2. Symbolic Link Issues

#### Cannot Create Symbolic Links

**Symptoms:**
```
Error: A required privilege is not held by the client
New-Item: Administrator privilege required
```

**Solutions:**

1. **Enable Developer Mode (Windows 10/11)**
   - Open Settings → Update & Security → For Developers
   - Enable "Developer Mode"
   - Restart if prompted

2. **Run as Administrator**
   ```powershell
   # Always run symlink creation as Administrator
   Start-Process powershell -Verb RunAs
   .\tools\Create-FileSymlinks.ps1
   ```

3. **Use Group Policy (Enterprise)**
   - Open gpedit.msc
   - Navigate to: Computer Configuration → Windows Settings → Security Settings → Local Policies → User Rights Assignment
   - Add user to "Create symbolic links" policy

#### Symlinks Point to Wrong Location

**Symptoms:**
```
Symlink exists but file not found in MT5
Target path incorrect
```

**Solutions:**

1. **Check Current Symlinks**
   ```powershell
   # List all symlinks in MT5 directory
   Get-ChildItem "C:\MetaTrader 5\MQL5" -Recurse | Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint} | Select-Object FullName, Target
   ```

2. **Recreate Symlinks**
   ```powershell
   # Remove existing symlinks
   Get-ChildItem "C:\MetaTrader 5\MQL5" -Recurse | Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint} | Remove-Item
   
   # Recreate with correct paths
   .\tools\Create-FileSymlinks.ps1 -ProjectRoot "N:\YourProject" -FilePrefix "YOURPREFIX_"
   ```

3. **Manual Symlink Creation**
   ```powershell
   # Create individual symlinks manually
   New-Item -ItemType SymbolicLink -Path "C:\MetaTrader 5\MQL5\Experts\PREFIX_EA.mq5" -Target "N:\Project\Experts\EA.mq5"
   ```

#### Broken Symlinks

**Symptoms:**
```
File appears in MT5 but cannot be opened
Symlink points to non-existent file
```

**Solutions:**

1. **Find Broken Symlinks**
   ```powershell
   # Check for broken symlinks
   Get-ChildItem "C:\MetaTrader 5\MQL5" -Recurse | Where-Object {
       $_.Attributes -band [IO.FileAttributes]::ReparsePoint -and !(Test-Path $_.Target)
   }
   ```

2. **Remove Broken Symlinks**
   ```powershell
   # Remove all broken symlinks
   Get-ChildItem "C:\MetaTrader 5\MQL5" -Recurse | Where-Object {
       $_.Attributes -band [IO.FileAttributes]::ReparsePoint -and !(Test-Path $_.Target)
   } | Remove-Item
   ```

3. **Verify Source Files**
   ```powershell
   # Check that source files exist
   Get-ChildItem "N:\Project" -Recurse -Filter "*.mq5"
   ```

### 3. PowerShell Script Issues

#### Execution Policy Restrictions

**Symptoms:**
```
ExecutionPolicy prevents script execution
Cannot be loaded because running scripts is disabled
```

**Solutions:**

1. **Check Current Policy**
   ```powershell
   Get-ExecutionPolicy -List
   ```

2. **Set Execution Policy**
   ```powershell
   # For current user only (recommended)
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   
   # For all users (requires admin)
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
   ```

3. **Bypass for Single Execution**
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File ".\tools\Build-MQL5.ps1"
   ```

4. **Unblock Downloaded Scripts**
   ```powershell
   # Unblock all PowerShell scripts
   Get-ChildItem -Path ".\tools" -Filter "*.ps1" | Unblock-File
   ```

#### Script Parameters Not Working

**Symptoms:**
```
Parameters not recognized
Script ignores parameter values
```

**Solutions:**

1. **Check Parameter Syntax**
   ```powershell
   # Correct syntax
   .\tools\Build-MQL5.ps1 -SourceFiles @("file1.mq5", "file2.mq5")
   
   # Incorrect syntax
   .\tools\Build-MQL5.ps1 -SourceFiles "file1.mq5, file2.mq5"
   ```

2. **Use Full Parameter Names**
   ```powershell
   # Use full parameter names to avoid ambiguity
   .\tools\Build-MQL5.ps1 -MT5Path "C:\MetaTrader 5" -Verbose:$true
   ```

3. **Check Script Help**
   ```powershell
   Get-Help .\tools\Build-MQL5.ps1 -Full
   ```

### 4. VS Code Integration Issues

#### Action Buttons Not Appearing

**Symptoms:**
```
Build button not visible in status bar
Action Buttons extension not working
```

**Solutions:**

1. **Install Action Buttons Extension**
   ```
   Press Ctrl+Shift+X
   Search for "Action Buttons"
   Install "Action Buttons" by seunlanlege
   ```

2. **Check settings.json Configuration**
   ```json
   // .vscode/settings.json
   {
     "actionButtons": {
       "defaultColor": "#007acc",
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

3. **Reload VS Code**
   ```
   Press Ctrl+Shift+P
   Type "Developer: Reload Window"
   Press Enter
   ```

4. **Check Extension Status**
   ```
   Press Ctrl+Shift+X
   Verify Action Buttons extension is enabled
   Check for any error messages
   ```

#### Build Tasks Not Working

**Symptoms:**
```
Build task not found
Task execution fails
```

**Solutions:**

1. **Verify tasks.json**
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

2. **Check File Paths**
   ```powershell
   # Verify build script exists
   Test-Path ".\tools\Build-MQL5.ps1"
   ```

3. **Test Task Manually**
   ```
   Press Ctrl+Shift+P
   Type "Tasks: Run Task"
   Select "Build MQL5"
   Check terminal output for errors
   ```

### 5. File and Path Issues

#### Network Drive Problems

**Symptoms:**
```
UNC paths not supported
Network drive access denied
Long path issues
```

**Solutions:**

1. **Use Mapped Drives**
   ```cmd
   # Map network drive to letter
   net use N: \\server\share
   ```

2. **Enable Long Path Support**
   ```powershell
   # Enable long paths in Windows 10/11
   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
   ```

3. **Use Local Drives**
   ```powershell
   # Copy project to local drive
   Copy-Item "\\server\project" "C:\LocalProject" -Recurse
   ```

#### File Encoding Issues

**Symptoms:**
```
Special characters not displaying correctly
Compilation fails with encoding errors
```

**Solutions:**

1. **Convert to UTF-8**
   ```powershell
   # Convert file encoding
   $content = Get-Content "file.mq5" -Encoding UTF8
   Set-Content "file.mq5" -Value $content -Encoding UTF8
   ```

2. **Set VS Code Encoding**
   ```json
   // settings.json
   {
     "files.encoding": "utf8",
     "files.autoGuessEncoding": true
   }
   ```

3. **Use UTF-8 BOM for MQL5**
   ```powershell
   # Save with BOM if required
   $utf8BOM = New-Object System.Text.UTF8Encoding $true
   [System.IO.File]::WriteAllText("file.mq5", $content, $utf8BOM)
   ```

### 6. Environment-Specific Issues

#### Windows Defender / Antivirus

**Symptoms:**
```
Files deleted after compilation
Scripts blocked by antivirus
Real-time protection interference
```

**Solutions:**

1. **Add Exclusions**
   - Exclude MT5 installation directory
   - Exclude project directory
   - Exclude PowerShell scripts

2. **Temporarily Disable**
   ```powershell
   # Disable Windows Defender real-time protection (temporarily)
   Set-MpPreference -DisableRealtimeMonitoring $true
   
   # Re-enable after testing
   Set-MpPreference -DisableRealtimeMonitoring $false
   ```

3. **Check Quarantine**
   - Review Windows Defender quarantine
   - Restore blocked files
   - Add to allow list

#### Multiple MT5 Installations

**Symptoms:**
```
Wrong MT5 version being used
Compilation targeting wrong installation
```

**Solutions:**

1. **Specify Exact Path**
   ```powershell
   .\tools\Build-MQL5.ps1 -MT5Path "C:\MetaTrader5-Broker1"
   ```

2. **Check Registry**
   ```powershell
   # Find all MT5 installations
   Get-ChildItem "HKLM:\SOFTWARE\MetaQuotes" -ErrorAction SilentlyContinue
   ```

3. **Create Separate Configs**
   ```powershell
   # Different build scripts for different brokers
   .\tools\Build-MQL5-Broker1.ps1
   .\tools\Build-MQL5-Broker2.ps1
   ```

## Diagnostic Tools

### Environment Diagnostics

```powershell
# Run comprehensive diagnostics
.\tests\Run-Tests.ps1 -TestType "all" -Verbose

# Check specific components
.\tests\Run-Tests.ps1 -TestType "setup"
.\tests\Run-Tests.ps1 -TestType "compilation"
```

### Manual Checks

```powershell
# Check PowerShell version
$PSVersionTable.PSVersion

# Check execution policy
Get-ExecutionPolicy -List

# Check MT5 installation
Test-Path "C:\MetaTrader 5\MetaEditor64.exe"

# Check project structure
Get-ChildItem "." -Recurse -Directory | Select-Object Name, FullName

# Check symlinks
Get-ChildItem "C:\MetaTrader 5\MQL5" -Recurse | Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint}
```

### Log Analysis

```powershell
# View recent compilation logs
Get-Content "$env:APPDATA\MetaQuotes\Terminal\*\MQL5\Logs\*.log" | Select-Object -Last 50

# View PowerShell execution logs
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational'; StartTime=(Get-Date).AddHours(-1)}
```

## Step-by-Step Troubleshooting

### When Nothing Works

1. **Start Fresh**
   ```powershell
   # Remove all symlinks
   Get-ChildItem "C:\MetaTrader 5\MQL5" -Recurse | Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint} | Remove-Item
   
   # Reset execution policy
   Set-ExecutionPolicy -ExecutionPolicy Default -Scope CurrentUser
   
   # Re-run setup
   .\setup\Setup-Environment.ps1 -ProjectName "Test" -CreateSymlinks -SetupVSCode
   ```

2. **Test Individual Components**
   ```powershell
   # Test MetaEditor directly
   & "C:\MetaTrader 5\MetaEditor64.exe" /portable /help
   
   # Test simple compilation
   & "C:\MetaTrader 5\MetaEditor64.exe" /portable /compile:"examples\ExampleEA.mq5"
   
   # Test PowerShell script
   powershell.exe -ExecutionPolicy Bypass -File "tools\Build-MQL5.ps1" -Verbose
   ```

3. **Verify Prerequisites**
   ```powershell
   # Check Windows version
   Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion
   
   # Check PowerShell version
   $PSVersionTable
   
   # Check .NET Framework
   Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where-Object { $_.PSChildName -eq "Full"} | Select-Object PSChildName, version
   ```

### Escalation Steps

1. **Enable Debug Mode**
   ```powershell
   # Run with maximum verbosity
   .\tools\Build-MQL5.ps1 -Verbose -Debug
   ```

2. **Capture Detailed Logs**
   ```powershell
   # Start transcript
   Start-Transcript -Path "troubleshoot.log"
   
   # Run commands
   .\tests\Run-Tests.ps1 -TestType "all" -Verbose
   
   # Stop transcript
   Stop-Transcript
   ```

3. **Create Minimal Reproduction**
   ```powershell
   # Create simple test case
   mkdir "C:\TempMT5Test"
   cd "C:\TempMT5Test"
   
   # Copy only essential files
   Copy-Item "N:\Project\tools\Build-MQL5.ps1" "."
   Copy-Item "N:\Project\examples\ExampleEA.mq5" "."
   
   # Test in isolation
   .\Build-MQL5.ps1 -SourceFiles @("ExampleEA.mq5")
   ```

## Getting Help

### Before Asking for Help

1. **Run Diagnostics**
   ```powershell
   .\tests\Run-Tests.ps1 -TestType "all" > diagnostic_output.txt
   ```

2. **Gather System Information**
   ```powershell
   # System info
   Get-ComputerInfo > system_info.txt
   
   # PowerShell info
   $PSVersionTable > powershell_info.txt
   
   # MT5 info
   Get-ChildItem "C:\MetaTrader 5" -Recurse -Name "*.exe" > mt5_files.txt
   ```

3. **Create Reproduction Steps**
   - Document exact steps taken
   - Include error messages
   - Note what was expected vs. actual behavior

### Information to Include

- Operating System version
- PowerShell version
- MetaTrader 5 version
- Project structure
- Error messages (full text)
- Steps to reproduce
- What you've already tried

### Resources

- [Official MQL5 Documentation](https://docs.mql5.com/)
- [MetaTrader 5 Help](https://www.metatrader5.com/en/help)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [Windows Symbolic Links Guide](https://docs.microsoft.com/en-us/windows/win32/fileio/symbolic-links)

### Community Support

- MQL5 Community Forums
- Stack Overflow (tag: mql5)
- GitHub Issues (for this template)
- MetaTrader Communities
