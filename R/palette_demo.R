#' @title Demonstrate Extracted Palette with HEX Labels - Base Plot Edition
#' 
#' @description Accepts the hexadecimal code vector returned by `palette_extract()`, `..._sort()`, or `..._subsample()` and 
#'    creates a base plot of all returned colors labeled with their HEX codes. This will facilitate (hopefully) your selection of 
#'    which of the 25 colors you would like to use in a given context.
#'    
#' @param palette (character) Vector of hexadecimal codes like that returned by `palette_extract()`, `..._sort()`, or `..._subsample()`
#' @param export (logical) Whether or not to export the demo plot
#' @param export_name (character) Name for exported plot
#' @param export_path (character) File path to save exported plot (defaults to working directory)
#' 
#' @return A plot of the retrieved colors labeled with their HEX codes
#' 
#' @export
#'
#' @examples
#' # Extract colors from a supplied image
#' my_colors <- palette_extract(
#'    image = system.file("extdata", "lyon-fire.png", package = "lterpalettefinder")
#'    )
#'        
#' # Plot that result
#' palette_demo(palette = my_colors)
#' 
palette_demo <- function(palette, export = FALSE,
                         export_name = "my_palette",
                         export_path = getwd()){
  
  # Check if palette is using the correct format
  palette_check(palette)
  
  # Reject palettes longer than 25
  if(base::length(palette) > 25) stop("More than 25 colors is unsupported by this function. Give this function no more than 25 HEX codes or use `palette_ggdemo()` which will accept any number of colors")
  
  # If the user doesn't want to export the plot...
  if(export == FALSE) {
    # Just plot the colors
    base::plot(x = 1:base::length(palette),
               y = base::rep(x = c(1, 3, 5, 2, 4),
                             times = 5)[1:base::length(palette)],
               col = palette, pch = 19, cex = 6,
               xlab = '', ylab = '',
               xaxt = "n", yaxt = "n",
               ylim = c(0.5, 5.5),
               xlim = c(-1, base::length(palette) + 1))
    # And add the hex codes on top of the colors
    graphics::text(x = 1:base::length(palette),
         y = rep(x = c(1, 3, 5, 2, 4),
                 times = 5)[1:base::length(palette)],
         labels = palette, cex = 0.6)
  }
  
  # If the user does want to export, export it!
  if(export == TRUE){
    grDevices::jpeg(
      filename = base::file.path(export_path,
                                 base::paste0(export_name, ".jpg")),
         quality = 600, res = 1080,
         width = 4, height = 4, units = 'in')
    # Plot the colors
    base::plot(x = 1:base::length(palette),
               y = base::rep(x = c(1, 3, 5, 2, 4),
                             times = 5)[1:base::length(palette)],
               col = palette, pch = 19, cex = 6,
               xlab = '', ylab = '',
               xaxt = "n", yaxt = "n",
               ylim = c(0.5, 5.5),
               xlim = c(-1, base::length(palette) + 1))
    # And add the hex codes on top of the colors
    graphics::text(x = 1:base::length(palette),
                   y = rep(x = c(1, 3, 5, 2, 4),
                           times = 5)[1:base::length(palette)],
                   labels = palette, cex = 0.6)
    # And dev.off out
    grDevices::dev.off()
  }
}
