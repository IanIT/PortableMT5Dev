# 🚀 Portable MetaTrader 5 Development Environment

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![VS Code](https://img.shields.io/badge/VS%20Code-Latest-blue.svg)](https://code.visualstudio.com/)
[![MetaTrader 5](https://img.shields.io/badge/MetaTrader%205-Portable-green.svg)](https://www.metatrader5.com/)

A comprehensive template and toolkit for setting up a professional, portable MetaTrader 5 development environment with VS Code integration, automated compilation, and symbolic link management.

## 🎯 What This Repository Provides

This repository contains battle-tested scripts, configurations, and documentation for creating a **complete portable development environment** that can be used for MetaTrader 5 projects and adapted for other portable application scenarios.

### ✨ Key Features

- **🔧 Portable MetaTrader 5 Setup**: Complete configuration for portable MT5 installation
- **🔗 File-Level Symbolic Links**: Smart symbolic link management (not folder-level)
- **🖥️ VS Code Integration**: Full IDE integration with one-click compilation
- **⚡ Automated Compilation**: Breakthrough solution using undocumented `/portable` flag
- **📚 Comprehensive Documentation**: Step-by-step guides and technical documentation
- **🛠️ PowerShell Automation**: Complete toolkit for project management
- **🧪 Testing Framework**: Validation scripts and testing tools

## 🚀 Quick Start

### Prerequisites

- Windows 10/11 or Windows Server
- PowerShell 5.1 or later
- Visual Studio Code
- MetaTrader 5 (portable installation)
- Administrator privileges (for symbolic link creation)

### 1. Clone and Setup

```bash
git clone https://github.com/IanLGit/PortableMT5Dev.git
cd portable-mt5-dev-environment
```

### 2. Run Initial Setup

```powershell
# Run as Administrator
.\setup\Initialize-Environment.ps1
```

### 3. Configure Your Project

```powershell
# Customize for your project
.\setup\Configure-Project.ps1 -ProjectName "YourProject" -MT5Path "C:\MetaTrader 5"
```

### 4. Create Symbolic Links

```powershell
# Create file-level symbolic links
.\tools\CreateFileSymlinks.ps1
```

### 5. Open in VS Code

```powershell
# Open configured environment
code .
```

## 📁 Repository Structure

```
portable-mt5-dev-environment/
├── 📁 setup/              # Initial setup scripts
├── 📁 tools/              # PowerShell automation tools
├── 📁 templates/          # Project templates
├── 📁 vscode/             # VS Code configuration
├── 📁 documentation/      # Comprehensive guides
├── 📁 examples/           # Usage examples
├── 📁 tests/              # Validation tests
└── 📁 .github/            # GitHub configuration
```

## 🔧 Core Components

### 1. Portable MetaTrader 5 Configuration
- Complete portable installation setup
- Configuration file management
- Path resolution solutions

### 2. Symbolic Link Management
- **File-level symbolic links** (not folder-level)
- Conflict prevention with naming conventions
- Automatic link creation and validation

### 3. VS Code Integration
- Task configuration for compilation
- Status bar buttons for one-click actions
- Problem matchers for error detection
- Extension recommendations

### 4. Automated Compilation
- **Breakthrough discovery**: Undocumented `/portable` flag
- Reliable PowerShell compilation scripts
- Error handling and logging
- Output validation

## 🌟 Why This Approach?

### File-Level vs Folder-Level Symbolic Links

**❌ Folder-Level Symlinks (Common Approach)**
- Risk of entire folder conflicts
- Difficult to manage multiple projects
- Complex path resolution issues

**✅ File-Level Symlinks (Our Approach)**
- Precise control over individual files
- Unique naming prevents conflicts
- Clean, maintainable structure
- Easy to debug and troubleshoot

### Portable Installation Benefits

- **Complete isolation** from system installations
- **Version control** over MT5 environment
- **Team collaboration** with consistent setups
- **No registry dependencies**
- **Easy backup and migration**

## 📚 Documentation

### Quick References
- [🚀 Quick Start Guide](documentation/guides/QUICK_START.md)
- [⚡ Compilation Setup](documentation/guides/COMPILATION_SETUP.md)
- [🔗 Symbolic Links Guide](documentation/guides/SYMBOLIC_LINKS.md)
- [🖥️ VS Code Integration](documentation/guides/VSCODE_INTEGRATION.md)

### Technical Documentation
- [🔧 Portable MetaEditor CLI](documentation/technical/PORTABLE_METAEDITOR.md)
- [🛠️ PowerShell Scripts](documentation/technical/POWERSHELL_SCRIPTS.md)
- [🧪 Testing Framework](documentation/technical/TESTING.md)
- [❓ Troubleshooting](documentation/technical/TROUBLESHOOTING.md)

### Best Practices
- [📋 Project Organization](documentation/best-practices/PROJECT_ORGANIZATION.md)
- [🔄 Workflow Guidelines](documentation/best-practices/WORKFLOW.md)
- [🛡️ Security Considerations](documentation/best-practices/SECURITY.md)

## 🛠️ Available Tools

### Setup Tools
- `Initialize-Environment.ps1` - Complete environment setup
- `Configure-Project.ps1` - Project-specific configuration
- `Validate-Setup.ps1` - Environment validation

### Symbolic Link Management
- `CreateFileSymlinks.ps1` - Create file-level symbolic links
- `ValidateSymlinks.ps1` - Verify symbolic link integrity
- `RemoveSymlinks.ps1` - Clean removal of symbolic links

### Compilation Tools
- `Compile-MQL5.ps1` - Advanced compilation script
- `Build-Project.ps1` - Simple build script
- `Test-Compilation.ps1` - Compilation validation

### VS Code Integration
- `Setup-VSCode.ps1` - VS Code configuration
- `Install-Extensions.ps1` - Extension management
- `Configure-Tasks.ps1` - Task setup

## 🧪 Testing

Run the complete test suite to validate your setup:

```powershell
# Run all tests
.\tests\Run-AllTests.ps1

# Run specific test categories
.\tests\Run-Tests.ps1 -Category "SymbolicLinks"
.\tests\Run-Tests.ps1 -Category "Compilation"
.\tests\Run-Tests.ps1 -Category "VSCodeIntegration"
```

## 🎯 Use Cases

### MetaTrader 5 Development
- MQL5 Expert Advisors
- Custom Indicators
- Trading Scripts
- Libraries and Frameworks

### Other Portable Applications
- Portable development environments
- Isolated testing environments
- Team collaboration setups
- Version-controlled configurations

## 🤝 Contributing

We welcome contributions! This project benefits from community input and improvements.

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Areas for Contribution

- **Other Application Support**: Extend beyond MetaTrader 5
- **Platform Support**: Linux/macOS adaptations
- **IDE Integration**: Support for other IDEs
- **Language Support**: Additional programming languages
- **Documentation**: Translations and improvements
- **Testing**: Additional test cases and validation

### Contribution Guidelines

- Follow existing code style and conventions
- Add tests for new functionality
- Update documentation for changes
- Ensure all tests pass before submitting

## 📋 Roadmap

### Phase 1: Core Functionality ✅
- [x] Portable MetaTrader 5 setup
- [x] File-level symbolic links
- [x] VS Code integration
- [x] Automated compilation
- [x] Comprehensive documentation

### Phase 2: Extended Support 🔄
- [ ] Support for other portable applications
- [ ] Linux/macOS compatibility
- [ ] Additional IDE integrations
- [ ] Enhanced testing framework

### Phase 3: Community Features 📋
- [ ] Plugin system for extensions
- [ ] Community template library
- [ ] Automated setup wizard
- [ ] Integration with CI/CD pipelines

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **MetaQuotes** for MetaTrader 5 platform
- **Microsoft** for Visual Studio Code
- **PowerShell Community** for automation tools
- **Contributors** who helped improve this project

## 📞 Support

- **Documentation**: Check the [documentation](documentation/) directory
- **Issues**: Report bugs and request features via [GitHub Issues](https://github.com/IanLGit/PortableMT5Dev/issues)
- **Discussions**: Join the conversation in [GitHub Discussions](https://github.com/IanLGit/PortableMT5Dev/discussions)

---

**⭐ If this project helps you, please give it a star! It helps others discover this solution.**

Made with ❤️ by the community for the community.
