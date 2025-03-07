Param(
    [Parameter(Mandatory = $false)]
    [string]$TestLocation = "D:\Data\Source\Misc\Bazzaware\Pester-TDD\Modules"
)

# Get all PSScript Analyzer Rules and save them in an array
$scriptAnalyzerRules = Get-ScriptAnalyzerRule
$Rules = @()
$scriptAnalyzerRules | Foreach-Object { $Rules += @{"RuleName" = $_.RuleName; "Severity" = $_.Severity } }

# Create an array of the types of rules
$Severities = @("Information", "Warning", "Error")

foreach ($Severity in $Severities) { 
    
    Describe "Testing PSSA $Severity Rules" -Tag $Severity {

        It "<RuleName>" -TestCases ($Rules | Where-Object Severity -eq $Severity) {
            
            param ($RuleName)

            #Test all scripts for the given rule and if there is a problem display this problem in a nice an reabable format in the debug message and let the test fail
            Invoke-ScriptAnalyzer -Path $TestLocation -IncludeRule $RuleName -Recurse |
            Foreach-Object { "Problem in $($_.ScriptName) at line $($_.Line) with message: $($_.Message)" } |
            Should -BeNullOrEmpty
        }
    }
}


# BeforeDiscovery { # <- this will run during Discovery
#     $TestLocation = $(Split-Path $PSCommandPath -Parent)
#     $analysis = Invoke-ScriptAnalyzer -Path $TestLocation -Recurse -IncludeRule PSAvoidTrailingWhitespace #-ExcludeRule PSAvoidUsingWriteHost, PSAvoidUsingPlainTextForPassword, PSAvoidUsingConvertToSecureStringWithPlainText
#     $scriptAnalyzerRules = Get-ScriptAnalyzerRule
#     $ScriptAnalyzerRuleNames = $(Get-ScriptAnalyzerRule).RuleName | Where-Object { $_ -match "PSAvoid" } 
#     $rules = @()
#     foreach ($rule in $scriptAnalyzerRules) {
#         $rules += @{
#             RuleName = $rule.RuleName;
#             Severity = $rule.Severity;
#         }
#     }
# }

# BeforeAll {
#     Get-Module PesterDemoFunctions | Remove-Module
#     $modulePath = "$PSScriptRoot\..\modules\PesterDemoFunctions"
#     Import-Module $modulePath -Force
# }
    
# Context 'PSSA Standard Rules' {
#     Describe 'Testing against PSSA rules' {
#         It 'TestLocation Should be location' -TestCases @{result = $TestLocation } {
#             $expected = $(Split-Path $PSCommandPath -Parent)
#             $result | Should -Be $expected                   
#         }
#         It 'scriptAnalyzerRules count should be 70' -TestCases @{result = $scriptAnalyzerRules } {
#             $result.Count | Should -BeExactly  70                        
#         }
#     }

#     Describe "Should pass <_>" -ForEach $ScriptAnalyzerRuleNames {
#         foreach ($item in $analysis) {
#             It "$($item.ScriptName) : $($item.Line) : $($item.Message) " {
#                 $item.RuleName | Should -Not -Be ${$.RuleName}
#             }
#         }
#     }
# }
