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
## Works on my computer, but why?

# What happens if we make small integers and convert to hex format?
small_int <- base::as.integer(x = 1:15)
base::as.hexmode(x = small_int)

# Versus using a vector that includes both one and two digit hexadecimals?
lrg_int <- base::as.integer(x = 1:25)
base::as.hexmode(x = lrg_int)

# Clear environment again
rm(list = ls())

# End ----
