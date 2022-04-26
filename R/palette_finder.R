## ------------------------------------------------------------- ##
         # LTER Network Office - Palette Finder Function
## ------------------------------------------------------------- ##
# Written by: Nick J Lyon

# Purpose
## Create function for easy identification of palettes from LTER photos that meet a user's needs (i.e., palette length, site origin, palette type, etc.)

# Clear environment
rm(list = ls())

# Call needed libraries
library(dplyr); library(tidyr); library(magrittr)

# Grab working directory (defaults to project directory which we want)
wd <- getwd()
wd

# Palette Finder Function ---------------------------------------------------

# Acquire tidy data
palette_options <- read.csv(file.path("Data", "palette_table.csv"))
head(palette_options)

# Function challenges -----------------

# - Figure out how to embed palette dataframe into the function (maybe something that is done at package level and not locally?)

# - Not a function issue per se, but need (1) palettes from more sites (2) longer (>10 colors) and (3) more palette types (sequential, diverging, qualitative)

# Current variant of the function -------
lter_palette_finder <- function(site = "all", name = "all", type = "all", length = "all"){
  
  # If any argument is unspecified it defaults to "all" and shouldn't be used as a subset condition.
  # Change the input to be a vector of all options in the data in these cases.
  if(site == "all"){ site <- unique(palette_options$lter_site) }
  if(name == "all"){ name <- unique(palette_options$palette_name) }
  if(type == "all"){ type <- unique(palette_options$palette_type) }
  if(length == "all"){ length <- unique(palette_options$palette_length) }
  
  # Subset to selected sites
  palt_v1 <- dplyr::filter(palette_options, lter_site %in% site)
  
  # Subset to selected names
  palt_v2 <- dplyr::filter(palt_v1, palette_name %in% name)
  
  # Subset to selected types
  palt_v3 <- dplyr::filter(palt_v2, palette_type %in% type)
  
  # Subset to selected lengths
  palt_v4 <- dplyr::filter(palt_v3, palette_length %in% length)
  
  # Pivot to long format
  palt_v5 <- tidyr::pivot_longer(data = palt_v4,
                                 cols = dplyr::starts_with('color'),
                                 names_to = 'color_num',
                                 values_to = 'color_hex')
  
  # Keep only hexes that are correct (need to be 7 characters long)
  palt_v6 <- dplyr::filter(palt_v5, nchar(color_hex) == 7)
  
  # Then pivot back to wide format
  palt_v7 <- tidyr::pivot_wider(data = palt_v6,
                             names_from = "color_num",
                             values_from = "color_hex")
  
  # Make it a dataframe
  palt <- as.data.frame(palt_v7)
  
  # Now check for some obvious errors
  ## No palette meets specified conditions
  if(nrow(palt) == 0){ print("No palette met the user-supplied conditions. Run function without specifying any arguments to see available palette options")
    return(palt) } else {
  
  ## More than 1 palette returned
  if(nrow(palt) > 1){
    print("Multiple options returned as a dataframe. Consider specifying subset and re-running function.")
    return(palt) } else {
  
  ## Exactly one palette identified
  if(nrow(palt == 1)){
    print("Exactly one palette identified. Output cropped to only HEX codes for ease of plotting")
    palt_simp <- as.vector(dplyr::select(.data = palt, dplyr::starts_with('color')))
    colnames(palt_simp) <- NULL
    return(palt_simp)
  } } } }

# Test the Function ----------------------------------------------------------

# To see all the options, simply run the function without specifying arguments
lter_palette_finder()

# What if our query returns NO options?
test_palt <- lter_palette_finder(length = 1)
test_palt

# What if our query returns MULTIPLE options?
test_palt <- lter_palette_finder(length = 5, site = "HBR")
test_palt

# What if our query returns JUST ONE option? (this is desirable)
test_palt <- lter_palette_finder(site = "AND")
test_palt

# Test plot
library(ggplot2)
( df <- data.frame(x = c("a", "b", "c", "d", "e"), y = 1:5) )
ggplot(data = df, aes(x = x, y = y, fill = x)) +
  geom_bar(stat = 'identity') +
  scale_fill_manual(values = test_palt) +
  theme_classic() + theme(legend.position = "none")



# End ------------------------------------------------------------------------
