$root = Split-Path -Parent $(split-path -Parent $MyInvocation.MyCommand.Path)
Import-Module  $(Join-Path $root "modules" MyModule) -Verbose -Force