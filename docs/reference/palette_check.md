# Check Hexadecimal Code Formatting

Accepts the hexadecimal code vector and tests if it is formatted
correctly

## Usage

``` r
palette_check(palette)
```

## Arguments

- palette:

  (character) Vector of hexadecimal codes returned by
  \`palette_extract()\`, \`...\_sort()\`, or \`...\_subsample()\`

## Value

An error message or nothing

## Examples

``` r
# Check for misformatted hexcodes
palette_check(palette = c("#8e847a", "#9fc7f2"))
```
