# Demonstrate Extracted Palette with HEX Labels - Base Plot Edition

Accepts the hexadecimal code vector returned by \`palette_extract()\`,
\`...\_sort()\`, or \`...\_subsample()\` and creates a base plot of all
returned colors labeled with their HEX codes. This will facilitate
(hopefully) your selection of which of the 25 colors you would like to
use in a given context.

## Usage

``` r
palette_demo(
  palette,
  export = FALSE,
  export_name = "my_palette",
  export_path = getwd()
)
```

## Arguments

- palette:

  (character) Vector of hexadecimal codes like that returned by
  \`palette_extract()\`, \`...\_sort()\`, or \`...\_subsample()\`

- export:

  (logical) Whether or not to export the demo plot

- export_name:

  (character) Name for exported plot

- export_path:

  (character) File path to save exported plot (defaults to working
  directory)

## Value

A plot of the retrieved colors labeled with their HEX codes

## Examples

``` r
# Extract colors from a supplied image
my_colors <- palette_extract(
   image = system.file("extdata", "lyon-fire.png", package = "lterpalettefinder")
   )
#> {=         }
#> {==        }
#> {===       }
#> {====      }
#> {=====     }
#> {======    }
#> {=======   }
#> {========  }
#> {========= }
       
# Plot that result
palette_demo(palette = my_colors)

```
