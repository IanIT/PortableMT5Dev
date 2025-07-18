@{
    # Use Severity levels to limit the generated diagnostic records
    Severity = @('Error', 'Warning', 'Information')

    # Analyze **only** the following rules. Use IncludeRules when you want
    # to run only a subset of the default rules.
    IncludeRules = @(
        'PSAvoidDefaultValueSwitchParameter',
        'PSAvoidGlobalVars',
        'PSAvoidUsingCmdletAliases',
        'PSAvoidUsingComputerNameHardcoded',
        'PSAvoidUsingConvertToSecureStringWithPlainText',
        'PSAvoidUsingEmptyCatchBlock',
        'PSAvoidUsingInvokeExpression',
        'PSAvoidUsingPlainTextForPassword',
        'PSAvoidUsingPositionalParameters',
        'PSAvoidUsingUsernameAndPasswordParams',
        'PSAvoidUsingWMICmdlet',
        'PSAvoidUsingWriteHost',
        'PSDSCReturnCorrectTypesForDSCFunctions',
        'PSDSCStandardDSCFunctionsInResource',
        'PSDSCUseIdenticalMandatoryParametersForDSC',
        'PSDSCUseIdenticalParametersForDSC',
        'PSMissingModuleManifestField',
        'PSPlaceCloseBrace',
        'PSPlaceOpenBrace',
        'PSProvideCommentHelp',
        'PSReservedCmdletChar',
        'PSReservedParams',
        'PSReviewUnusedParameter',
        'PSShouldProcess',
        'PSUseApprovedVerbs',
        'PSUseBOMForUnicodeEncodedFile',
        'PSUseCmdletCorrectly',
        'PSUseCompatibleCmdlets',
        'PSUseCompatibleCommands',
        'PSUseCompatibleSyntax',
        'PSUseCompatibleTypes',
        'PSUseConsistentIndentation',
        'PSUseConsistentWhitespace',
        'PSUseCorrectCasing',
        'PSUseDeclaredVarsMoreThanAssignments',
        'PSUseLiteralInitializerForHashtable',
        'PSUseOutputTypeCorrectly',
        'PSUseProcessBlockForPipelineCommand',
        'PSUsePSCredentialType',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSUseSingularNouns',
        'PSUseToExportFieldsInManifest',
        'PSUseUTF8EncodingForHelpFile',
        'PSUseVerboseMessageInDSCResource'
    )

    # Do not analyze the following rules. Use ExcludeRules when you have
    # commented out the IncludeRules settings above and want to include all
    # the default rules except for those you exclude below.
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'  # We use Write-Host for colored output
    )

    # You can use rule configuration to configure rules that support it:
    Rules = @{
        PSUseConsistentIndentation = @{
            Enable = $true
            Kind = 'space'
            IndentationSize = 4
        }

        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckInnerBrace = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator = $true
            CheckPipe = $true
            CheckSeparator = $true
        }

        PSUseCorrectCasing = @{
            Enable = $true
        }

        PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true
            NewLineAfter = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace = @{
            Enable = $true
            NoEmptyLineBefore = $false
            IgnoreOneLineBlock = $true
            NewLineAfter = $true
        }

        PSProvideCommentHelp = @{
            Enable = $true
            ExportedOnly = $false
            BlockComment = $true
            VSCodeSnippetCorrection = $true
            Placement = 'before'
        }

        PSReviewUnusedParameter = @{
            CommandsToTraverse = @(
                'Invoke-Expression'
                'Invoke-Command'
                'Invoke-RestMethod'
                'Invoke-WebRequest'
                'Start-Process'
                'Start-Job'
                'Start-ThreadJob'
                'ForEach-Object'
                'Where-Object'
                'Sort-Object'
                'Group-Object'
                'Measure-Object'
                'Select-Object'
                'Tee-Object'
                'Compare-Object'
            )
        }

        PSUseCompatibleCommands = @{
            Enable = $true
            TargetProfiles = @(
                'win-8_x64_10.0.14393.0_6.2.4_x64_4.0.30319.42000_framework',
                'win-8_x64_10.0.17763.0_6.2.4_x64_4.0.30319.42000_framework'
            )
        }

        PSUseCompatibleCmdlets = @{
            Enable = $true
            Compatibility = @(
                'desktop-5.1.14393.206-windows',
                'core-6.2.4-windows'
            )
        }

        PSUseCompatibleSyntax = @{
            Enable = $true
            TargetVersions = @(
                '5.1',
                '6.2'
            )
        }

        PSUseCompatibleTypes = @{
            Enable = $true
            TargetProfiles = @(
                'win-8_x64_10.0.14393.0_6.2.4_x64_4.0.30319.42000_framework',
                'win-8_x64_10.0.17763.0_6.2.4_x64_4.0.30319.42000_framework'
            )
        }
    }
}
