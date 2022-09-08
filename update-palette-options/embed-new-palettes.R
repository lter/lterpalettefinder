## --------------------------------------------- ##
          # Update `palette_options` File
## --------------------------------------------- ##
# Written by Nick J Lyon

# Script Purpose:
# Periodically we may want to add official palettes to the `palette_options` dataframe that the `palette_find` function queries.
# This script contains everything that is needed to successfully add new palettes to `palette_options`

## --------------------------------------------- ##
            # Script Pre-Requisites ----
## --------------------------------------------- ##

# 1) Pull the latest version of `lterpalettefinder`
            
# 2) Name photo files as "[site abbreviation]-[short photo title]"
            
# 3) Move photos into the "official photos" folder
     ## (It's within the "update-palette-options" folder)

# Once these steps have been accomplished, follow along below!

## --------------------------------------------- ##
                # Housekeeping ----
## --------------------------------------------- ##
# Load needed packages
# install.packages("librarian")
librarian::shelf(devtools, tidyverse, tools)

# Load development version of `lterpalettefinder`
devtools::load_all()

# Clear environment
rm(list = ls())

# Explicitly load the palette_options file
load(file.path("data", "palette_options.rda"))

# Create directory for saving exploratory palettes
dir.create(path = file.path("update-palette-options", "official palettes"),
           showWarnings = FALSE)

## --------------------------------------------- ##
           # Extract Color Palettes ----
## --------------------------------------------- ##
# Identify the files in that folder
photo_names <- data.frame( "file_names" = dir(file.path("update-palette-options", "official photos")))

# Need to do a tiny amount of additional wrangling
all_photos <- photo_names %>%
  tidyr::separate(col = file_names, into = c("photo_title", "file_type"),
                  remove = FALSE, sep = "\\.")
head(all_photos)

# To save on processing time, drop the photos we already have palettes for
new_photos <- all_photos
# new_photos <- all_photos %>%
#   dplyr::filter(photo_title %in% setdiff(photo_title,
#                                         palette_options$palette_full_name))
# new_photos

# Save import/export paths as objects
import_path <- file.path("update-palette-options", "official photos")
export_path <- file.path("update-palette-options", "official palettes")

# Make a list to store extracted palettes
palette_list <- list()

# For each new photo:
for(image in new_photos$file_names){
  
  # Identify the photo title (i.e., no file extension)
  title <- new_photos$photo_title[new_photos$file_names == image]
  
  # Extract color
  colors <- palette_extract(image = file.path(import_path, image),
                            sort = T, progress_bar = F)
  
  # Plot the extracted palette
  palette_demo(palette = colors, export = T,
               export_name = file.path(export_path, title))
  
  # Add to list
  palette_list[[title]] <- data.frame("source" = title,
                                      "hexes" = colors)
  
  # Print message
  message("Processing complete for image '", image, "'")
  
}

# Check the resulting list briefly
str(palette_list)

## --------------------------------------------- ##
          # Wrangle Extracted Palettes ----
## --------------------------------------------- ##




palette_list


# LTER logo palette
c("#5A5C37", "#209ACA", "#97AE3F", "#FFDF1D", "#4AB2CB", "#DA6641", "#B89E92", "#374228")


# Vital stats of pics




# AND-reu | Lina DiGregorio
# AND-salamander | Chris Cousins
# AND-training | Joelle Worthley

# ARC-aurora | Jansen Nipko
# ARC-autumn | Lindsay VanFossen
# ARC-bucket | Jansen Nipko
# ARC-hike | Abigail Rec
# ARC-sunrise | Lindsay VanFossen
# ARC-sunset | Lindsay VanFossen

# BLE-icedrill | Ken Dunton
# BLE-sunset | Kaylie Plumb

# CAP-cactus | Quincy Stewart
# CAP-lovebird | Maddy Gibson

