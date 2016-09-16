#' @title Get from mesh code to latitude and longitude
#' @param code numeric. mesh code
#' @author Akio Takenaka
#' @details http://takenaka-akio.org/etc/j_map/index.html
#' @export
#' @examples
#' \dontrun{
#' meshcode_to_latlong(64414277)
#' }
meshcode_to_latlon <- function(code) {
  code <- as.character(code)
  lat_width  <- 2 / 3
  long_width <- 1
  
  if (length(grep("^[0-9]{4}", code)) == 1) { # 一次メッシュ以上
    code12 <- as.numeric(substring(code, 1, 2))
    code34 <- as.numeric(substring(code, 3, 4))
  }
  else {
    return(NULL)
  }
  
  if (length(grep("^[0-9]{6}", code)) == 1) { # 二次メッシュ以上
    code5 <- as.numeric(substring(code, 5, 5))
    code6 <- as.numeric(substring(code, 6, 6))
    lat_width  <- lat_width / 8;
    long_width <- long_width / 8;
  }
  
  if (length(grep("^[0-9]{8}", code)) == 1) { # 三次メッシュ
    code7 <- as.numeric(substring(code, 7, 7))
    code8 <- as.numeric(substring(code, 8, 8))
    lat_width  <- (lat_width / 10) / 2; # 割る２を忘れないこと
    long_width <- (long_width / 10) / 2;
  }
  
  # 以下、南西コーナーの座標を求める。
  
  lat  <- code12 * 2 / 3;          #  一次メッシュ
  long <- code34 + 100;
  
  if (exists("code5") && exists("code6")) {  # 二次メッシュ
    lat  <- lat  + (code5 * 2 / 3) / 8;
    long <- long +  code6 / 8;
  }
  if (exists("code7") && exists("code8")) {  # 三次メッシュ
    lat  <- lat  + (code7 * 2 / 3) / 8 / 10;
    long <- long +  code8 / 8 / 10;
  }
  
  lat  <- sprintf("%.8f", lat); 
  long <- sprintf("%.8f", long);
  
  x <- data.frame(lat        = as.numeric(lat), 
                  long       = as.numeric(long), 
                  lat_error  = as.numeric(lat_width),
                  long_error = as.numeric(long_width))

  return(x)
}