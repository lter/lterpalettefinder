## ----------------------------------------------------------- ##
                    # Package Troubleshooting
## ----------------------------------------------------------- ##

# PURPOSE:
## Dedicated space (within package) for troubleshooting/developing functions
## Allows using `devtools::load_all()` to +/- instantly load latest changes

## ------------------------------------- ##
  # Issue #7: Hex Mis-Transformation ----
## ------------------------------------- ##
# https://github.com/lter/lterpalettefinder/issues/7

# Clear environment
rm(list = ls())

# Load lterpalettefinder **development version**
devtools::load_all()

# Assign image object to use guts of function more directly
image_path <- file.path("troubleshooting", "simple_image.png")

# Use palette_extract on the test image
(test <- palette_extract(image = image_path, progress_bar = T))

# Check it
palette_ggdemo(palette = test)

# Create a set of integers <10 (i.e., those that should be "0x" as hexcodes)
(test_ints <- base::as.integer(x = 1:9))

# Force them to be hexadecimals
(test_hex <- base::as.hexmode(test_ints))

# Make them characters
(test_char <- base::as.character(test_hex))

# What if it was a dataframe?
(test_df <- data.frame("ints" = test_ints))

# Now make it hexadecimal
(as.hexmode(test_df$ints))

# Now assemble them into a faux hexcode
paste0("#", test_char[1], test_char[2], test_char[3])
## Would be inappropriate because doesn't make them two digits

# Now try with guts of `palette_extract`
pic <- png::readPNG(source = image_path, native = FALSE)
# pic <- jpeg::readJPEG(source = image, native = FALSE)

# Extract RGB channels
rawR <- base::as.integer(pic[,,1] * 255)
rawG <- base::as.integer(pic[,,2] * 255)
rawB <- base::as.integer(pic[,,3] * 255)

# Put them into a dataframe
rgb_v1 <- base::data.frame("red" = rawR, "green" = rawG, "blue" = rawB)

# Subset out very dark colors (i.e., those with RGB values all below a threshold)
rgb_v2 <- rgb_v1 %>%
  dplyr::filter(!(red < 65 & green < 65 & blue < 65))

# Return only unique values
rgb_v3 <- base::unique(rgb_v2)

# If >25 colors, do k-means clustering on these RGB values
## More than 25 colors
if(nrow(rgb_v3) > 25){
  rgb_v4 <- base::as.data.frame(
    base::suppressWarnings(
      stats::kmeans(x = rgb_v3, centers = 25,
                    iter.max = 100, nstart = 1)$centers)) }
## Fewer than 25 colors
if(nrow(rgb_v3) <= 25){ rgb_v4 <- rgb_v3 }

# Turn them into integers (instead of continuous numbers)
rgb_v5 <- rgb_v4 %>%
  dplyr::mutate(red = base::as.integer(red),
                green = base::as.integer(green),
                blue = base::as.integer(blue))

# Coerce them into hexadecimals
hexR <- base::as.hexmode(rgb_v5$red)
hexG <- base::as.hexmode(rgb_v5$green)
hexB <- base::as.hexmode(rgb_v5$blue)

# If any of those are one digit (i.e., 0:9), add a leading zero
if(base::nchar(hexR) == 1){ hexR <- base::paste0("0", base::as.character(hexR)) }
if(base::nchar(hexG) == 1){ hexG <- base::paste0("0", base::as.character(hexG)) }
if(base::nchar(hexB) == 1){ hexB <- base::paste0("0", base::as.character(hexB)) }

# Bind hexadecimals into HEX codes
hex_vec <- base::paste0('#',
                        base::as.character(hexR),
                        base::as.character(hexG),
                        base::as.character(hexB))

# Return only unique values to the user
hexes <- base::data.frame(hex_code = base::unique(hex_vec))

# Make it a vector
hex_vec <- base::as.character(hexes$hex_code)

# Clear environment again
rm(list = ls())

# End ----
