#' @title Get from mesh code to latitude and longitude
#' 
#' @description mesh centroid
#' @param code numeric. mesh code
#' @author Akio Takenaka
#' @details http://takenaka-akio.org/etc/j_map/index.html
#' @examples
#' meshcode_to_latlon(64414277)
#' @export
meshcode_to_latlon <- function(code) {
  
  code <- as.character(code)
  
  # 80km mesh
  if (length(grep("^[0-9]{4}", code)) == 1) {
    code12 <- as.numeric(substring(code, 1, 2))
    code34 <- as.numeric(substring(code, 3, 4))
    lat_width  <- 2 / 3
    long_width <- 1
  }
  else {
    return(NULL)
  }
  
  # 10km mesh
  if (length(grep("^[0-9]{6}", code)) == 1) {
    code5 <- as.numeric(substring(code, 5, 5))
    code6 <- as.numeric(substring(code, 6, 6))
    lat_width  <- lat_width / 8
    long_width <- long_width / 8
  }
  
  # 1km mesh
  if (length(grep("^[0-9]{8}", code)) == 1) {
    code7 <- as.numeric(substring(code, 7, 7))
    code8 <- as.numeric(substring(code, 8, 8))
    lat_width  <- lat_width / 10
    long_width <- long_width / 10
  }
  
  lat  <- code12 * 2 / 3
  long <- code34 + 100
  
  if (exists("code5") && exists("code6")) {
    lat  <- lat  + (code5 * 2 / 3) / 8
    long <- long +  code6 / 8
  }
  if (exists("code7") && exists("code8")) {
    lat  <- lat  + (code7 * 2 / 3) / 8 / 10
    long <- long +  code8 / 8 / 10
  }
  
  lat.c  <- lat  + lat_width  / 2
  long.c <- long + long_width / 2
  
  lat.c  <- as.numeric(sprintf("%.10f", lat.c)) 
  long.c <- as.numeric(sprintf("%.10f", long.c))
  
  res <- data.frame(lat_center  = lat.c, 
                    long_center = long.c, 
                    lat_error   = lat.c - lat,
                    long_error  = long.c - long)
  
  return(res)
}
