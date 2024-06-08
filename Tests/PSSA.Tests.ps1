BeforeAll {
    $TestLocation = $(Split-Path $PSCommandPath -Parent)
    # $TestLocation = Get-Location
    $analysis = Invoke-ScriptAnalyzer -Path $TestLocation -Recurse -ExcludeRule PSAvoidUsingWriteHost, PSAvoidUsingPlainTextForPassword, PSAvoidUsingConvertToSecureStringWithPlainText
    $scriptAnalyzerRules = Get-ScriptAnalyzerRule
    write-host 'script root location is:' $TestLocation
    Get-Module PesterDemoFunctions | Remove-Module
    Import-Module $(Join-Path $(Split-Path $TestLocation -Parent)  "Modules/PesterDemoFunctions")
}
Context 'PSSA Standard Rules' {
    Describe 'Testing against PSSA rules' {
        It 'TestLocation Should Not be null or empty' {
            $TestLocation | Should -Not -BeNullOrEmpty                        
        }
        It 'Analysys should not be null or empty' {
            $analysis | Should -Not -BeNullOrEmpty                        
        }
        It 'scriptAnalyzerRules should not be null or empty' {
            $scriptAnalyzerRules | Should -Not -BeNullOrEmpty                        
        }
        forEach ($rule in $scriptAnalyzerRules){
            
        }
    }
    Describe "Get-Emoji" {
        It "Returns <expected> (<name>)" -ForEach @(
            @{ Name = "cactus"; Expected = '🌵' }
            @{ Name = "giraffe"; Expected = '🦒' }
        ) {
            Get-Emoji -Name $name | Should -Be $expected
        }
    }
}