# Copilot Instructions for Portable MetaTrader 5 Development Environment

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Context

This is a **configuration and tooling repository** for portable MetaTrader 5 development environments. The focus is on:

- **PowerShell automation scripts** for environment setup and management
- **Symbolic link management** (file-level, not folder-level)
- **VS Code integration** with tasks and extensions
- **Portable application configuration** and deployment
- **Documentation and templates** for community use

## Key Technical Concepts

### Symbolic Links
- Always use **file-level symbolic links**, not folder-level
- Implement conflict prevention with naming conventions (e.g., SPSEA_ prefix)
- Include validation and cleanup scripts
- Document the rationale for file-level approach

### PowerShell Scripting
- Target PowerShell 5.1+ for compatibility
- Use proper error handling with try-catch blocks
- Implement parameter validation and help documentation
- Include progress indicators for long-running operations
- Use cmdlet-approved verbs (Get-, Set-, New-, Remove-, etc.)

### MetaTrader 5 Integration
- Focus on **portable installations** (not AppData-based)
- Use the undocumented `/portable` flag for MetaEditor CLI
- Implement path resolution that works with portable setups
- Include validation for MT5 installation detection

### VS Code Integration
- Provide complete task configurations with problem matchers
- Include extension recommendations and automated installation
- Configure status bar buttons for common operations
- Implement proper workspace settings for MQL5 development

## Code Style Guidelines

### PowerShell
- Use PascalCase for function names
- Include comment-based help for all functions
- Implement proper parameter validation
- Use Write-Host with colors for user feedback
- Include verbose logging options

### Documentation
- Use clear, actionable headings
- Include code examples for all procedures
- Provide troubleshooting sections
- Use emoji icons for visual clarity (🔧, ✅, ❌, etc.)
- Include quick reference sections

### File Organization
- Group related functionality in logical directories
- Use descriptive file names with consistent conventions
- Include templates for common use cases
- Provide both simple and advanced examples

## Project Goals

1. **Accessibility**: Make portable MT5 development accessible to all skill levels
2. **Reliability**: Provide battle-tested, production-ready solutions
3. **Extensibility**: Enable community contributions and adaptations
4. **Documentation**: Maintain comprehensive, up-to-date documentation
5. **Portability**: Ensure solutions work across different environments

## When Contributing Code

- **Always test thoroughly** before suggesting changes
- **Include error handling** for edge cases
- **Document breaking changes** clearly
- **Provide examples** for new functionality
- **Consider backward compatibility** when possible
- **Follow existing patterns** and conventions

## Avoid

- Hardcoded paths (use parameters and detection)
- Folder-level symbolic links
- Registry dependencies
- Non-portable solutions
- Undocumented breaking changes
- Platform-specific code without alternatives
