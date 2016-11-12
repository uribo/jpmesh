#' @title Collect prefecture 1km mesh data
#' 
#' @description Japanese prefectures administrations
#' @param code prefecture code (jiscode)
#' @importFrom readr read_rds
#' @examples 
#' head(pref_mesh(33))
#' @export
pref_mesh <- function(code = NULL) {
  
  d <- readr::read_rds(system.file(paste0("extdata/pref_", sprintf("%02d", code), "_mesh.rds"), package = "jpmesh"))
  return(d)
}

#' @title Detect mesh code include prefectures 
#' 
#' @description inherent function
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
raw_pref_mesh <- function(path){

  mesh_code <- NULL
  i <- NULL
    
  df.origin <- readr::read_csv(path, locale = readr::locale(encoding = "cp932"),
                               col_types = list(col_character(), col_character(), col_number())) %>% 
    set_colnames(c("city_code", "city_name", "mesh_code"))
  
  df.pref.mesh <- df.origin %>% 
    select(mesh_code) %>% 
    unique() %>% 
    dplyr::arrange(mesh_code) %>% 
    dplyr::mutate(mesh_area = purrr::map(mesh_code, meshcode_to_latlon)) %>% 
    tidyr::unnest() %>% 
    bundle_mesh_vars() %>% 
    tibble::rownames_to_column()
  
  df.pref.mesh.geo <- poly_to_geojson(df.pref.mesh) %>%
    geojsonio::geojson_json(geometry = "polygon") %>%
    rgdal::readOGR(
            layer            = "OGRGeoJSON",
            stringsAsFactors = FALSE) %>%
    broom::tidy() %>% 
    dplyr::mutate(id = as.numeric(id))
  
  res <- df.pref.mesh.geo %>% left_join(df.origin, by = c("id" = "mesh_code"))
  
  return(res)
  
}
