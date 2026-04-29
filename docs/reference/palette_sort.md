# Sort Hexadecimal Codes by Hue and Saturation

Sorts hexademical codes retrieved by \`palette_extract()\` by hue and
saturation. This allows for reasonably good identification of 'similar'
colors in the way that a human eye would perceive them (as opposed to a
computer's representation of colors).

## Usage

``` r
palette_sort(palette)
```

## Arguments

- palette:

  (character) Vector returned by \`palette_extract()\`

## Value

(character) Vector containing all hexadecimal codes returned by
\`palette_extract()\`

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
palette_demo(palette = my_colors)


# Now sort
sort_colors <- palette_sort(palette = my_colors)

# And plot again to show change
palette_demo(palette = sort_colors)

```
