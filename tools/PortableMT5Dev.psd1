@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'PortableMT5Dev.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = 'f1234567-89ab-cdef-0123-456789abcdef'

    # Author of this module
    Author = 'Portable MT5 Development Environment'

    # Company or vendor of this module
    CompanyName = 'Community'

    # Copyright statement for this module
    Copyright = '(c) 2024 Portable MT5 Development Environment. MIT License.'

    # Description of the functionality provided by this module
    Description = 'PowerShell module for managing portable MetaTrader 5 development environments, including compilation, symbolic link management, and environment validation.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = '4.7.2'

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion = '4.0'

    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture = 'None'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @()

    # Functions to export from this module
    FunctionsToExport = @(
        'Get-MT5Installation',
        'Test-MT5Environment',
        'Invoke-MQL5Compilation',
        'New-FileSymlink',
        'Test-DevelopmentEnvironment',
        'Get-ProjectConfiguration',
        'Set-ProjectConfiguration',
        'Write-PortableLog'
    )

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = @()

    # List of all modules packaged with this module
    ModuleList = @()

    # List of all files packaged with this module
    FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module
            Tags = @('MetaTrader', 'MT5', 'MQL5', 'Trading', 'Portable', 'Development', 'Finance', 'Automation')

            # A URL to the license for this module.
            LicenseUri = 'https://opensource.org/licenses/MIT'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/IanLGit/PortableMT5Dev'

            # A URL to an icon representing this module.
            IconUri = ''

            # Release notes for this module
            ReleaseNotes = 'Initial release of the Portable MT5 Development Environment PowerShell module.'
        }
    }

    # HelpInfo URI of this module
    HelpInfoURI = ''

    # Default prefix for commands exported from this module
    DefaultCommandPrefix = ''
}
