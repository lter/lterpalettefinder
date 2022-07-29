#' @title Randomly Subsample HEX Codes
#' 
#' @description Randomly subsample the HEX codes returned by `palette_extract()` or `palette_sort()` to desired length. Can also set random seed for reproducibility.
#' 
#' @param palette (character) Vector of hexadecimal codes like those returned by `palette_extract()` or `palette_sort()`
#' @param wanted (numeric) Integer for how many colors should be returned
#' @param random_seed (numeric) Integer for `base::set.seed()`
#' 
#' @return (character) Vector of hexadecimal codes of user-specified length
#' 
#' @export
#'
#' @examples
#' # Extract colors from a supplied image
#' my_colors <- palette_extract(image = system.file("extdata", "lyon-fire.png",
#' package = "lterpalettefinder"))
#'        
#' # Plot that result
#' palette_ggdemo(palette = my_colors)
#' 
#' # Now randomly subsample
#' random_colors <- palette_subsample(palette = my_colors, wanted = 5)
#' 
#' # And plot again to show change
#' palette_ggdemo(palette = random_colors)
#'
# Make it a function
palette_subsample <- function(palette, wanted = 5,
                              random_seed = 36){
  
  # Check if palette is using the correct format
  palette_check(palette)
  
  # Error out if wanted is not coercible to numeric
  if(!is.numeric(wanted) & is.na(suppressWarnings(as.numeric(wanted))))
    stop("`wanted` must be numeric or coercible to numeric")
  
  # Error out if random_seed is not coercible to numeric
  if(!is.numeric(random_seed) & is.na(suppressWarnings(as.numeric(random_seed))))
    stop("`random_seed` must be numeric or coercible to numeric")
  
  # If more are specified than there are elements of vector, error out
  if(wanted > base::length(palette)) stop('More colors requested than are found in original vector. Re-sampling is not supported')
  
  # Set seed
  base::set.seed(seed = random_seed)
  
  # Sample provided vector
  picked <- base::as.character(base::sample(x = palette, size = wanted))
  
  # Return that vector
  return(picked)
}
