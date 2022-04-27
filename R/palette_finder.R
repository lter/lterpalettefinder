#' @title Find an LTER Palette
#' 
#' @description From a dataframe of all possible palettes (updated periodically so check back!) specify the characteristics of the palette you want and retrieve the palettes that match those criteria. Can specify by number of colors in the palette, type of palette (e.g., qualitative, sequential, etc.), or which LTER site the palette came from.
#' 
#' @param site Vector of three-letter LTER site abbreviations for which to return palettes
#' @param name Vector of palette names (if known) for which to return palettes
#' @param type Vector of palette types (e.g., qualitative, sequential, etc.) for which to return palettes
#' @param length Vector of acceptable palette lengths (i.e., how many colors are needed)
#' 
#' @return If more than one palette is a dataframe, if exactly one palette is a vector 
#' @export
#'
#' @examples
#' # Look at all palette options by calling the function without specifying arguments
#' lterpalettefinder::palette_finder()
#'
#' # What if our query returns NO options?
#' lter_palette_finder(length = 1)
#' 
#' # What if our query returns MULTIPLE options?
#' lter_palette_finder(length = 5, site = "HBR")
#' 
#' # What if our query returns JUST ONE option? (this is desirable)
#' lter_palette_finder(site = "AND")
#' 
palette_finder <- function(site = "all", name = "all", type = "all", length = "all"){
  
  # Get data
  palette_options <- system.file(c("extdata", "palette_options.csv"), package = "lterpalettefinder")
  
  # Handle unspecified arguments
  if(site == "all"){ site <- unique(palette_options$lter_site) }
  if(name == "all"){ name <- unique(palette_options$palette_name) }
  if(type == "all"){ type <- unique(palette_options$palette_type) }
  if(length == "all"){ length <- unique(palette_options$palette_length) }
  
  # Subset by each condition
  palt_v1 <- dplyr::filter(palette_options, lter_site %in% site)
  palt_v2 <- dplyr::filter(palt_v1, palette_name %in% name)
  palt_v3 <- dplyr::filter(palt_v2, palette_type %in% type)
  palt_v4 <- dplyr::filter(palt_v3, palette_length %in% length)
  
  # Remove color columns that have no entries in the given subset
  palt_v5 <- tidyr::pivot_longer(data = palt_v4, cols = dplyr::starts_with('color'),
                                 names_to = 'color_num', values_to = 'color_hex')
  palt_v6 <- dplyr::filter(palt_v5, nchar(color_hex) == 7)
  palt_v7 <- tidyr::pivot_wider(data = palt_v6, names_from = "color_num", values_from = "color_hex")
  
  # Make it a dataframe
  palt <- as.data.frame(palt_v7)
  
  # Return informative messages based on outcome
  if(nrow(palt) == 0){ print("No palette met the user-supplied conditions. Run function without specifying any arguments to see available palette options")
    return(palt) } else {
      
  if(nrow(palt) > 1){
    print("Multiple options returned as a dataframe. Consider specifying subset and re-running function.")
    return(palt) } else {
  
  if(nrow(palt == 1)){
    print("Exactly one palette identified. Output cropped to only HEX codes for ease of plotting")
    palt_simp <- as.vector(dplyr::select(.data = palt, dplyr::starts_with('color')))
    colnames(palt_simp) <- NULL
    return(palt_simp)
  } } } }