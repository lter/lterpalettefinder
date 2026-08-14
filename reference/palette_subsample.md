# Randomly Subsample HEX Codes

Randomly subsample the HEX codes returned by \`palette_extract()\` or
\`palette_sort()\` to desired length. Can also set random seed for
reproducibility.

## Usage

``` r
palette_subsample(palette, wanted = 5, random_seed = 36)
```

## Arguments

- palette:

  (character) Vector of hexadecimal codes like those returned by
  \`palette_extract()\` or \`palette_sort()\`

- wanted:

  (numeric) Integer for how many colors should be returned

- random_seed:

  (numeric) Integer for \`base::set.seed()\`

## Value

(character) Vector of hexadecimal codes of user-specified length

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


# Now randomly subsample
random_colors <- palette_subsample(palette = my_colors, wanted = 5)

# And plot again to show change
palette_ggdemo(palette = random_colors)

```
