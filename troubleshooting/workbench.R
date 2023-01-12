## ----------------------------------------------------------- ##
                    # Package Troubleshooting
## ----------------------------------------------------------- ##

# PURPOSE:
## Dedicated space (within package) for troubleshooting/developing functions
## Allows using `devtools::load_all()` to +/- instantly load latest changes

## ------------------------------------- ##
  # Issue #6: Images with <25 Colors ----
## ------------------------------------- ##
# https://github.com/lter/lterpalettefinder/issues/6

# Clear environment
rm(list = ls())

# Load lterpalettefinder **development version**
devtools::load_all()

# Use palette_extract on the test image
test <- palette_extract(image = file.path("troubleshooting", "simple_image.png"), 
                        sort = T, progress_bar = T)
## Error in sample.int(m, k) : 
## cannot take a sample larger than the population when 'replace = FALSE'

# Assign image object to use guts of function more directly
image <- file.path("troubleshooting", "simple_image.png")

# Read it in
pic <- png::readPNG(source = image, native = FALSE)

# Extract RGB channels
rawR <- base::as.integer(pic[,,1] * 255)
rawG <- base::as.integer(pic[,,2] * 255)
rawB <- base::as.integer(pic[,,3] * 255)

# Put them into a dataframe
rgb_v1 <- base::data.frame("red" = rawR, "green" = rawG, "blue" = rawB)

### Check that out
head(rgb_v1)

# We want to subset out very dark colors
rgb_v2 <- rgb_v1 %>%
  dplyr::filter(!(red < 65 & green < 65 & blue < 65))

# Return unique values
rgb_v3 <- unique(rgb_v2)

# If >25 colors, do k-means clustering on these RGB values
if(nrow(rgb_v3) > 25){
  rgb_v4 <- base::as.data.frame(
    base::suppressWarnings(
      stats::kmeans(x = rgb_v3, centers = 25,
                    iter.max = 100, nstart = 1)$centers)) }
## Fewer than 25 colors
if(nrow(rgb_v3) <= 25){ rgb_v4 <- rgb_v3 }

### Check that result out
rgb_v4

# Turn them into integers (instead of continuous numbers)
rgb_v5 <- rgb_v4 %>%
  dplyr::mutate(red = base::as.integer(red),
                green = base::as.integer(green),
                blue = base::as.integer(blue))

# Coerce them into hexadecimals
hexR <- base::as.hexmode(rgb_v5$red)
hexG <- base::as.hexmode(rgb_v5$green)
hexB <- base::as.hexmode(rgb_v5$blue)

# Bind hexadecimals into HEX codes
hex_vec <- base::paste0('#',
                        base::as.character(hexR),
                        base::as.character(hexG),
                        base::as.character(hexB))

# Return only unique values to the user
hexes <- base::data.frame(hex_code = base::unique(hex_vec))

# Make it a vector
hex_vec <- base::as.character(hexes$hex_code)

# Sort in a similar way to human eye
hex_sort <- lterpalettefinder::palette_sort(palette = hex_vec)

# Do exploratory plotting with this
palette_demo(palette = hex_sort)
palette_ggdemo(palette = hex_sort)

# Export one of these plots (if desired)
ggplot2::ggsave(file.path("troubleshooting", "simple_palette.jpg"),
                height = 2, width = 3, units = "in")

# Clear environment again
rm(list = ls())

# End ----
