#' @title Extract Hexadecimal Codes from an Image
#' 
#' @description Retrieves hexadecimal codes for the colors in an image file. Currently only .PNG files are supported. The function automatically removes dark colors and removes 'similar' colors to yield 25 colors from which you can select the subset that works best for your visualization needs. Note that photos that are very dark may return few viable colors.
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
  rawRGB <- red <- green <- blue <- NULL
  
  # Warning for unsupported image type(s)
  if (stringr::str_detect(string = image, pattern = ".png") == 
      FALSE) {
    print("PNG suffix not detected in `image` argument. File may not be a .PNG. Please check that file is in PNG format and specify the suffix.")
  } else {
    
    
    # Read picture
    if (progress_bar == TRUE) {print("{=          }")} # 1
    pic <- png::readPNG(source = image, native = FALSE)
    
    # Extract RGB channels
    if (progress_bar == TRUE) {print("{==         }")} # 2
    rawR <- base::as.integer(pic[,,1] * 255)
    rawG <- base::as.integer(pic[,,2] * 255)
    rawB <- base::as.integer(pic[,,3] * 255)
    
    # Combine them into a single column
    if (progress_bar == TRUE) {print("{===        }")} # 3
    rgb_v1 <- base::data.frame(rawRGB = base::paste0(rawR, ';', rawG, ';', rawB))
    
    # Keep only unique values of that column
    if (progress_bar == TRUE) {print("{====       }")} # 4
    rgb_v2 <- base::unique(rgb_v1)
    
    # Separate the large column into better, separate columns
    if (progress_bar == TRUE) {print("{=====      }")} # 5
    rgb_v3 <- tidyr::separate(data = rgb_v2, col = rawRGB, sep = ';',
                              into = c('red', 'green', 'blue') )
    
    # Drop colors in the darkest 25% (i.e., < 65)
    if (progress_bar == TRUE) {print("{======     }")} # 6
    rgb_v4 <- dplyr::filter(.data = rgb_v3,
                            base::as.integer(red) >= 65 &
                              base::as.integer(green) >= 65 &
                              base::as.integer(blue) >= 65)
    
    # Do k-means clustering on these values
    if (progress_bar == TRUE) {print("{=======    }")} # 7
    rgb_v5 <- base::as.data.frame(
      base::suppressWarnings(
        stats::kmeans(x = rgb_v4, centers = 25,
                      iter.max = 100, nstart = 1)$centers))
    
    # Turn them into integers (instead of continuous numbers)
    if (progress_bar == TRUE) {print("{========   }")} # 8
    rgb_v6 <- rgb_v5 %>%
      dplyr::mutate(red = base::as.integer(red),
                    green = base::as.integer(green),
                    blue = base::as.integer(blue))
    
    # Coerce them into hexadecimals
    if (progress_bar == TRUE) {print("{=========  }")} # 9
    hexR <- base::as.hexmode(rgb_v6$red)
    hexG <- base::as.hexmode(rgb_v6$green)
    hexB <- base::as.hexmode(rgb_v6$blue)
    
    # Bind hexadecimals into HEX codes
    if (progress_bar == TRUE) {print("{========== }")} # 10
    hex_vec <- base::paste0('#', base::as.character(hexR),
                            base::as.character(hexG),
                            base::as.character(hexB))
    
    # Return only unique values to the user
    if (progress_bar == TRUE) {print("{===========}")} # 11
    hex_out <- base::data.frame(hex_code = base::unique(hex_vec))
    } }
