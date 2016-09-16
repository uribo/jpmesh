#' @title Detect mesh code include prefectures
#' @param path path to local file.
#' @import dplyr
#' @import foreach
#' @import magrittr
#' @import readr
#' @importFrom broom tidy
#' @importFrom geojsonio geojson_json
#' @importFrom rgdal readOGR
#' @importFrom sp Polygons
#' @importFrom sp SpatialPolygons
#' @importFrom tidyr unnest
#' @importFrom tibble rownames_to_column
#' @export
pref_mesh <- function(path){
  
  df.pref.mesh <- readr::read_csv(path, locale = readr::locale(encoding = "cp932")) %>% 
    dplyr::select(mesh_code = `基準メッシュコード`) %>% 
    unique() %>% 
    dplyr::arrange(mesh_code) %>% 
    dplyr::mutate(mesh_area = purrr::map(mesh_code, jpmesh::meshcode_to_latlon)) %>% 
    tidyr::unnest() %>% 
    dplyr::mutate(lng1 = long - long_error,
                  lat1 = lat - lat_error,
                  lng2 = long + long_error,
                  lat2 = lat + lat_error) %>% 
    tibble::rownames_to_column()
  
  list.polygons <- foreach(i = 1:nrow(df.pref.mesh)) %do% {
    Polygons(
      list(Polygon(
        cbind(
          c(df.pref.mesh$lng1[i], df.pref.mesh$lng1[i], df.pref.mesh$lng2[i], df.pref.mesh$lng2[i], df.pref.mesh$lng1[i]),
          c(df.pref.mesh$lat2[i], df.pref.mesh$lat1[i], df.pref.mesh$lat1[i], df.pref.mesh$lat2[i], df.pref.mesh$lat2[i])))),
      df.pref.mesh$mesh_code[i])
  }
  
  res <- SpatialPolygons(Srl = list.polygons, pO = 1:nrow(df.pref.mesh)) %>%
    geojsonio::geojson_json(geometry = "polygon") %>%
    readOGR(dsn              = .,
            layer            = "OGRGeoJSON",
            stringsAsFactors = FALSE) %>%
    broom::tidy(.)
  
  return(res)
  
}