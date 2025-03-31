function BuildIfChanged {
    $thisVersion = Get-Version
    $nextVersion = Get-NextVersion
    if ($thisVersion -ne $nextVersion) { Build $nextVersion }
    return $nextVersion
}

function Build ($version) {
    Write-Information "a build was run for version: $version" -InformationAction Continue
}

# Actual definitions of Get-Version and Get-NextVersion are not shown here,
# since we'll just be mocking them anyway. However, the commands do need to
# exist in order to be mocked, so we'll stick dummy functions here

function Get-Version { return 0 }
function Get-NextVersion { return 0 }