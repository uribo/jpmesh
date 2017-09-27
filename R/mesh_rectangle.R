#' @title mesh rectangle check
#' 
#' @description Multiple mesh coverd area.
#' @param df data.frame
#' @param code mesh code
#' @param view option.
#' @import dplyr
#' @import leaflet
#' @importFrom purrr map
#' @importFrom tidyr unnest
#' @importFrom magrittr set_colnames
#' @importFrom tibble rownames_to_column
#' @examples 
#' \dontrun{
#' mesh_rectangle(data.frame(mesh_code = 6041,
#' lat_center = 40.3333333333,
#' long_center = 141.5,
#' lat_error =  0.33,
#' long_error = 0.5), "mesh", view = FALSE)
#' }
#' @name mesh_rectangle
#' @export
mesh_rectangle <- function(df, code = "mesh_code", view = FALSE) {
  
  mesh_code <- NULL
  
  mesh_separate2half <- function(mesh_code) {
    last_meshcode <- substr(mesh_code, nchar(mesh_code), nchar(mesh_code))
    d <- meshcode_to_latlon(mesh_code)
    
    if (last_meshcode == "1") {
      res <- data.frame(
        lat_center = d$lat_center - d$lat_error / 2,
        long_center = d$long_center - d$long_error / 2
      )
    } else if (last_meshcode == "2") {
      res <- data.frame(
        lat_center = d$lat_center - d$lat_error / 2,
        long_center = d$long_center + d$long_error / 2
      )
    } else if (last_meshcode == "3") {
      res <- data.frame(
        lat_center = d$lat_center + d$lat_error / 2,
        long_center = d$long_center - d$long_error / 2
      )
    } else if (last_meshcode == "4") {
      res <- data.frame(
        lat_center = d$lat_center + d$lat_error / 2,
        long_center = d$long_center + d$long_error / 2
      )
    }
    
    res <- res %>% 
      dplyr::mutate(lat_error = d$lat_error / 2,
                    long_error = d$long_error / 2)
    
    return(res)
  }
  
  df.mesh <- df %>% 
    dplyr::select(mesh_code) %>% 
    unique() %>% 
    magrittr::set_colnames(c("mesh_code")) %>% 
    dplyr::mutate(mesh_area = purrr::map(mesh_code, mesh_separate2half)) %>% 
    tidyr::unnest() %>% 
    bundle_mesh_vars() %>% 
    tibble::rownames_to_column()
  
  if (view != TRUE) {
    
    res <- df.mesh
  } else {
    
    map.mesh <- leaflet() %>% 
      addTiles() %>% 
      addRectangles(data = df.mesh,
                    lng1 = df.mesh$lng1, lat1 = df.mesh$lat1,
                    lng2 = df.mesh$lng2, lat2 = df.mesh$lat2)
    
    res <- list(data = df.mesh, 
                map  = map.mesh)
  }
  
  return(res)
}
#' Rectange mesh grid area
#' 
#' @description Single mesh coverd area.
#' @param code mesh code
#' @param order mesh order
#' @importFrom dplyr mutate
#' @importFrom tibble rownames_to_column
#' @examples 
#' mesh_area(523504221, order = "harf")
#' @name mesh_area
#' @export
mesh_area <- function(code, order = c("harf", "quarter", "eight")) {

  if (nchar(code) < 8) {
    stop("The code must be 8 digits or more.")
  } 
  
  if (is.null(order) == FALSE) {
    order = "harf"
  }
  
  d <- meshcode_to_latlon(code) %>% 
    bundle_mesh_vars()
  
  # 500m mesh
  if (length(grep("^[0-9]{9}", code)) == 1) {
    code9 <- as.numeric(substring(code, 9, 9))
  }
  
  # 250m mesh
  if (length(grep("^[0-9]{10}", code)) == 1) {
    code10 <- as.numeric(substring(code, 10, 10))
  }
  
  # 125m mesh
  if (length(grep("^[0-9]{11}", code)) == 1) {
    code11 <- as.numeric(substring(code, 11, 11))
  }
  
  if (order == "harf") {
    res <- mesh_harf(d, code9)
  }
  
  if (order == "quarter") {
    res <- mesh_to_latlon2(mesh_harf(d, code9), code10)
  }
  
  if (order == "eight") {
    res <- mesh_to_latlon2(mesh_to_latlon2(mesh_harf(d, code9), code10), code = code11)
  }
  
  return(res)
}
