function Merge-TestResults {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)][string] $TestFile,
        [string] $TestName
    )
    
    $testPath = ".\..\tests\${TestFile}.Tests.ps1"
    if (-not (Test-Path $testPath)) {
        throw "Unable to find test file '$TestFile' on '$testPath'."
    }

    $configuration = New-PesterConfiguration 
    $configuration.Run.PassThru = $true
    $configuration.Run.Path = $testPath
    $configuration.Output.Verbosity = "Detailed"
    $configuration.Output.RenderMode = "PlainText"
    $configuration.TestResult.Enabled = $true
    $configuration.TestResult.OutputFormat = 'NUnitXml'
    if ($TestName) {
        # $configuration.Filter.FullName = $TestName
        $configuration.TestResult.OutputPath = "$($TestFile)Results.xml"
    }
    if ($TestFile -eq "*") {
        $configuration.TestResult.OutputPath = "TestResults.xml"
    }
    
    $results = Invoke-Pester -Configuration $configuration
    
    if (-not ($results -and ($results.FailedCount -eq 0) -and ($results.PassedCount -gt 0))) {
        Write-Warning "====================================================================="
        Write-Warning "No tests were run or some tests have failed."
        Write-Warning "====================================================================="
        $results
        Write-Warning "====================================================================="
    }
}
$TestName = "Get-Planet"
Merge-TestResults -TestFile $TestName -TestName $TestName
$TestName = "Examples"
Merge-TestResults -TestFile $TestName -TestName $TestName
