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
#' data("jpmesh.pref")
#' jpmesh.pref %>% 
#'   filter(jiscode == "33") %>% 
#'   mesh_rectangle(., mesh_code = "id", view = FALSE)
#' }
#' @export
mesh_rectangle <- function(df, mesh_code = "mesh_code", view = TRUE) {
  
  df.mesh <- df %>% 
    dplyr::select_(mesh_code) %>% 
    unique() %>% 
    set_colnames(c("mesh_code")) %>% 
    dplyr::mutate(mesh_area = purrr::map(mesh_code, jpmesh::meshcode_to_latlon)) %>% 
    tidyr::unnest() %>% 
    dplyr::mutate(lng1 = long - long_error,
                  lat1 = lat - lat_error,
                  lng2 = long + long_error,
                  lat2 = lat + lat_error) %>% 
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
