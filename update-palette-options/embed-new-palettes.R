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

# Save import/export paths as objects
import_path <- file.path("update-palette-options", "official photos")
export_path <- file.path("update-palette-options", "official palettes")

# Make a list to store extracted palettes
palette_list <- list()

# For each new photo:
for(image in all_photos$file_names){
  
  # Identify the photo title (i.e., no file extension)
  title <- all_photos$photo_title[all_photos$file_names == image]
  
  # Extract color
  colors <- palette_extract(image = file.path(import_path, image),
                            sort = T, progress_bar = F)
  
  # Plot the extracted palette
  palette_demo(palette = colors, export = T,
               export_name = file.path(export_path, title))
  
  # Add to list
  palette_list[[title]] <- data.frame("palette_full_name" = title,
                                      "hexes" = colors)
  
  # Print message
  message("Processing complete for image '", image, "'")
  
}

# Bind the list into a dataframe to make it easier to wrangle
palette_df_v0 <- palette_list %>%
  purrr::map_dfr(.f = dplyr::bind_rows)

# Add the LTER logo palette manually
lter_palette <- data.frame("palette_full_name" = "LTER-logo",
                           "hexes" = c("#5A5C37", "#209ACA", "#97AE3F",
                                       "#FFDF1D", "#4AB2CB", "#DA6641",
                                       "#B89E92", "#374228"))

# Add it to the extracted palettes
palette_df <- lter_palette %>%
  dplyr::bind_rows(palette_df_v0)

# Glimpse that
dplyr::glimpse(palette_df)

## --------------------------------------------- ##
          # Wrangle Extracted Palettes ----
