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
(test <- palette_extract(image = image_path, sort = F, progress_bar = T))

# Check it
palette_ggdemo(palette = test)
## Fails due to malformed hexcodes
## Need to recreate the function step-by-step to see where it fails/how to fix it

# What happens if we make small integers and convert to hex format?
small_int <- base::as.integer(x = 1:15)
base::as.hexmode(x = small_int)

# Versus using a vector that includes both one and two digit hexadecimals?
lrg_int <- base::as.integer(x = 1:25)
base::as.hexmode(x = lrg_int)

# Name file
image <- file.path("troubleshooting", "simple_image.png")

# Read it in
pic <- png::readPNG(source = image, native = FALSE)

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

# Coerce them into hexadecimals and coerce those into characters
hexR <- base::as.character(base::as.hexmode(rgb_v5$red))
hexG <- base::as.character(base::as.hexmode(rgb_v5$green))
hexB <- base::as.character(base::as.hexmode(rgb_v5$blue))

# Handle dropping of leading zero for integers <15 (i.e., one-digit hexadecimals)
hexR_fix <- base::ifelse(test = base::nchar(hexR) == 1,
                         yes = paste0("0", hexR),
                         no = hexR)
hexG_fix <- base::ifelse(test = base::nchar(hexG) == 1,
                         yes = paste0("0", hexG),
                         no = hexG)
hexB_fix <- base::ifelse(test = base::nchar(hexB) == 1,
                         yes = paste0("0", hexB),
                         no = hexB)

# Bind hexadecimals into HEX codes
hex_vec <- base::paste0('#', hexR_fix, hexG_fix, hexB_fix)

# Return only unique values to the user
hexes <- base::data.frame(hex_code = base::unique(hex_vec))

# Make it a vector
hex_vec <- base::as.character(hexes$hex_code)

# Sort colors
hex_sort <- lterpalettefinder::palette_sort(palette = hex_vec)

# Visualize sorted and unsorted
palette_ggdemo(hex_vec)
palette_ggdemo(hex_sort)

# Clear environment again
rm(list = ls())

# End ----
