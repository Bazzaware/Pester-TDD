BeforeAll {
    function Add-Footer($path, $footer) {
        Add-Content $path -Value $footer
    }
}

Describe "Add-Footer" {
    BeforeAll {
        $testPath = "TestDrive:\test.txt"
        Set-Content $testPath -value "my test text."
        Add-Footer $testPath "-Footer"
        $result = Get-Content $testPath
        return $result
    }

    It "adds a footer" {
        (-join $result) | Should -Be "my test text.-Footer"
    }
}