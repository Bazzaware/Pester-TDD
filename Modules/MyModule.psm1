[CmdletBinding()]
param()

. $PSScriptRoot\MyModule.ps1
Export-ModuleMember -Function @(
    'BuildIfChanged'
    'Get-Version'
    'Get-NextVersion'
)