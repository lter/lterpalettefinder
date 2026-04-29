# LTER Palette Options

For each palette, data includes the photographer, LTER site, number of
included colors, and the hexadecimal codes for each color (data are in
'wide' format)

## Usage

``` r
palette_options
```

## Format

A dataframe with 14 variables and one row per palette (currently 14
rows)

- photographer:

  name of the photographer who took the picture

- palette_full_name:

  concatenation of LTER site and palette name, separated by a hyphen

- lter_site:

  three-letter LTER site name abbreviation

- palette_name:

  a unique-within site-name for each palette based on the picture's
  content

- palette_type:

  either "qualitative", "sequential", or "diverging" depending on the
  pattern of colors in the palette

- color\_...:

  the hexadecimal code for colors 1 through n for each palette

## Source

Lyon, N. J., De La Rosa, G. 2022.
