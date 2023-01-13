#' @title Sort Hexadecimal Codes by Hue and Saturation
#' 
#' @description Sorts hexademical codes retrieved by `palette_extract()`  by hue and saturation. This allows for reasonably good identification of 'similar' colors in the way that a human eye would perceive them (as opposed to a computer's representation of colors).
#' 
#' @param palette (character) Vector returned by `palette_extract()`
#' 
#' @return (character) Vector containing all hexadecimal codes returned by `palette_extract()`
#' 
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' # Extract colors from a supplied image
#' my_colors <- palette_extract(image = system.file("extdata", "lyon-fire.png",
#' package = "lterpalettefinder"))
#'        
#' # Plot that result
#' palette_demo(palette = my_colors)
#' 
#' # Now sort
#' sort_colors <- palette_sort(palette = my_colors)
#' 
#' # And plot again to show change
#' palette_demo(palette = sort_colors)
#'
palette_sort <- function(palette){
  
  # Check if palette is using the correct format
  palette_check(palette)
  
  # Squelch visible bindings note by assigning unquoted variables to NULL
  red <- green <- blue <- color_id <- value <- color <- NULL
  max_val <- min_val <- binR <- binG <- binB <- NULL
  hexR <- hexG <- hexB <- hue <- saturation <- NULL
  hexR_fix <- hexG_fix <- hexB_fix <- hex_code <- NULL
  
  # Get provided vector into a dataframe
  hex_df <- base::data.frame("hex_code" = palette)
  
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
    # Get hexadecimal as a character from RGB values
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
  
  # Return it
  return(hex_vec)
  
  }
