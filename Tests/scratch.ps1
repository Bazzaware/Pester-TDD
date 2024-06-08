$TestLocation = $(Split-Path $PSCommandPath -Parent)
# $TestLocation = Get-Location
$analysis = Invoke-ScriptAnalyzer -Path $TestLocation # -Recurse -ExcludeRule PSAvoidUsingWriteHost, PSAvoidUsingPlainTextForPassword, PSAvoidUsingConvertToSecureStringWithPlainText
$analysis

$warnings = $analysis.ForEach({ if ($_.Severity -match 'Warning') { $_ } })
$infomation = $analysis.ForEach({ if ($_.Severity -match 'Information') { $_ } })
$errors = $analysis.ForEach({ if ($_.Severity -match 'Error') { $_ } })
$ParseErrors = $analysis.ForEach({ if ($_.Severity -match 'ParseError') { $_ } })

$analysis.ForEach(
    { RuleName = $_.RuleName ; Expected = $false }
)