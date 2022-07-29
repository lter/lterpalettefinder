#' @title Demonstrate Extracted Palette with HEX Labels - ggplot2 Edition
#' 
#' @description Accepts the hexadecimal code vector returned by `palette_extract()`, `..._sort()`, or `..._subsample()` and creates a simple plot of all returned colors labeled with their HEX codes. This will facilitate (hopefully) your selection of which of the 25 colors you would like to use in a given context.
#' 
#' @param palette (character) Vector of hexadecimal codes returned by `palette_extract()`, `..._sort()`, or `..._subsample()`
#' 
#' @return A ggplot2 plot
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
palette_ggdemo <- function(palette){
  # Squelch no visible bindings warning
  x <- y <- NULL
  
  # Check if palette is using the correct format
  palette_check(palette)
  
  # Identify number of colors
  palette_length <- base::length(palette)
  
  # Make dataframe
  gg_df <- base::data.frame(
    x = base::as.factor(1:palette_length),
    y = base::rep(x = 1, times = palette_length))
  
  # Plot it
  ggplot2::ggplot(gg_df, ggplot2::aes(x = x, y = y, fill = x)) +
    ggplot2::geom_bar(stat = 'identity') +
    ggplot2::scale_fill_manual(values = palette) +
    ggplot2::geom_text(label = palette, y = 0.5, angle = 90) +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position = 'none',
                   axis.text = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank())
}
