#' @author Akio Takenaka
#' @details http://takenaka-akio.org/etc/j_map/index.html
latlon_to_mesh <- function(lat, long, order = 3)
{
  if (length(grep("[123]", order)) == 0) {
    return (NULL)
  }
  
  # Latitude
  
  lat_in_min <- lat * 60
  
  code12 <- as.integer(lat_in_min / 40)
  lat_rest_in_min <- lat_in_min - code12 * 40
  
  code5 = as.integer(lat_rest_in_min / 5 ); # 二次メッシュの１区画は緯度５分。
  lat_rest_in_min <- lat_rest_in_min - code5 * 5
  
  code7 <- as.integer(lat_rest_in_min / (5 / 10))
  
  # Longitude
  
  code34 <- as.integer(long) - 100
  long_rest_in_deg <- long - as.integer(long)
  
  code6 <- as.integer(long_rest_in_deg * 8)
  long_rest_in_deg <- long_rest_in_deg - code6 / 8
  
  code8 <- as.integer(long_rest_in_deg / (1/80) )
  
  code <- sprintf("%02d%02d", code12, code34)
  
  if (order >= 2) {
    code <- sprintf("%s%01d%01d", code, code5, code6)
  }
  if (order >= 3) {
    code <- sprintf("%s%01d%01d", code, code7, code8)
  }
  
  return (as.numeric(code))
}
