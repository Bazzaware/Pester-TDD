$TestLocation = $(Split-Path $PSCommandPath -Parent)
# $TestLocation = Get-Location
$analysis = Invoke-ScriptAnalyzer -Path . -Recurse # -ExcludeRule PSAvoidUsingWriteHost, PSAvoidUsingPlainTextForPassword, PSAvoidUsingConvertToSecureStringWithPlainText
$scriptAnalyzerRules = Get-ScriptAnalyzerRule

$warnings = $analysis.ForEach({ if ($_.Severity -match 'Warning') { $_ } })
$infomation = $analysis.ForEach({ if ($_.Severity -match 'Information') { $_ } })
$errors = $analysis.ForEach({ if ($_.Severity -match 'Error') { $_ } })
$ParseErrors = $analysis.ForEach({ if ($_.Severity -match 'ParseError') { $_ } })

$ScriptAnalyzerRuleNames = $(Get-ScriptAnalyzerRule).RuleName
$analysis | ft RuleName, Severity, ScriptName, Line, Message -AutoSize
$files = Get-ChildItem "../*.ps1" -Recurse

$results = $analysis.ForEach(
    { @(
            @{
                RuleName   = $_.RuleName ;
                ScriptName = $_.ScriptName;
                Line       = $_.Line ;
                Severity   = $_.Severity
                Message    = $_.Message;
            }
        )
    }
)
$results
$rules = @()
foreach ($rule in $scriptAnalyzerRules) {
    $rules += @{
        RuleName = $_.RuleName;
    }
}

Describe -Tags 'PSSA' -Name 'Testing against PSScriptAnalyzer rules' {
    Context 'PSSA Standard Rules' {
        $ScriptAnalyzerSettings = Get-Content -Path "$PSScriptRoot\..\ScriptAnalyzerSettings.psd1" | Out-String | Invoke-Expression
        $AnalyzerIssues = Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\MyScript.ps1" -Settings "$PSScriptRoot\..\ScriptAnalyzerSettings.psd1"
        $ScriptAnalyzerRuleNames = Get-ScriptAnalyzerRule | Select-Object -ExpandProperty RuleName
        forEach ($Rule in $ScriptAnalyzerRuleNames) {
            $Skip = @{Skip = $False }
            if ($ScriptAnalyzerSettings.ExcludeRules -notcontains $Rule) {
                # We still want it in the tests, but since it doesn't actually get tested we will skip
                $Skip = @{Skip = $True }
            }

            It "Should pass $Rule" @Skip {
                $Failures = $AnalyzerIssues | Where-Object -Property RuleName -EQ -Value $rule
                ($Failures | Measure-Object).Count | Should Be 0
            }
        }
    }
}