## --------------------------------------------- ##
# Now that we have palettes and titles, we have additional wrangling to do
palette_actual <- palette_df %>%
  # Split the title apart into the site abbreviation and the photo name
  ## But we'll keep the combined version
  tidyr::separate(col = palette_full_name,
                  into = c("lter_site", "palette_name"),
                  sep = "-", remove = FALSE) %>%
  # Manually pull photographer name based on the photo title
  dplyr::mutate(photographer = dplyr::case_when(
    palette_full_name == "LTER-logo" ~ "LTER Network Office",
    # Andrews Forest (AND)
    palette_full_name == "AND-reu" ~ "Lina DiGregorio",
    palette_full_name == "AND-salamander" ~ "Chris Cousins",
    palette_full_name == "AND-training" ~ "Joelle Worthley",
    # Arctic (ARC)
    palette_full_name %in% c("ARC-aurora", "ARC-bucket") ~ "Jansen Nipko",
    palette_full_name %in% c("ARC-autumn", "ARC-sunrise",
                             "ARC-sunset") ~ "Lindsay VanFossen",
    palette_full_name == "ARC-hike" ~ "Abigail Rec",
    # Beaufort Lagoon Ecosystems (BLE)
    palette_full_name == "BLE-ice drill" ~ "Ken Dunton",
    palette_full_name == "BLE-sunset" ~ "Kaylie Plumb",
    # Central Arizona–Phoenix (CAP)
    palette_full_name == "CAP-cactus" ~ "Quincy Stewart",
    palette_full_name == "CAP-lovebird" ~ "Maddy Gibson",
    # Hubbard Brook
    palette_full_name %in% c("HBR-canopy", "HBR-lotus",
                             "HBR-mushroom floor") ~ "Ashley Lang",
    palette_full_name == "HBR-mushroom tree" ~ "Jackie Matthes",
    # Jornada Basin (JRN)
    palette_full_name == "JRN-calf" ~ "Dylan Stover",
    palette_full_name %in% c("JRN-monsoon", "JRN-oryx", "JRN-rainbow",
                             "JRN-sunset") ~ "Ryan Schroeder",
    # Kellogg Biological Station
    palette_full_name == "KBS-birds" ~ "Michaela Rose",
    palette_full_name == "KBS-morning" ~ "Kara Dobson",
    palette_full_name %in% c("KBS-fire", "KBS-storm") ~ "Yahn-Jauh Su",
    palette_full_name == "KBS-swallowtail" ~ "Corinn Rutkoski",
    # Konza Prairie (KNZ)
    palette_full_name %in% c("KNZ-bison", "KNZ-burn", "KNZ-night fire",
                             "KNZ-regal") ~ "Jill Haukos",
    # Moorea Coral Reef (MCR)
    palette_full_name == "MCR-lagoon" ~ "Kathryn Scafidi",
    # Northern Gulf of Alaska (NGA)
    palette_full_name == "NGA-boat" ~ "Emily Stidham",
    # Niwot Ridge (NWT)
    palette_full_name %in% c("NWT-mountain dawn", "NWT-mountain field", "NWT-mountain flowers", "NWT-snowy mountain", "NWT-snowy trees", "NWT-wildflowers") ~ "Chiara Forester",
    # Palmer Station (PAL)
    palette_full_name %in% c("PAL-boat", "PAL-net", "PAL-penguins",
                             "PAL-squid") ~ "Andrew Corso",
    # Santa Barbara Coastal (SBC)
    palette_full_name == "SBC-kelp tag" ~ "Kyle Emery",
    # Virginia Coast (VCR)
    palette_full_name == "VCR-boat" ~ "Amelie Berger",
    palette_full_name == "VCR-marsh" ~ "Sophia Hoffman",
    # If you don't specify a photographer, "MISSING" will be entered
    TRUE ~ "MISSING") ) %>%
  # Also assign a type of palette to each palette
  dplyr::mutate(palette_type = dplyr::case_when(
    # Sequential - colors roughly follow a *single* gradient
    palette_full_name %in% c("AND-training", "ARC-aurora", "ARC-sunset", "HBR-canopy", "JRN-oryx", "KBS-birds", "NWT-snowy trees", "PAL-squid"
                             ) ~ "sequential",
    # Diverging - colors follow *two gradients*
    palette_full_name %in% c("ARC-hike", "ARC-sunrise", "BLE-sunset", "CAP-cactus", "JRN-monsoon", "JRN-rainbow", "JRN-sunset", "KBS-morning", "KBS-storm", "KNZ-bison", "NWT-mountain dawn", "NWT-mountain field", "NWT-mountain flowers", "NWT-snowy mountain", "PAL-net", "VCR-marsh"
                             ) ~ "diverging",
    # Tricolor - colors mostly fall into three groups
    palette_full_name %in% c("AND-salamander", "ARC-autumn", "HBR-mushroom floor", "HBR-mushroom tree", "KBS-fire", "KNZ-night fire", "MCR-lagoon", "NWT-wildflowers", "PAL-penguins"
                             ) ~ "tricolor",
    # Qualitative - colors do not follow a gradient and/or seem random
    palette_full_name %in% c("LTER-logo", "AND-reu", "ARC-bucket", "BLE-ice drill", "CAP-lovebird", "HBR-lotus", "JRN-calf", "KBS-swallowtail", "KNZ-burn", "KNZ-regal", "NGA-boat", "PAL-boat", "SBC-kelp tag", "VCR-boat"
                             ) ~ "qualitative",
    # If the photo name isn't included in one of these three, "MISSING" will be entered
    TRUE ~ "MISSING") ) %>%
  # Create a color number column
  dplyr::group_by(palette_full_name) %>%
  dplyr::mutate(color_number = paste0("color_", seq_along(hexes))) %>%
  dplyr::ungroup() %>%
  # Reorder columns
  dplyr::select(photographer, palette_full_name, lter_site, palette_name,
                palette_type, color_number, hexes) %>%
  # Pivot to wide format
  tidyr::pivot_wider(
    id_cols = photographer:palette_type,
    names_from = color_number,
    values_from = hexes) %>%
  # Make it a dataframe
  as.data.frame()

# Take another look
dplyr::glimpse(palette_actual)


# JRN-pronghorn | Brandon Bestelmeyer


# Check that all photos have a photographer and palette type identified
## Photographer
palette_actual$palette_full_name[palette_actual$photographer == "MISSING"]
## Go up and add photographers to any photos that pop up here

## Palette type
palette_actual$palette_full_name[palette_actual$palette_type == "MISSING"]
## Go up and add palette types to any photos that pop up here

## --------------------------------------------- ##
     # Export Updated Official Palettes ----
## --------------------------------------------- ##

# Take one last look
head(palette_actual)

# Re-name it
palette_options <- palette_actual

# Save it as a .rda
base::save(palette_options, file = file.path("data", "palette_options.rda"))

# Clear environment
rm(list = ls())

# Load the `palette_options` file to make sure that worked
load(file.path("data", "palette_options.rda"))

# Examine structure
dplyr::glimpse(palette_options)

# Clear environment
rm(list = ls())

# End ----
