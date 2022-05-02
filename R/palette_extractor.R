#' @title Extract Hexadecimal Codes from an Image
#' 
#' @description Retrieves hexadecimal codes for the colors in an image file. Currently only .PNG files are supported. The function automatically removes dark colors (i.e., colors where the red, green, and blue channels are less than 7) and removes 'similar' colors to yield a set of a few dozen colors (varies between images) from which you can select the subset that works best for your visualization needs. Note that photos that are very dark may return few viable colors and photos that are a single color may not return as many hex codes as more diverse images.
#' 
#' @param image Name of the .PNG file to extract colors from (only .PNGs are supported at this time)
#' @param progress_bar Logical (TRUE / FALSE) indicating whether printing a progress bar in the console as the function extracts colors is desired
#' 
#' @return A dataframe of a single column ("hex_code") containing all hexadecimal codes remaining after extraction and removal of 'dark' and 'similar' colors.
#' @export
#'
#' @examples
#' # Extract colors from a supplied image
#' my_colors <- palette_extractor(image = file.path("Path", "to", "picture.png"), progress_bar = TRUE)
#' 
#' # Create a plot to evaluate the HEX codes and facilitate selection of which you want
#' ggplot(my_colors, aes(x = hex_code, y = 1, fill = hex_code)) +
#' geom_bar(stat = 'identity') +
#'   scale_fill_manual(values = my_colors$hex_code) +
#'   theme(legend.position = 'none',
#'        axis.text.x = element_text(angle = 35, hjust = 1))
#'        
#' 
palette_extractor <- function(image, progress_bar = TRUE){
  # Return a warning if PNG isn't in the name of the file
  if(stringr::str_detect(string = image, pattern = '.png') == FALSE){
    print('PNG suffix not detected in `image` argument. File may not be a .PNG. Please check that file is in PNG format and specify the suffix.')
  } else {
    
    # Grab image
    pic <- png::readPNG(source = image, native = FALSE)
    
    # Progress bar begin
    if(progress_bar == TRUE) {print('{===                                   }')}
    
    # Strip out RGB channels
    outR <- stringr::str_sub(string = base::as.character(base::as.hexmode(base::as.integer(pic[, , 1] * 255) ) ), start = 1, end = 1)
    outG <- stringr::str_sub(string = base::as.character(base::as.hexmode(base::as.integer(pic[, , 2] * 255) ) ), start = 1, end = 1)
    outB <- stringr::str_sub(string = base::as.character(base::as.hexmode(base::as.integer(pic[, , 3] * 255) ) ), start = 1, end = 1)
    
    # Progress bar (PB)
    if(progress_bar == TRUE) {print('{===========                           }')}
    
    ## Combine into single dataframe
    rgb_v1 <- base::data.frame(red = outR, green = outG, blue = outB)
    
    # Progress bar (PB)
    if(progress_bar == TRUE) {print('{===================                   }')}
    
    ## Assemble hex codes from those values
    hex_v1 <- base::data.frame(rgb_combo = base::with(data = rgb_v1, paste0(red, green, blue)))
    
    ## Identify only unique colors
    hex_v2 <- base::unique(x = hex_v1)
    
    # Progress bar (PB)
    if(progress_bar == TRUE) {print('{============================          }')}
    
    ## Split back out colors for filtering assistance
    hex_v3 <- dplyr::mutate(.data = hex_v2,
                            red = stringr::str_sub(rgb_combo, start = 1, end = 1),
                            green = stringr::str_sub(rgb_combo, start = 2, end = 2),
                            blue = stringr::str_sub(rgb_combo, start = 3, end = 3),
                            numR = base::suppressWarnings(base::as.numeric(red)),
                            numG = base::suppressWarnings(base::as.numeric(green)),
                            numB = base::suppressWarnings(base::as.numeric(blue)))
    
    ## Remove really dark colors that are likely less useful
    hex_v4 <- dplyr::filter(.data = hex_v3, dplyr::if_all(numR:numB) >= 7 | dplyr::if_any(numR:numB, is.na))
    
    # Progress bar (PB)
    if(progress_bar == TRUE) {print('{==================================    }')}
    
    ## Group by each pairwise combo of R/G/B channels and pick only one observation
    ### red - green
    hex_v5 <- hex_v4 %>%
      dplyr::mutate(RG = paste0(red, green)) %>%
      dplyr::group_by(RG) %>%
      dplyr::summarise(red = dplyr::first(red),
                       green = dplyr::first(green),
                       blue = dplyr::first(blue))
    ### green - blue
    hex_v6 <- hex_v5 %>%
      dplyr::mutate(GB = paste0(green, blue)) %>%
      dplyr::group_by(GB) %>%
      dplyr::summarise(red = dplyr::first(red),
                       green = dplyr::first(green),
                       blue = dplyr::first(blue))
    ### blue - red
    hex_v7 <- hex_v6 %>%
      dplyr::mutate(BR = paste0(blue, red)) %>%
      dplyr::group_by(BR) %>%
      dplyr::summarise(red = dplyr::first(red),
                       green = dplyr::first(green),
                       blue = dplyr::first(blue)) %>%
      dplyr::ungroup()
    
    # Progress bar (PB)
    if(progress_bar == TRUE) {print('{====================================  }')}
    
    ## Create hexadecimal codes from RGB
    hex_v8 <- dplyr::mutate(.data = hex_v7,
                            hex_code = paste0('#', red, red, green, green, blue, blue))
    
    ## Keep only hex codes
    hex_v9 <- base::data.frame(hex_code = hex_v8$hex_code)
    
    # Progress bar finish
    if(progress_bar == TRUE) {print('{======================================}')}
    
    ## Return hex_v9
    return(hex_v9) } }
