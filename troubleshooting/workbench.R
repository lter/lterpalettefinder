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

# But if we try to sort it:
(test_sort <- palette_sort(palette = test))

# Check this
palette_ggdemo(palette = test_sort)

# Triple check: do extraction with embedded sorting
test2 <- palette_extract(image = image_path, sort = TRUE, progress_bar = T)
palette_ggdemo(palette = test2)
## Works!

# Time to fix step-by-step!

# Get provided vector into a dataframe
hex_df <- base::data.frame("hex_code" = test)

# Strip RGB back out of HEX codes
rgb <- base::as.data.frame(
  base::t(grDevices::col2rgb(hex_df$hex_code)))

# Coerce to 0-1
rgb_v2 <- rgb %>%
  dplyr::mutate(
    binR = red / 255,
    binG = green / 255,
    binB = blue / 255,
    # And assign a color ID for later use
    color_id = 1:base::nrow(rgb),
    .keep = 'unused')

# Pivot to longer
rgb_v3 <- rgb_v2 %>%
  tidyr::pivot_longer(cols = -color_id,
                      names_to = 'color',
                      values_to = 'value') %>%
  base::as.data.frame()

# Identify the maximum and minimum per color
rgb_v4 <- rgb_v3 %>%
  dplyr::group_by(color_id) %>%
  dplyr::mutate(max_val = base::max(value),
                max_col = color[base::which.max(value)],
                min_val = base::min(value),
                luminosity = (max_val - min_val)) %>%
  tidyr::pivot_wider(names_from = color,
                     values_from = value) %>%
  base::as.data.frame()

# Calculate hue and saturation!
rgb_v5 <- rgb_v4 %>%
  dplyr::mutate(
    # Hue first
    hue = dplyr::case_when(
      max_col == "binR" ~ ( 60 * ((binG - binB) / luminosity) ),
      max_col == "binG" ~ ( 60 * (2 + (binB - binR) / luminosity) ),
      max_col == "binB" ~ ( 60 * (4 + (binR - binG) / luminosity) )),
    # Then saturation
    saturation = dplyr::case_when(
      luminosity <= 0.5 ~ luminosity / (max_val + min_val),
      luminosity > 0.5 ~ luminosity / (2 - luminosity) ) )

# Get hexadecimals back
rgb_v6 <- rgb_v5 %>%
  dplyr::mutate(
    hexR = base::as.character(base::as.hexmode(binR * 255)),
    hexG = base::as.character(base::as.hexmode(binG * 255)),
    hexB = base::as.character(base::as.hexmode(binB * 255))) %>%
  # Perform same 'regain dropped leading 0' operation done in `palette_extract`
  dplyr::mutate(hexR_fix = base::ifelse(test = base::nchar(hexR) == 1,
                                         yes = paste0("0", hexR), no = hexR),
                hexG_fix = base::ifelse(test = base::nchar(hexG) == 1,
                                         yes = paste0("0", hexG), no = hexG),
                hexB_fix = base::ifelse(test = base::nchar(hexB) == 1,
                                         yes = paste0("0", hexB), no = hexB)) %>%
  # Create hexcodes from these
  dplyr::mutate(hex_code = base::paste0("#", hexR_fix, hexG_fix, hexB_fix))

# Order by hue and saturation
rgb_v7 <- rgb_v6[base::with( rgb_v6, base::order(hue, saturation)),]

# Get only hex_code
hex_out <- dplyr::select(.data = rgb_v7, hex_code)

# Make a character vector
hex_vec <- base::as.character(hex_out$hex_code)

# Plot this for sanity check
palette_ggdemo(hex_vec)

# Clear environment again
rm(list = ls())

# End ----
