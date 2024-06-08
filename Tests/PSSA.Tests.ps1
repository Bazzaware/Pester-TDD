BeforeDiscovery { # <- this will run during Discovery
    $TestLocation = $(Split-Path $PSCommandPath -Parent)
    $analysis = Invoke-ScriptAnalyzer -Path $TestLocation # -Recurse -ExcludeRule PSAvoidUsingWriteHost, PSAvoidUsingPlainTextForPassword, PSAvoidUsingConvertToSecureStringWithPlainText
    $warnings = $analysis.ForEach({ if ($_.Severity -match 'Warning') { $_ } })
    $infomation = $analysis.ForEach({ if ($_.Severity -match 'Information') { $_ } })
    $errors = $analysis.ForEach({ if ($_.Severity -match 'Error') { $_ } })
    $ParseErrors = $analysis.ForEach({ if ($_.Severity -match 'ParseError') { $_ } })
    $scriptAnalyzerRules = Get-ScriptAnalyzerRule
}

BeforeAll {
    Get-Module PesterDemoFunctions | Remove-Module
    Import-Module $(Join-Path $(Split-Path $(Split-Path $PSCommandPath -Parent) -Parent)  "Modules/PesterDemoFunctions")
}
    
Context 'PSSA Standard Rules' {
    Describe 'Testing against PSSA rules' {
        It 'TestLocation Should be location' -TestCases @{result = $TestLocation } {
            $expected = $(Split-Path $PSCommandPath -Parent)
            $result | Should -Be $expected                   
        }
        It 'Analysys  count should greater than 0'-TestCases @{result = $analysis } {
            $result.Count | Should -BeGreaterThan 0                       
        }
        It 'scriptAnalyzerRules count should be 70' -TestCases @{result = $scriptAnalyzerRules } {
            $result.Count | Should -BeExactly  70                        
        }
        It 'Something' -ForEach $analysis {

        }
    }
}
Context 'Examples from Pester Docs' {
    Describe "Get-Emoji" {
        It "Returns <expected> (<name>)" -ForEach @(
            @{ Name = "cactus"; Expected = '🌵' }
            @{ Name = "giraffe"; Expected = '🦒' }
            @{ Name = "apple"; Expected = '🍎' }
            @{ Name = "pencil"; Expected = '✏️' }
            @{ Name = "penguin"; Expected = '🐧' }
            @{ Name = "smiling face with smiling eyes"; Expected = '😊' } 
        ) {
            Get-Emoji -Name $name | Should -Be $expected
        }
    }
    Describe "Get-Emoji <name>" -ForEach @(
        @{ Name = "cactus"; Symbol = '🌵'; Kind = 'Plant' }
        @{ Name = "giraffe"; Symbol = '🦒'; Kind = 'Animal' }
    ) {
        It "Returns <symbol>" {
            Get-Emoji -Name $name | Should -Be $symbol
        }

        It "Has kind <kind>" {
            Get-Emoji -Name $name | Get-EmojiKind | Should -Be $kind
        }
    }
}