# HBR-canopy | Ashley Lang
# HBR-lotus | Ashley Lang
# HBR-mushroom floor | Ashley Lang
# HBR-mushroom tree | Jackie Matthes


# JRN-calf | Dylan Stover
# JRN-monsoon | Ryan Schroeder
# JRN-oryx | Ryan Schroeder
# JRN-rainbow | Ryan Schroeder
# JRN-sunset | Ryan Schroeder

# KBS-birds | Michaela Rose
# KBS-fire | Yahn-Jauh Su
# KBS-morning | Kara Dobson
# KBS-storm | Yahn-Jauh Su

# KNZ-bison | Jill Haukos
# KNZ-burn | Jill Haukos
# KNZ-nightfire | Jill Haukos
# KNZ-regal | Jill Haukos

# MCR-lagoon | Kathryn Scafidi

# NGA-boat | Emily Stidham

# NWT-mountain dawn | Chiara Forester
# NWT-mountain field | Chiara Forester
# NWT-mountain flowers | Chiara Forester
# NWT-snowy mountain | Chiara Forester
# NWT-snowy trees | Chiara Forester
# NWT-wildflowers | Chiara Forester

# PAL-boat | Andrew Corso
# PAL-net | Andrew Corso
# PAL-penguins | Andrew Corso
# PAL-squid | Andrew Corso

# SBC-kelp tag | Kyle Emery

# VCR-boat | Amelie Berger
# VCR-marsh | Sophia Hoffman


# Extract Palette from Photos -------------------------

# Identify file name (w/o suffix)
photo_name <- "fire"

# Extract color
colors <- lterpalettefinder::palette_extract(image = file.path("Photos", paste0(photo_name, ".png")))

# Take a look at that object
head(colors)

# Plot the extracted palette
lterpalettefinder::palette_demo(palette = colors, export = T, export_name = file.path("Palettes", paste0(photo_name, "-palette")))

# Make a dataframe
color_df <- data.frame("source" = photo_name, "hex_code" = colors)
head(color_df)

# Export the .csv if need be
write.csv(x = color_df, row.names = F, file = file.path("Palettes", paste0(photo_name, "-palette-df.csv")))

# Check Official Palettes -----------------------------------------
# After you've picked 10 colors from a new picture and added them to the csv, read the csv in and take a look at how the colors look when they're in a graph together in the order you entered them.
# If needed, revise your entry for that row and re-load in the .csv

# Read in data
# palette_options <- lterpalettefinder::palette_find()
palette_options <- read.csv(file = file.path('Data', 'palette_options.csv'))

# Choose which row (i.e., which palette) to graph
row_num <- 14

# Prepare a palette
specific_palette <- palette_options[row_num, 7:ncol(palette_options)] %>%
  # Pivot to long format
  tidyr::pivot_longer(cols = dplyr::everything(),
                      names_to = "color_num",
                      values_to = "hex") %>%
  # Drop colors that aren't in the given palette
  dplyr::filter(nchar(hex) != 0) %>%
  # Make it a dataframe
  as.data.frame()

# Do an exploratory ggplot!
lterpalettefinder::palette_ggdemo(palette = specific_palette$hex)

# End ----




## -------------------------------------------------- ##
# Save Palette .csv as .rda ----
## -------------------------------------------------- ##
# Written by Nick Lyon

# Save CSV as RDA --------------------------------------

# NOTE:
## This script assumes that you just edit the .csv via your preferred method and then run this script. Be sure to close the .csv when you're done editing but **before** running this script.

# Clear environment
rm(list = ls())

# Read in data
palette_options <- read.csv(file = file.path('Data', 'palette_options.csv'))

# Save it as a .rda
base::save(palette_options, file = file.path('Data', 'palette_options.rda'))

# Check that worked ------------------------------------

# Clear environment
rm(list = ls())

# Load the file
load(file.path('Data', 'palette_options.rda'))

# Examine structure
str(palette_options)

# End --------------------------------------------------
