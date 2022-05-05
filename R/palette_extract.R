#' @title Extract Hexadecimal Codes from an Image
#' 
#' @description Retrieves hexadecimal codes for the colors in an image file. Currently only .PNG files are supported. The function automatically removes dark colors and removes 'similar' colors to yield 25 colors from which you can select the subset that works best for your visualization needs. Note that photos that are very dark may return few viable colors.
#' 
#' @param image Name/path to .PNG file to extract colors from (only .PNGs are supported at this time)
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
#' # my_colors <- palette_extract(image = file.path("Path", "to", "picture.png"),
#' #  progress_bar = TRUE)
#' 
#' ## Look at the returned HEX codes
#' # my_colors
#'        
#' 
palette_extract <- function(image, progress_bar = TRUE){
  # To squelch error in variable bindings, call all unquoted variables as NULL
  rawRGB <- red <- green <- blue <- NULL
  
  # Warning for unsupported image type(s)
  if (stringr::str_detect(string = image, pattern = ".png") == 
      FALSE) {
    print("PNG suffix not detected in `image` argument. File may not be a .PNG. Please check that file is in PNG format and specify the suffix.")
  } else {
    
    # Read picture
    if (progress_bar == TRUE) {print("{=         }")} # 1
    pic <- png::readPNG(source = image, native = FALSE)
    
    # Extract RGB channels
      if (progress_bar == TRUE) {print("{==        }")} # 2
    rawR <- base::as.integer(pic[,,1] * 255)
    rawG <- base::as.integer(pic[,,2] * 255)
    rawB <- base::as.integer(pic[,,3] * 255)
    
    # Put them into a dataframe
    if (progress_bar == TRUE) {print("{===       }")} # 3
    rgb_v1 <- base::data.frame(red = rawR, green = rawG, blue = rawB)
    
    # Subset out very dark colors
    if (progress_bar == TRUE) {print("{====      }")} # 4
    rgb_v2 <- dplyr::filter(.data = rgb_v1,
                            red >= 65 & green >= 65 & blue >= 65)
    
    # Return only unique values
    if (progress_bar == TRUE) {print("{=====     }")} # 5
    rgb_v3 <- base::unique(rgb_v2)
    
    # Do k-means clustering on these values
    if (progress_bar == TRUE) {print("{======    }")} # 6
    rgb_v4 <- base::as.data.frame(
      base::suppressWarnings(
        stats::kmeans(x = rgb_v3, centers = 25,
                      iter.max = 100, nstart = 1)$centers))
    
    # Turn them into integers (instead of continuous numbers)
    if (progress_bar == TRUE) {print("{=======   }")} # 7
    rgb_v5 <- rgb_v4 %>%
      dplyr::mutate(red = base::as.integer(red),
                    green = base::as.integer(green),
                    blue = base::as.integer(blue))
    
    # Coerce them into hexadecimals
    if (progress_bar == TRUE) {print("{========  }")} # 8
    hexR <- base::as.hexmode(rgb_v5$red)
    hexG <- base::as.hexmode(rgb_v5$green)
    hexB <- base::as.hexmode(rgb_v5$blue)
    
    # Bind hexadecimals into HEX codes
    if (progress_bar == TRUE) {print("{========= }")} # 9
    hex_vec <- base::paste0('#', base::as.character(hexR),
                            base::as.character(hexG),
                            base::as.character(hexB))
    
    # Return only unique values to the user
    if (progress_bar == TRUE) {print("{==========}")} # 10
    hex_out <- base::data.frame(hex_code = base::unique(hex_vec))
    } }
