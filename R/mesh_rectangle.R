#' Rectange mesh grid area
#' @param code meshcode
#' @param order mesh order
#' @import dplyr
#' @importFrom tibble rownames_to_column
#' @examples 
#' mesh_area(523504221, order = "harf")
#' @export
mesh_area <- function(code, order = c("harf", "quarter", "eight")) {
  
  # codeが9桁以下だった時のエラー処理が必要。
  # orderの既定値の指定方法。今のままだと警告が出る
  
  if (is.null(order) == TRUE) {
    order = "harf"
  }
  
  d <- meshcode_to_latlon(code) %>% 
    dplyr::mutate(lng1 = long_center - long_error,
                  lat1 = lat_center - lat_error,
                  lng2 = long_center + long_error,
                  lat2 = lat_center + lat_error)
  
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

#' @title mesh rectangel check
#' @param df data.frame
#' @param mesh_code mesh code
#' @param view option.
#' @import dplyr
#' @import leaflet
#' @importFrom purrr map
#' @importFrom tidyr unnest
#' @importFrom tibble rownames_to_column
#' @examples 
#' \dontrun{
#' library(dplyr)
#' mesh_rectangle(pref_mesh(33), mesh_code = "id", view = FALSE)
#' }
#' @export
mesh_rectangle <- function(df, mesh_code = "mesh_code", view = TRUE) {
  
  df.mesh <- df %>% 
    dplyr::select_(mesh_code) %>% 
    unique() %>% 
    set_colnames(c("mesh_code")) %>% 
    dplyr::mutate(mesh_area = purrr::map(mesh_code, jpmesh::meshcode_to_latlon)) %>% 
    tidyr::unnest() %>% 
    dplyr::mutate(lng1 = long_center - long_error,
                  lat1 = lat_center - lat_error,
                  lng2 = long_center + long_error,
                  lat2 = lat_center + lat_error) %>% 
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
