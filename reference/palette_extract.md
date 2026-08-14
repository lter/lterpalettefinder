# Extract Hexadecimal Codes from an Image

Retrieves hexadecimal codes for the colors in an image file. Currently
only PNG, JPEG, TIFF, and HEIC files are supported. The function
automatically removes dark colors and removes 'similar' colors to yield
25 colors from which you can select the subset that works best for your
visualization needs. Note that photos that are very dark may return few
viable colors.

## Usage

``` r
palette_extract(image, sort = FALSE, progress_bar = TRUE)
```

## Arguments

- image:

  (character) Name/path to PNG, JPEG, TIFF, or HEIC file from which to
  extract colors

- sort:

  (logical) Whether extracted HEX codes should be sorted by hue and
  saturation

- progress_bar:

  (logical) Whether to \`message\` a progress bar

## Value

(character) Vector containing all hexadecimal codes remaining after
extraction and removal of 'dark' and 'similar' colors

## Examples

``` r
# Extract colors from a supplied image
my_colors <- palette_extract(image = system.file("extdata", "lyon-fire.png",
package = "lterpalettefinder"), sort = TRUE, progress_bar = FALSE)
       
# Plot that result
palette_demo(palette = my_colors)

```
