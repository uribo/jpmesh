#' @title Export rectangle mesh to geojson
#' 
#' @description Convert and export meshcode area to geojson string.
#' @param code meshcode 
#' @import foreach
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom purrr map
#' @importFrom purrr map_df
#' @importFrom sp Polygons
#' @importFrom sp SpatialPolygons
#' @importFrom geojsonio geojson_json
#' @return geojson character strings
#' @examples 
#' # export geojson string
#' export_mesh(
#'   code = latlong_to_meshcode(lat = 35.82083, long = 137.0563, order = 3))
#' 
#' library(leaflet)
#' leaflet() %>%
#' addTiles() %>%
#' setView(lng = 135.0, lat = 38.0, zoom = 3) %>%
#' addGeoJSON(
#'   export_mesh(
#'     code = c(
#'     latlong_to_meshcode(lat = 35.82083, long = 137.0563, order = 3),
#'     latlong_to_meshcode(lat = 38.40052, long = 141.0131, order = 3))))
#' @export
export_mesh <- function(code) {
  
  # variables handling
  mesh_code <- NULL
  lng1 <- lat1 <- lng2 <- lat2 <- NULL
  code <- as.integer(as.numeric(code))
  
  if (nchar(code) > 8) {
    message("too file mesh.\nthe meshcode gave must be 8 digits.")
  }
  
  df <- code %>% 
    purrr::map(meshcode_to_latlon) %>% 
    purrr::map_df(~ .[c("lat_center", "long_center", "lat_error", "long_error")]) %>% 
    dplyr::mutate(mesh_code = code) %>% 
    bundle_mesh_vars() %>% 
    dplyr::select(mesh_code, lng1, lat1, lng2, lat2)
  
  res <- poly_to_geojson(df)
  
  return(res)
}

