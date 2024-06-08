BeforeDiscovery {
    
}

BeforeAll {
    $modulePath = "$PSScriptRoot\..\modules\MyModule"
    Import-Module  $modulePath -Verbose -Force
}

Describe "Unit testing the module's internal Build function:" {
    It 'Outputs the correct message' {
        InModuleScope MyModule {
            $testVersion = 5.0
            Mock Write-Host { }

            Build $testVersion

            Should -Invoke Write-Host -ParameterFilter {
                $Object -eq "a build was run for version: $testVersion"
            }
        }
    }
}

Describe "BuildIfChanged" {
    Context "When there are Changes" {
        BeforeAll {
            Mock -ModuleName MyModule Get-Version { return 1.1 }
            Mock -ModuleName MyModule Get-NextVersion { return 1.2 }

            # Just for giggles, we'll also mock Write-Host here, to demonstrate that you can
            # mock calls to commands other than functions defined within the same module.
            Mock -ModuleName MyModule Write-Host {} -Verifiable -ParameterFilter {
                $Object -eq 'a build was run for version: 1.2'
            }

            $result = BuildIfChanged
        }

        It "Builds the next version and calls Write-Host" {
            Should -InvokeVerifiable
        }

        It "returns the next version number" {
            $result | Should -Be 1.2
        }
    }

    Context "When there are no Changes" {
        BeforeAll {
            Mock -ModuleName MyModule Get-Version { return 1.1 }
            Mock -ModuleName MyModule Get-NextVersion { return 1.1 }
            Mock -ModuleName MyModule Build { }

            $result = BuildIfChanged
        }

        It "Should not build the next version" {
            # -Scope Context is used below since BuildIfChanged is called in BeforeAll
            # It's not required when the mock is called inside It
            Should -Invoke Build -ModuleName MyModule -Times 0 -Scope Context -ParameterFilter {
                $version -eq 1.1
            }
        }
    }
}