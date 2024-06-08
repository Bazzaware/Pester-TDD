$emojis = @(
    @{ Name = 'apple'; Symbol = '🍎'; Kind = 'Fruit' }
    @{ Name = 'beaming face with smiling eyes'; Symbol = '😁'; Kind = 'Face' }
    @{ Name = 'cactus'; Symbol = '🌵'; Kind = 'Plant' }
    @{ Name = 'giraffe'; Symbol = '🦒'; Kind = 'Animal' }
    @{ Name = 'pencil'; Symbol = '✏️'; Kind = 'Item' }
    @{ Name = 'penguin'; Symbol = '🐧'; Kind = 'Animal' }
    @{ Name = 'pensive'; Symbol = '😔'; Kind = 'Face' }
    @{ Name = 'slightly smiling face'; Symbol = '🙂'; Kind = 'Face' }
    @{ Name = 'smiling face with smiling eyes'; Symbol = '😊'; Kind = 'Face' }
) | ForEach-Object { [PSCustomObject]$_ }

function Get-Emoji ([string]$Name = '*') {
    $script:emojis | Where-Object Name -like $Name | ForEach-Object Symbol
}

function Get-EmojiKind {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Emoji
    )
    process {
        $script:emojis | Where-Object Symbol -eq $Emoji | Foreach-Object Kind
    }
}

$fruitBasket = [System.Collections.ArrayList]@('🍎', '🍌', '🥝', '🥑', '🍇', '🍐')

function Get-FruitBasket {
    $script:fruitBasket
}

function Remove-FruitBasket {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Item
    )
    $script:fruitBasket.Remove($Item)
}

function Reset-FruitBasket {
    $script:fruitBasket = [System.Collections.ArrayList]@('🍎', '🍌', '🥝', '🥑', '🍇', '🍐')
}