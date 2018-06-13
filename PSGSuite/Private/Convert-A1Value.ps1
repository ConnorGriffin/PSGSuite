# Function to convert digit to alphabet
Function Convert-A1Value {
	<# 
	.SYNOPSIS 
	This converts any integer into A1 format, and vice-versa
	.DESCRIPTION 
	See synopsis. 
	.PARAMETER value 
    Any number between 1 and 2147483647, or any string
	#> 

	param(
        [parameter(Mandatory=$true,ValueFromPipeline)] 
        $value
    ) 

    if ($value -is [int]) {
        $a1Value = $null 
        While ($value -gt 0) { 
            $multiplier = [int][system.math]::Floor(($value / 26)) 
            $charNumber = $value - ($multiplier * 26) 
            If ($charNumber -eq 0) { $multiplier-- ; $charNumber = 26 } 
            $a1Value = [char]($charNumber + 64) + $a1Value 
            $value = $multiplier 
        } 
        $a1Value 
    } elseif ($value -is [string]) {
        # If a string is provided, convert to a number (A = 1,AA = 27, AAA = 703)
        $array = ([char[]]$value)
        $i = 0
        $value = 0
        $count = $array.Count
        # Iterate through all but the last value
        if ($count -gt 1) {
            $array[0..($array.Count - 2)] | ForEach-Object {
                $i++ # for some reason $array.IndexOf($_) doesn't work
                $multiplier = [math]::Pow(26,($count-$i))
                $value += ([byte][char]$_ - 64) * $multiplier
            }
        }
        $value += ([byte][char]$array[$array.Count - 1]) - 64
        $value
    }
}