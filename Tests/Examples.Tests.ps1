BeforeAll {
    Get-Module PesterDemoFunctions | Remove-Module
    $modulePath = "$PSScriptRoot\..\modules\PesterDemoFunctions"
    Import-Module $modulePath -Force
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

    Describe "Get-FruitBasket" {
        It "Contains <_>" -ForEach '🍎', '🍌', '🥝', '🥑', '🍇', '🍐' {
            Get-FruitBasket | Should -Contain $_
        }
    }

    Describe "Get-FruitBasket" {
        Context "Fruit <_>" -ForEach '🍎', '🍌', '🥝', '🥑', '🍇', '🍐' {
            It "Contains <_> by default" {
                Get-FruitBasket | Should -Contain $_
            }

            It "Can remove <_> from the basket" {
                Remove-FruitBasket -Item $_
                Get-FruitBasket | Should -Not -Contain $_
            }
        }
        AfterAll {
            Reset-FruitBasket
        }
    }

    Describe "Get-Emoji <name>" -ForEach @(
        @{
            Name   = "cactus";
            Symbol = '🌵';
            Kind   = 'Plant'
            Runes  = @(
                @{ Index = 0; Rune = 127797 }
            )
        }
        @{
            Name   = "pencil"
            Symbol = '✏️'
            Kind   = 'Item'
            Runes  = @(
                @{ Index = 0; Rune = 9999 }
                @{ Index = 1; Rune = 65039 }
            )
        }
    ) {
        It "Returns <symbol>" {
            Get-Emoji -Name $name | Should -Be $symbol
        }

        It "Has kind <kind>" {
            Get-Emoji -Name $name | Get-EmojiKind | Should -Be $kind
        }

        Context "Runes (each character in multibyte emoji)" -ForEach $runes {
            It "Has rune <rune> on index <index>" {
                $actual = @((Get-Emoji -Name $name).EnumerateRunes())
                $actual[$index].Value | Should -Be $rune
            }
        }
    }

    Describe "Animals" {
        It "A <animal.emoji> (<name>) goes <animal.sound>" -ForEach @(
            @{
                Name   = "cow"
                Animal = @{
                    Sound = "Mooo"
                    Emoji = "🐄"
                }
            }

            @{
                Name   = "fox"
                Animal = @{
                    Sound = "Ring-ding-ding-ding-dingeringeding!"
                    Emoji = "🦊"
                }
            }
        ) {
            # ...
        }
    }
}