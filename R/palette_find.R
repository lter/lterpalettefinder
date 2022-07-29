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
#' lterpalettefinder::palette_find()
#'
#' # What if our query returns NO options?
#' palette_find(length = 1)
#' 
#' # What if our query returns MULTIPLE options?
#' palette_find(length = 10, site = "hbr")
#' 
#' # What if our query returns JUST ONE option? (this is desirable)
#' palette_find(name = "salamander")
#' 
palette_find <- function(site = "all", name = "all",
                         type = "all", length = "all"){
  
  # Error out if site/name/type are not characters (length can be character or numeric)
  if(!is.character(site) | !is.character(name) | !is.character(type))
    stop("Site, name, and type-if specified-must be characters")
  
  # Error out if site is too many characters
  if(!base::nchar(site) %in% c(3, 4))
    stop("Site must be three-letter abbreviation, 'all', or 'LTER' for the LTER logo palette")
  
  # Error out for inappropriate `length` specification
  if(is.na(suppressWarnings(as.numeric(length))) & length != "all")
    stop("Length must be 'all' or coercible to numeric")
  
  # Make sure casing is correct
  site_actual <- base::toupper(site)
  name_actual <- base::tolower(name)
  type_actual <- base::tolower(type)
  
  # Error out if palette type is unsupported
  if(!type_actual %in% c("all", "qualitative", "diverging", "sequential"))
    stop("Palette type unsupported. Use one of 'qualitative', 'diverging', 'sequential', or 'all'")
    
  # Retrieve data
  palette_options <- lterpalettefinder::palette_options
  
  # Identify maximum palette length
  max_length <- max(palette_options$palette_length, na.rm = TRUE)
  
  # If length is specified but no palettes match, return a message
  if(length != "all" & length > max_length){
    message("Maximum palette length is ", max_length, ". Length specification changed to this maximum value")
    length <- max_length }

  # Handle unspecified arguments
  if(site_actual == "ALL"){ site_actual <- base::unique(palette_options$lter_site) }
  if(name_actual == "all"){ name_actual <- base::unique(palette_options$palette_name) }
  if(type_actual == "all"){ type_actual <- base::unique(palette_options$palette_type) }
  if(length == "all"){ length <- base::unique(palette_options$palette_length) }
  
  # Subset by each condition
  palt_v1 <- dplyr::filter(palette_options, palette_options$lter_site %in% site_actual)
  palt_v2 <- dplyr::filter(palt_v1, palt_v1$palette_name %in% name_actual)
  palt_v3 <- dplyr::filter(palt_v2, palt_v2$palette_type %in% type_actual)
  palt_v4 <- dplyr::filter(palt_v3, palt_v3$palette_length %in% length)
  
  # Remove color columns that have no entries in the given subset
  ## Get all colors into a single column
  palt_v5 <- tidyr::pivot_longer(data = palt_v4, cols = dplyr::starts_with('color'), names_to = 'color_num', values_to = 'color_hex')
  ## Keep only 'colors' that are exactly 7 characters
  palt_v6 <- dplyr::filter(palt_v5, nchar(palt_v5$color_hex) == 7)
  ## Pivot back to wide format
  palt_v7 <- tidyr::pivot_wider(data = palt_v6, names_from = "color_num", values_from = "color_hex")
  
  # Make it a dataframe (rather than a tibble)
  palt <- as.data.frame(palt_v7)
  
  # Return informative messages based on outcome
  if(base::nrow(palt) == 0){
    base::message("No palette met the conditions. Run `palette_find()` to see all available palette options")
    return(palt) } else {
      
  if(base::nrow(palt) > 1){
    base::message("Multiple options returned as a dataframe. Consider identifying a specific palette's name and re-running function")
    return(palt) } else {
  
  if(base::nrow(palt == 1)){
    base::message("Exactly one palette identified. Output cropped to only HEX codes for ease of plotting")
    palt_simp <- base::as.character(dplyr::select(.data = palt, dplyr::starts_with('color')))
    base::colnames(palt_simp) <- NULL
    return(palt_simp)
  } } } }
