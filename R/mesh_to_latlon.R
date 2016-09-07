#' Get from mesh code to latitude and longitude
#' @param code
#' @param location default Center
#' @author Akio Takenaka
#' @details http://takenaka-akio.org/etc/j_map/index.html
#' @examples
#' mesh_to_latlon(584385)
mesh_to_latlon <- function (code, location = "Center") {
  code <- as.character(code) # コードを数値に
  
  if (length(grep("^[0-9]{4}", code)) == 1) # 0から9の値を４つ以上含んでいるか
    {
    code12 <- as.numeric(substring(code, 1, 2)) # 頭から２文字を取り出す
    code34 <- as.numeric(substring(code, 3, 4)) # 頭から３，４文字目を取り出す
    lat_width  <- 2 / 3 # 0.6666667
    long_width <- 1
  }
  else {
    return(NULL)
  }
  
  if (length(grep("^[0-9]{6}", code)) == 1) {
    code5 <- as.numeric(substring(code, 5, 5))
    code6 <- as.numeric(substring(code, 6, 6))
    lat_width  <- lat_width / 8 # 0.08333333
    long_width <- long_width / 8 # 0.125
  }
  
  if (length(grep("^[0-9]{8}", code)) == 1) {
    code7 <- as.numeric(substring(code, 7, 7))
    code8 <- as.numeric(substring(code, 8, 8))
    lat_width  <- lat_width / 10;
    long_width <- long_width / 10;
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
  
  if (location == "Center") {   # 中央の座標
    lat  <-  lat  + lat_width  / 2;
    long <-  long + long_width / 2;
  }
  if (length(grep("N", location)) == 1) {   # 北端の座標
    lat  <- lat  + lat_width;
  }
  if (length(grep("E", location) == 1)) {   # 東端の座標
    long <- long +long_width;
  }
  
  lat  <- sprintf("%.8f", lat);  # 小数点以下８桁まで。
  long <- sprintf("%.8f", long);
  
  x <- list(as.numeric(lat), as.numeric(long))
  names(x) <- c("lat", "long")
  
  return (x)
}