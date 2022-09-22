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

# To keep the computational load low, drop any photos we already have
new_photos <- all_photos %>%
  dplyr::filter(!photo_title %in% palette_options$palette_full_name)
head(new_photos)

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
  palette_list[[title]] <- data.frame("palette_full_name" = title,
                                      "hexes" = colors)
  
  # Print message
  message("Processing complete for image '", image, "'")
}

# Bind the list into a dataframe to make it easier to wrangle
palette_df_new <- palette_list %>%
  purrr::map_dfr(.f = dplyr::bind_rows)

# Save the palette_options dataframe as a different name and strip it back a bit
palette_df_old <- palette_options %>%
  # Pivot to long format
  tidyr::pivot_longer(cols = dplyr::starts_with("color_"),
                      names_to = "color_nums",
                      values_to = "hexes") %>%
  # Drop all but name and hex column
  dplyr::select(palette_full_name, hexes) %>%
  # Drop any rows that were NA columns
  dplyr::filter(!is.na(hexes))

# Add it to the extracted palettes
palette_df <- palette_df_old %>%
  dplyr::bind_rows(palette_df_new)

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
    # Non-Sites
    palette_full_name == "LTER-logo" ~ "LTER Network Office",
    palette_full_name == "ASM-2022 group" ~ "Alex Phillips",
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
    # Harvard Forest
    palette_full_name == "HFR-newt" ~ "Tatiana",
    palette_full_name == "HFR-sunset" ~ "Augustín León-Sáenz",
    # Hubbard Brook
    palette_full_name %in% c("HBR-canopy", "HBR-lotus",
                             "HBR-mushroom floor") ~ "Ashley Lang",
    palette_full_name == "HBR-mushroom tree" ~ "Jackie Matthes",
    palette_full_name == "HBR-winter tree" ~ "Lindsey Rustad",
    # Jornada Basin (JRN)
    palette_full_name == "JRN-calf" ~ "Dylan Stover",
    palette_full_name %in% c("JRN-monsoon", "JRN-oryx", "JRN-rainbow",
                             "JRN-sunset") ~ "Ryan Schroeder",
    palette_full_name == "JRN-pronghorn" ~ "Brandon Bestelmeyer",
    # Kellogg Biological Station
    palette_full_name == "KBS-birds" ~ "Michaela Rose",
    palette_full_name == "KBS-burn" ~ "G.P. Robertson",
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
    # North Temperate Lakes (NTL)
    palette_full_name == "NTL-lakes" ~ "Carl Bowser",
    # Niwot Ridge (NWT)
    palette_full_name %in% c("NWT-mountain dawn", "NWT-mountain field", "NWT-mountain flowers", "NWT-snowy mountain", "NWT-snowy trees", "NWT-wildflowers") ~ "Chiara Forester",
    # Palmer Station (PAL)
    palette_full_name %in% c("PAL-boat", "PAL-net", "PAL-penguins",
                             "PAL-squid") ~ "Andrew Corso",
    # Santa Barbara Coastal (SBC)
    palette_full_name == "SBC-kelp tag" ~ "Kyle Emery",
    palette_full_name == "SBC-kelp forest" ~ "SBC LTER",
    # Virginia Coast (VCR)
    palette_full_name == "VCR-boat" ~ "Amelie Berger",
    palette_full_name == "VCR-marsh" ~ "Sophia Hoffman",
    # If you don't specify a photographer, "MISSING" will be entered
    TRUE ~ "MISSING") ) %>%
  # Also assign a type of palette to each palette
  dplyr::mutate(palette_type = dplyr::case_when(
    # Sequential - colors roughly follow a *single* gradient
    palette_full_name %in% c("AND-training", "ARC-aurora", "ARC-sunset", "HBR-canopy", "JRN-oryx", "JRN-pronghorn", "KBS-birds", "NWT-snowy trees", "PAL-squid"
                             ) ~ "sequential",
    # Diverging - colors follow *two gradients*
    palette_full_name %in% c("ARC-hike", "ARC-sunrise", "BLE-sunset", "CAP-cactus", "HBR-winter tree", "JRN-monsoon", "JRN-rainbow", "JRN-sunset", "KBS-morning", "KBS-storm", "KNZ-bison", "NWT-mountain dawn", "NWT-mountain field", "NWT-mountain flowers", "NWT-snowy mountain", "PAL-net", "SBC-kelp forest", "VCR-marsh"
                             ) ~ "diverging",
    # Tricolor - colors mostly fall into three groups
    palette_full_name %in% c("ASM-2022 group", "AND-salamander", "ARC-autumn", "HBR-mushroom floor", "HBR-mushroom tree", "HFR-newt", "HFR-sunset", "KBS-fire", "KNZ-night fire", "MCR-lagoon", "NWT-wildflowers", "PAL-penguins"
                             ) ~ "tricolor",
    # Qualitative - colors do not follow a gradient and/or seem random
    palette_full_name %in% c("LTER-logo", "AND-reu", "ARC-bucket", "BLE-ice drill", "CAP-lovebird", "HBR-lotus", "JRN-calf", "KBS-burn", "KBS-swallowtail", "KNZ-burn", "KNZ-regal", "NGA-boat", "NTL-lakes", "PAL-boat", "SBC-kelp tag", "VCR-boat"
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

# Check that all photos have a photographer and palette type identified
## Photographer
(missing_names <- palette_actual %>%
  dplyr::filter(photographer == "MISSING") %>%
  dplyr::select(palette_full_name))
## Go up and add photographers to any photos that pop up here

## Palette type
(missing_types <- palette_actual %>%
    dplyr::filter(palette_type == "MISSING") %>%
    dplyr::select(palette_full_name))
## Go up and add palette types to any photos that pop up here

## --------------------------------------------- ##
     # Export Updated Official Palettes ----
## --------------------------------------------- ##

# Arrange columns by photo name alphabetically
palette_options <- palette_actual %>%
  dplyr::arrange(palette_full_name)

# Take one last look
head(palette_options)
# tibble::view(palette_options)

# Save it as a .rda
if(nrow(missing_names) != 0 | nrow(missing_types) != 0){
  # Print failure message
  message("Missing photographer ID or palette type in at least one palette! Return to line 114 and add the appropriate `case_when` logicals.")
  } else {
    # If everything is okay, save the file
save(palette_options, file = file.path("data", "palette_options.rda"))
    }

# Clear environment
rm(list = ls())

## --------------------------------------------- ##
     # Check Palette Counts / Site & Type ----
## --------------------------------------------- ##

# Clear environment
rm(list = ls())

# Load the `palette_options` file to make sure that worked
load(file.path("data", "palette_options.rda"))

# Examine structure
dplyr::glimpse(palette_options)
# tibble::view(palette_options)

# Check number of palettes per palette type
palette_options %>% 
  dplyr::group_by(palette_type) %>%
  dplyr::summarize(count = dplyr::n())

# Can also check per site
palette_options %>% 
  dplyr::group_by(lter_site) %>%
  dplyr::summarize(count = dplyr::n())

# Clear environment
rm(list = ls())

# End ----
