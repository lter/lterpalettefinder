# Demonstrate Extracted Palette with HEX Labels - ggplot2 Edition

Accepts the hexadecimal code vector returned by \`palette_extract()\`,
\`...\_sort()\`, or \`...\_subsample()\` and creates a simple plot of
all returned colors labeled with their HEX codes. This will facilitate
(hopefully) your selection of which of the 25 colors you would like to
use in a given context.

## Usage

``` r
palette_ggdemo(palette)
```

## Arguments

- palette:

  (character) Vector of hexadecimal codes returned by
  \`palette_extract()\`, \`...\_sort()\`, or \`...\_subsample()\`

## Value

A ggplot2 plot

## Examples

``` r
# Extract colors from a supplied image
my_colors <- palette_extract(image = system.file("extdata", "lyon-fire.png",
package = "lterpalettefinder"))
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
palette_ggdemo(palette = my_colors)

```
