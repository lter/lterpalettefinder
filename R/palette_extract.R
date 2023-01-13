#' @title Extract Hexadecimal Codes from an Image
#' 
#' @description Retrieves hexadecimal codes for the colors in an image file. Currently only PNG, JPEG, TIFF, and HEIC files are supported. The function automatically removes dark colors and removes 'similar' colors to yield 25 colors from which you can select the subset that works best for your visualization needs. Note that photos that are very dark may return few viable colors.
#' 
#' @param image (character) Name/path to PNG, JPEG, TIFF, or HEIC file from which to extract colors
#' @param sort (logical) Whether extracted HEX codes should be sorted by hue and saturation
#' @param progress_bar (logical) Whether to `message` a progress bar
#' 
#' @return (character) Vector containing all hexadecimal codes remaining after extraction and removal of 'dark' and 'similar' colors
#' 
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' # Extract colors from a supplied image
#' my_colors <- palette_extract(image = system.file("extdata", "lyon-fire.png",
#' package = "lterpalettefinder"), sort = TRUE, progress_bar = FALSE)
#'        
#' # Plot that result
#' palette_demo(palette = my_colors)
#' 
palette_extract <- function(image, sort = FALSE, progress_bar = TRUE){
  # To squelch error in variable bindings, call all unquoted variables as NULL
  red <- green <- blue <- NULL
  
  # Error for unspecified file suffix
  if(!tools::file_ext(image) %in% c("png", "jpg", "jpeg", "tiff", "heic") &
     nchar(tools::file_ext(image)) == 0) stop('No file suffix specified')
  
  # Error for unsupported image type(s)
  if(!tools::file_ext(image) %in% c("png", "jpg", "jpeg", "tiff", "heic") &
     nchar(tools::file_ext(image)) != 0) stop('Only PNG, JPG, TIFF, and HEIC files are accepted. Please convert your image to one of these and re-run')
  
  if (progress_bar == TRUE) { base::message("{=         }") } # 1
  # Read file in with file type-appropriate function
  if(tools::file_ext(image) == "png"){
    pic <- png::readPNG(source = image, native = FALSE) }
  if(tools::file_ext(image) == "jpg" |
     tools::file_ext(image) == "jpeg"){
    pic <- jpeg::readJPEG(source = image, native = FALSE) }
  if(tools::file_ext(image) == "tiff"){
    pic <- tiff::readTIFF(source = image, native = FALSE) }
  if(tools::file_ext(image) == "heic"){
    # Read HEIC
    heic_temp <- magick::image_read(path = image)
    # Identify path to create temp file
    temp_image <- base::file.path(base::tempdir(), "temp-heic-transform.png")
    # Write as temporary PNG
    magick::image_write(image = heic_temp, format = "png", path = temp_image)
    # Read in that temporary file
    pic <- png::readPNG(source = temp_image, native = FALSE) 
    # Delete the temporary file
    base::unlink(x = temp_image, recursive = FALSE, force = FALSE) }
  
  # Extract RGB channels
  if (progress_bar == TRUE) {base::message("{==        }")} # 2
  rawR <- base::as.integer(pic[,,1] * 255)
  rawG <- base::as.integer(pic[,,2] * 255)
  rawB <- base::as.integer(pic[,,3] * 255)
  
  # Put them into a dataframe
  if (progress_bar == TRUE) {base::message("{===       }")} # 3
  rgb_v1 <- base::data.frame("red" = rawR, "green" = rawG, "blue" = rawB)
  
  # Subset out very dark colors (i.e., those with RGB values all below a threshold)
  if (progress_bar == TRUE) {base::message("{====      }")} # 4
  rgb_v2 <- rgb_v1 %>%
    dplyr::filter(!(red < 65 & green < 65 & blue < 65))
  
  # Return only unique values
  if (progress_bar == TRUE) {base::message("{=====     }")} # 5
  rgb_v3 <- base::unique(rgb_v2)
  
  # If >25 colors, do k-means clustering on these RGB values
  if (progress_bar == TRUE) {base::message("{======    }")} # 6
  ## More than 25 colors
  if(nrow(rgb_v3) > 25){
    rgb_v4 <- base::as.data.frame(
      base::suppressWarnings(
        stats::kmeans(x = rgb_v3, centers = 25,
                      iter.max = 100, nstart = 1)$centers)) }
  ## Fewer than 25 colors
  if(nrow(rgb_v3) <= 25){ rgb_v4 <- rgb_v3 }
  
  # Turn them into integers (instead of continuous numbers)
  if (progress_bar == TRUE) {base::message("{=======   }")} # 7
  rgb_v5 <- rgb_v4 %>%
    dplyr::mutate(red = base::as.integer(red),
                  green = base::as.integer(green),
                  blue = base::as.integer(blue))
  
  # Coerce them into hexadecimals
  if (progress_bar == TRUE) {base::message("{========  }")} # 8
  hexR <- base::as.character(base::as.hexmode(rgb_v5$red))
  hexG <- base::as.character(base::as.hexmode(rgb_v5$green))
  hexB <- base::as.character(base::as.hexmode(rgb_v5$blue))
  
  # Handle dropping of leading zero for integers <15 (i.e., one-digit hexadecimals)
  hexR_fix <- base::ifelse(test = base::nchar(hexR) == 1,
                           yes = paste0("0", hexR), no = hexR)
  hexG_fix <- base::ifelse(test = base::nchar(hexG) == 1,
                           yes = paste0("0", hexG), no = hexG)
  hexB_fix <- base::ifelse(test = base::nchar(hexB) == 1,
                           yes = paste0("0", hexB), no = hexB)
  
  # Bind hexadecimals into HEX codes
  if (progress_bar == TRUE) {base::message("{========= }")} # 9
  hex_vec <- base::paste0('#', hexR_fix, hexG_fix, hexB_fix)
  
  # Return only unique values to the user
  hexes <- base::data.frame(hex_code = base::unique(hex_vec))
  
  # Make it a vector
  hex_vec <- base::as.character(hexes$hex_code)
  
  # If sorting is not requested, return unsorted vec
  if(sort == FALSE){ 
    return(hex_vec) 
  } else { 
    
    # Otherwise sort the output colors
    if (progress_bar == TRUE) {base::message("Sorting colors")}
    hex_sort <- lterpalettefinder::palette_sort(palette = hex_vec)
    return(hex_sort)
  }
  
  # Complete progress bar
  if (progress_bar == TRUE) {base::message("{==========}")} # 10
}
