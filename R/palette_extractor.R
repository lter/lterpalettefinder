#' @title Extract Hexadecimal Codes from an Image
#' 
#' @description Retrieves hexadecimal codes for the colors in an image file. Currently only .PNG files are supported. The function automatically removes dark colors (i.e., colors where the red, green, and blue channels are less than 7) and removes 'similar' colors to yield a set of a few dozen colors (varies between images) from which you can select the subset that works best for your visualization needs. Note that photos that are very dark may return few viable colors and photos that are a single color may not return as many hex codes as more diverse images.
#' 
#' @param image Name of the .PNG file to extract colors from (only .PNGs are supported at this time)
#' @param progress_bar Logical (TRUE / FALSE) indicating whether printing a progress bar in the console as the function extracts colors is desired
#' 
#' @return A dataframe of a single column ("hex_code") containing all hexadecimal codes remaining after extraction and removal of 'dark' and 'similar' colors.
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' ## This example is commented out because that's not a real file path or PNG file.
#' ## This example will work if you change the first line to point to an existing .PNG
#' 
#' ## Extract colors from a supplied image
#' # my_colors <- palette_extractor(image = file.path("Path", "to", "picture.png"),
#' #  progress_bar = TRUE)
#' 
#' ## Create a plot to evaluate the HEX codes and facilitate selection of which you want
#' # ggplot(my_colors, aes(x = hex_code, y = 1, fill = hex_code)) +
#' # geom_bar(stat = 'identity') +
#' # scale_fill_manual(values = my_colors$hex_code) +
#' # theme(legend.position = 'none', axis.text.x = element_text(angle = 35, hjust = 1))
#'        
#' 
palette_extractor <- function(image, progress_bar = TRUE){
  # To squelch error in variable bindings, call all unquoted variables as NULL
  red <- green <- blue <- rgb_combo <- NULL
  factR <- factG <- factB <- R <- G <- B <- NULL
  color_id <- color <- value <- . <- NULL
  
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
    
    # Identify hexadecimal order
    hex_ord <- c('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f')
    
    ## Split back out colors for filtering assistance
    hex_v3 <- dplyr::mutate(.data = hex_v2,
                            red = stringr::str_sub(rgb_combo, start = 1, end = 1),
                            green = stringr::str_sub(rgb_combo, start = 2, end = 2),
                            blue = stringr::str_sub(rgb_combo, start = 3, end = 3),
                            factR = factor(red, levels = hex_ord),
                            factG = factor(green, levels = hex_ord),
                            factB = factor(blue, levels = hex_ord))
    
    ## Remove really dark colors that are likely less useful
    hex_v4 <- dplyr::filter(.data = hex_v3,
                            base::as.integer(factR) >= 6 &
                              base::as.integer(factG) >= 6 &
                              base::as.integer(factB) >= 6) %>%
      dplyr::select(factR, factG, factB)
    
    # Progress bar (PB)
    if(progress_bar == TRUE) {print('{==================================    }')}
    
    ## Get integer versions of the factors
    hex_v5 <- dplyr::mutate(.data = hex_v4,
                            R = base::as.integer(factR),
                            G = base::as.integer(factG),
                            B = base::as.integer(factB)) %>%
      dplyr::select(R, G, B)
    
    ## Perform k-means clustering
    hex_v6 <- base::as.data.frame(stats::kmeans(x = hex_v5, centers = 25,
                                                iter.max = 100, nstart = 1)$centers)
    
    ## Transform integers back into hexadecimals
    hex_v7 <- hex_v6 %>%
      dplyr::mutate(red = base::as.integer(R),
                    green = base::as.integer(G),
                    blue = base::as.integer(B)) %>%
      dplyr::mutate(color_id = 1:base::nrow(.)) %>%
      tidyr::pivot_longer(cols = red:blue, names_to = 'color',
                          values_to = 'value') %>%
      dplyr::mutate(
        value = dplyr::case_when(
          value == 1 ~ '0', value == 2 ~ '1', value == 3 ~ '2',
          value == 4 ~ '3', value == 5 ~ '4', value == 6 ~ '5', 
          value == 7 ~ '6', value == 8 ~ '7', value == 9 ~ '8',
          value == 10 ~ '9', value == 11 ~ 'a', value == 12 ~ 'b',
          value == 13 ~ 'c', value == 14 ~ 'd',
          value == 15 ~ 'e', value == 16 ~ 'f') ) %>%
      tidyr::pivot_wider(id_cols = color_id, names_from = color,
                         values_from = value)
    
    # Progress bar (PB)
    if(progress_bar == TRUE) {print('{====================================  }')}
    
    ## Create hexadecimal codes from RGB
    hex_v8 <- dplyr::mutate(.data = hex_v7,
                            hex_code = paste0('#',
                                              red, red,
                                              green, green,
                                              blue, blue))
    
    ## Keep only hex codes
    hex_v9 <- base::data.frame(hex_code = base::unique(hex_v8$hex_code))
    
    ## And return only unique values
    
    # Progress bar finish
    if(progress_bar == TRUE) {print('{======================================}')}
    
    ## Return hex_v9
    return(hex_v9) } }
