BeforeDiscovery { # <- this will run during Discovery
    $TestLocation = $(Split-Path $PSCommandPath -Parent)
    $analysis = Invoke-ScriptAnalyzer -Path $TestLocation -Recurse -IncludeRule PSAvoidTrailingWhitespace #-ExcludeRule PSAvoidUsingWriteHost, PSAvoidUsingPlainTextForPassword, PSAvoidUsingConvertToSecureStringWithPlainText
    $scriptAnalyzerRules = Get-ScriptAnalyzerRule
    $ScriptAnalyzerRuleNames = $(Get-ScriptAnalyzerRule).RuleName | Where-Object { $_ -match "PSAvoidTrailingWhitespace" } 
    $rules = @()
    foreach ($rule in $scriptAnalyzerRules) {
        $rules += @{
            RuleName = $rule.RuleName;
            Severity = $rule.Severity;
        }
    }
}

BeforeAll {
    Get-Module PesterDemoFunctions | Remove-Module
    $modulePath = "$PSScriptRoot\..\modules\PesterDemoFunctions"
    Import-Module $modulePath -Force
}
    
Context 'PSSA Standard Rules' {
    Describe 'Testing against PSSA rules' {
        It 'TestLocation Should be location' -TestCases @{result = $TestLocation } {
            $expected = $(Split-Path $PSCommandPath -Parent)
            $result | Should -Be $expected                   
        }
        It 'scriptAnalyzerRules count should be 70' -TestCases @{result = $scriptAnalyzerRules } {
            $result.Count | Should -BeExactly  70                        
        }
    }

    Describe "Should pass <_>" -ForEach $ScriptAnalyzerRuleNames {
        foreach ($item in $analysis) {
            It "$($item.ScriptName) : $($item.Line) : $($item.Message) " {
                $item.RuleName | Should -Not -Be ${$}
            }
        }
    }
}
