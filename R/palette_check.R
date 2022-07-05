
#' Check if a palette is using the correct format
#'
#' @description Accepts the hexadecimal code vector and test if it is of the correct format
#' 
#' @param palette Vector of hexadecimal codes returned by `palette_extract()`, `..._sort()`, or `..._subsample()`
#' 
#'
#' @return An error message or nothing
#' @export
#'
#' @examples
#' # Check for misformatted hexcodes
#' \dontrun{
#' palette_check(c("#8e847a", "#9fc7f2g3"))
#' }
palette_check <- function(palette){

  # Check if palette is a character
  if(!is.character(palette)) {
    stop("A character vector was expected")
  }
  
  # Check if you have correct hexadecimal codes
  if(sum(!grepl('^#[A-Fa-f0-9]{6}$', palette)) > 0){
    if(sum(!grepl('^#[A-Fa-f0-9]{8}$', palette)) > 0){
      stop("Some hexadecimal codes are not correctly formatted")
    }
  }
}