# Contributing to Portable MT5 Development Environment

Thank you for your interest in contributing to the Portable MT5 Development Environment! This guide will help you get started with contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contribution Guidelines](#contribution-guidelines)
- [Types of Contributions](#types-of-contributions)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)
- [Community](#community)

## Code of Conduct

By participating in this project, you agree to abide by our code of conduct:

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment include:

- Being respectful and inclusive
- Being collaborative and helpful
- Focusing on what is best for the community
- Showing empathy towards other community members

Examples of unacceptable behavior include:

- Harassment, trolling, or discriminatory language
- Personal or political attacks
- Public or private harassment
- Publishing others' private information without permission

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- Windows 10/11
- PowerShell 5.1 or later
- Git for version control
- MetaTrader 5 for testing
- VS Code (recommended)
- Basic knowledge of MQL5 and PowerShell

### Fork and Clone

1. **Fork the Repository**
   - Visit the GitHub repository
   - Click "Fork" in the top-right corner
   - Clone your fork locally:

   ```bash
   git clone https://github.com/yourusername/portable-mt5-dev.git
   cd portable-mt5-dev
   ```

2. **Set Up Remote**
   ```bash
   git remote add upstream https://github.com/original-owner/portable-mt5-dev.git
   ```

## Development Setup

### Initial Setup

1. **Install Dependencies**
   ```powershell
   # Set execution policy
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

   # Run setup in test mode
   .\setup\Setup-Environment.ps1 -DryRun
   ```

2. **Configure Development Environment**
   ```powershell
   # Create development branch
   git checkout -b feature/your-feature-name

   # Run tests to verify setup
   .\tests\Run-Tests.ps1 -TestType "all"
   ```

3. **VS Code Setup**
   - Install recommended extensions
   - Configure workspace settings
   - Test build tasks

### Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/feature-name
   # or
   git checkout -b bugfix/bug-description
   # or
   git checkout -b docs/documentation-update
   ```

2. **Make Changes**
   - Follow coding standards
   - Add tests for new functionality
   - Update documentation

3. **Test Changes**
   ```powershell
   # Run all tests
   .\tests\Run-Tests.ps1 -TestType "all"

   # Test specific functionality
   .\tests\Run-Tests.ps1 -TestType "compilation" -Verbose
   ```

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add new compilation feature"
   ```

## Contribution Guidelines

### Coding Standards

#### PowerShell Scripts

1. **Follow PowerShell Best Practices**
   ```powershell
   #requires -version 5.1

   <#
   .SYNOPSIS
       Brief description of script functionality

   .DESCRIPTION
       Detailed description

   .PARAMETER ParameterName
       Description of parameter

   .EXAMPLE
       .\Script.ps1 -Parameter "value"
   #>

   param(
       [Parameter(Mandatory=$true)]
       [string]$RequiredParameter,

       [Parameter(Mandatory=$false)]
       [switch]$OptionalSwitch = $false
   )

   $ErrorActionPreference = 'Stop'
   ```

2. **Naming Conventions**
   - Use PascalCase for functions: `Get-ProjectInfo`
   - Use camelCase for variables: `$projectRoot`
   - Use UPPERCASE for constants: `$GLOBAL_CONSTANT`
   - Use descriptive names: `$metaEditorPath` not `$path`

3. **Error Handling**
   ```powershell
   try {
       # Risky operation
       Invoke-SomeCommand
   } catch {
       Write-Error "Operation failed: $($_.Exception.Message)"
       throw
   }
   ```

#### MQL5 Code

1. **Follow MQL5 Standards**
   ```mql5
   //+------------------------------------------------------------------+
   //| Script/EA/Indicator Name                                         |
   //+------------------------------------------------------------------+
   #property copyright "Your Name"
   #property link      "https://github.com/IanLGit/PortableMT5Dev"
   #property version   "1.00"
   #property strict

   // Use clear naming conventions
   class CMyClass
   {
   private:
       int m_privateVariable;
   public:
       void PublicMethod();
   };
   ```

2. **Documentation**
   ```mql5
   //+------------------------------------------------------------------+
   //| Calculate lot size based on risk percentage                      |
   //| Parameters:                                                      |
   //|   riskPercent - Risk percentage (1.0 = 1%)                      |
   //|   stopLossPoints - Stop loss in points                          |
   //| Returns:                                                         |
   //|   Calculated lot size                                            |
   //+------------------------------------------------------------------+
   double CalculateLotSize(double riskPercent, double stopLossPoints)
   {
       // Implementation
   }
   ```

### Documentation Standards

1. **README Files**
   - Clear project description
   - Installation instructions
   - Usage examples
   - Contribution guidelines

2. **Code Comments**
   - Explain why, not what
   - Use clear, concise language
   - Update comments when code changes

3. **Markdown Formatting**
   - Use consistent heading styles
   - Include code examples
   - Add table of contents for long documents

### Testing Requirements

1. **All Changes Must Include Tests**
   ```powershell
   # Add tests to tests/ directory
   function Test-NewFeature {
       # Test implementation
       $result = Invoke-NewFeature -Parameter "test"

       if ($result -eq "expected") {
           Write-Host "✅ Test passed"
           return $true
       } else {
           Write-Host "❌ Test failed"
           return $false
       }
   }
   ```

2. **Test Categories**
   - Unit tests for individual functions
   - Integration tests for component interaction
   - End-to-end tests for complete workflows

3. **Test Coverage**
   - Aim for high test coverage
   - Test both success and failure cases
   - Include edge cases and boundary conditions

## Types of Contributions

### Bug Fixes

1. **Report the Bug**
   - Check existing issues first
   - Provide detailed reproduction steps
   - Include system information
   - Add relevant logs/screenshots

2. **Fix the Bug**
   - Create a bugfix branch
   - Write a test that reproduces the bug
   - Implement the fix
   - Verify the test passes

### New Features

1. **Propose the Feature**
   - Open an issue for discussion
   - Explain the use case and benefits
   - Get feedback from maintainers

2. **Implement the Feature**
   - Follow the development workflow
   - Add comprehensive tests
   - Update documentation
   - Ensure backward compatibility

### Documentation Improvements

1. **Types of Documentation**
   - API documentation
   - User guides and tutorials
   - Code comments
   - README files

2. **Documentation Guidelines**
   - Write for your audience
   - Use clear, simple language
   - Include practical examples
   - Keep it up to date

### Performance Improvements

1. **Measure Performance**
   - Benchmark existing code
   - Identify bottlenecks
   - Test improvements

2. **Optimization Guidelines**
   - Profile before optimizing
   - Maintain readability
   - Add performance tests
   - Document performance characteristics

## Pull Request Process

### Before Submitting

1. **Update Your Branch**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run Full Test Suite**
   ```powershell
   .\tests\Run-Tests.ps1 -TestType "all"
   ```

3. **Update Documentation**
   - Update relevant documentation
   - Add changelog entries
   - Update version numbers if needed

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Added tests for new functionality
- [ ] All tests pass locally
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
```

### Review Process

1. **Automated Checks**
   - All tests must pass
   - Code style checks
   - Documentation builds

2. **Peer Review**
   - At least one approval required
   - Address review feedback
   - Maintain professional discussion

3. **Maintainer Review**
   - Final approval from project maintainers
   - Merge when all requirements met

## Testing

### Running Tests Locally

```powershell
# Run all tests
.\tests\Run-Tests.ps1 -TestType "all"

# Run specific test categories
.\tests\Run-Tests.ps1 -TestType "setup"
.\tests\Run-Tests.ps1 -TestType "compilation"
.\tests\Run-Tests.ps1 -TestType "functionality"

# Run with verbose output
.\tests\Run-Tests.ps1 -TestType "all" -Verbose
```

### Writing Tests

1. **Test Structure**
   ```powershell
   function Test-MyFunction {
       param([string]$TestName)

       # Arrange
       $input = "test data"
       $expected = "expected result"

       # Act
       $actual = Invoke-MyFunction -Input $input

       # Assert
       if ($actual -eq $expected) {
           Write-TestResult $TestName "PASS"
           return $true
       } else {
           Write-TestResult $TestName "FAIL" "Expected: $expected, Actual: $actual"
           return $false
       }
   }
   ```

2. **Test Guidelines**
   - Test one thing at a time
   - Use descriptive test names
   - Include positive and negative cases
   - Test edge cases and boundaries

### Continuous Integration

Tests run automatically on:
- Every pull request
- Every commit to main branch
- Nightly builds

## Documentation

### Writing Good Documentation

1. **Know Your Audience**
   - Beginners vs. experts
   - Developers vs. end users
   - Different skill levels

2. **Structure Your Content**
   - Start with overview
   - Provide step-by-step instructions
   - Include examples
   - Add troubleshooting section

3. **Keep It Current**
   - Update when code changes
   - Review periodically
   - Remove outdated information

### Documentation Types

1. **User Documentation**
   - Installation guides
   - User manuals
   - Tutorials
   - FAQ

2. **Developer Documentation**
   - API reference
   - Architecture overview
   - Contributing guidelines
   - Code examples

## Community

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and community discussion
- **Pull Requests**: Code reviews and collaboration

### Getting Help

1. **Before Asking**
   - Search existing issues
   - Read the documentation
   - Try the troubleshooting guide

2. **When Asking**
   - Provide context and details
   - Include reproduction steps
   - Share relevant code/logs
   - Be patient and respectful

### Recognition

Contributors are recognized through:
- Contributors list in README
- GitHub contributor statistics
- Special thanks in release notes
- Community recognition

## Release Process

### Version Numbering

We follow [Semantic Versioning](https://semver.org/):
- MAJOR.MINOR.PATCH
- Major: Breaking changes
- Minor: New features (backward compatible)
- Patch: Bug fixes (backward compatible)

### Release Checklist

1. **Pre-release**
   - All tests pass
   - Documentation updated
   - Changelog updated
   - Version numbers bumped

2. **Release**
   - Tag the release
   - Create GitHub release
   - Update package managers
   - Announce to community

3. **Post-release**
   - Monitor for issues
   - Address urgent bugs
   - Plan next release

## Questions?

If you have any questions about contributing, please:

1. Check the FAQ section
2. Search existing issues
3. Open a new issue with the "question" label
4. Join our community discussions

Thank you for contributing to the Portable MT5 Development Environment!
