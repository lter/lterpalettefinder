#' @title Check Hexadecimal Code Formatting
#'
#' @description Accepts the hexadecimal code vector and tests if it is formatted correctly
#' 
#' @param palette (character) Vector of hexadecimal codes returned by `palette_extract()`, `..._sort()`, or `..._subsample()`
#' 
#' @return An error message or nothing
#' @export
#'
#' @examples
#' # Check for misformatted hexcodes
#' palette_check(palette = c("#8e847a", "#9fc7f2"))
palette_check <- function(palette){

  # Check if palette is a character vector
  if(!is.character(palette))
    stop("A character vector was expected")
  
  # Check if any palettes have too many/few characters
  if(sum(nchar(palette) != 7) > 0)
    stop("Hexadecimal codes must be 7 digits (including the '#')")
  
  # Check if you have correct hexadecimal codes
  if(sum(!grepl('^#[A-Fa-f0-9]{6}$', palette)) > 0)
    stop("Some hexadecimal codes are not correctly formatted")
}
