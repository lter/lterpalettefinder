#' @title Demonstrate Extracted Palette with HEX Labels
#' 
#' @description Accepts the hexadecimal code dataframe returned by `palette_extract()` and creates a simple plot of all returned colors labeled with their HEX codes. This will facilitate (hopefully) your selection of which of the 25 colors you would like to use in a given context.
#' 
#' @param palette One-column dataframe returned by `palette_extract()`
#' @param export Logical of whether or not to export the demo plot
#' @param export_name Character string of what to name exported plot
#' @param export_path File path to save exported plot (defaults to working directory)
#' 
#' @return A plot of the retrieved colors labeled with their HEX codes
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
palette_demo <- function(palette, export = FALSE,
                         export_name = "my_palette",
                         export_path = getwd()){
  
  # Strip out the hex codes to use as a vector later
  hexes <- base::as.vector(palette[,1])
  
  # If the user doesn't want to export the plot...
  if(export == FALSE) {
    # Just plot the colors
    base::plot(x = 1:base::nrow(palette),
               y = base::rep(x = c(1, 3, 5, 2, 4), times = 5),
               col = hexes, pch = 19, cex = 6,
               xlab = '', ylab = '',
               ylim = c(0.5, 5.5),
               xlim = c(-1, base::nrow(palette) + 1))
    # And add the hex codes on top of the colors
    graphics::text(x = 1:base::nrow(palette),
         y = rep(x = c(1, 3, 5, 2, 4), times = 5),
         labels = base::as.vector(palette[,1]), cex = 0.6)
  }
  
  # If the user does want to export, export it!
  if(export == TRUE){
    grDevices::jpeg(
      filename = base::file.path(export_path, base::paste0(export_name, ".jpg")),
         quality = 600, res = 1080,
         width = 4, height = 4, units = 'in')
    # Just plot the colors
    base::plot(x = 1:nrow(palette),
               y = rep(x = c(1, 3, 5, 2, 4), times = 5),
               col = hexes, pch = 19, cex = 6,
               xlab = '', ylab = '',
               ylim = c(0.5, 5.5),
               xlim = c(-1, nrow(palette) + 1))
    # And add the hex codes on top of the colors
    graphics::text(x = 1:base::nrow(palette),
                   y = rep(x = c(1, 3, 5, 2, 4), times = 5),
                   labels = base::as.vector(palette[,1]), cex = 0.6)
    # And dev.off out
    grDevices::dev.off()
  }
}
