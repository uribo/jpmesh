#' @title Convert from coordinate to mesh code
#' 
#' @description From coordinate to mesh codes.
#' @param lat numeric. latitude
#' @param long numeric. longitude
#' @param order integer. mesh type
#' @return mesh code (default 3rd meshcode)
#' @author Akio Takenaka
#' @details http://takenaka-akio.org/etc/j_map/index.html
#' @examples 
#' latlong_to_meshcode(43.06462, 141.3468, order = 3)
#' latlong_to_meshcode(35.68949, 139.6917, order = 2)
#' @export
latlong_to_meshcode <- function(lat = NULL, long = NULL, order = 3)
{
  if (length(grep("[123]", order)) == 0) {
    return(NULL)
  }
  
  if (eval_jp_boundary(long, lat) == FALSE) {
    stop("Latitude / Longitude value is out of range.")
  } 
  
# Latitude ----------------------------------------------------------------
  lat_in_min <- lat * 60
  
  code12 <- as.integer(lat_in_min / 40)
  lat_rest_in_min <- lat_in_min - code12 * 40
  
  code5 <- as.integer(lat_rest_in_min / 5 )
  lat_rest_in_min <- lat_rest_in_min - code5 * 5
  
  code7 <- as.integer(lat_rest_in_min / (5 / 10))

# Longitude ---------------------------------------------------------------
  code34 <- as.integer(long) - 100
  long_rest_in_deg <- long - as.integer(long)
  
  code6 <- as.integer(long_rest_in_deg * 8)
  long_rest_in_deg <- long_rest_in_deg - code6 / 8
  
  code8 <- as.integer(long_rest_in_deg / (1/80))
  
  code <- sprintf("%02d%02d", code12, code34)
  
  if (order >= 2) {
    code <- sprintf("%s%01d%01d", code, code5, code6)
  }
  if (order >= 3) {
    code <- sprintf("%s%01d%01d", code, code7, code8)
  }
  
  return(as.numeric(code))
}

#' @title Convert from coordinate to separate mesh code
#' 
#' @description From coordinate to mesh codes.
#' @param lat numeric. latitude
#' @param long numeric. longitude
#' @param order choose character harf or quarter
#' @importFrom dplyr mutate
#' @return separate meshcode
#' @examples 
#' latlong_to_sepate_mesh(35.442788, 139.301255, order = "harf")
#' latlong_to_sepate_mesh(35.442893, 139.310654, order = "quarter")
#' latlong_to_sepate_mesh(35.448767, 139.301706, order = "quarter")
#' latlong_to_sepate_mesh(35.449011, 139.311340, order = "quarter")
#' @export
latlong_to_sepate_mesh <- function(lat = NULL, long = NULL, order = c("harf", "quarter")) {
  mesh8 <- latlong_to_meshcode(lat, long, order = 3)
  
  df.mesh <- meshcode_to_latlon(mesh8) %>% 
    bundle_mesh_vars()
  
    if (lat >= df.mesh$lat_center) {
      if (long >= df.mesh$long_center) {
        mesh9 <- 4
      } else {
        mesh9 <- 3
      } 
    } else {
      if (long >= df.mesh$long_center) {
        mesh9 <- 2
      } else {
        mesh9 <- 1
      }
    }
    
  if (order == "harf") {
    res <- paste0(mesh8, mesh9)
  } else {
    
    if (lat >= df.mesh$lat_center - (df.mesh$lat_error / 2)) {
      if (long >= df.mesh$long_center  - (df.mesh$long_error / 2)) {
        mesh10 <- 4
      } else {
        mesh10 <- 3
      } 
    } else {
      if (long >= df.mesh$long_center  - (df.mesh$long_error / 2)) {
        mesh10 <- 2
      } else {
        mesh10 <- 1
      }
    }
    
    if (order == "quarter") {
      res <- paste0(mesh8, mesh9, mesh10)
    }
  }

  res <- as.numeric(res)
  
  return(res)
}
