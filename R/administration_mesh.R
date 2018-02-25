#' Extract administration mesh
#' 
#' @param code administration code
#' @param type administration type. Should be one of "prefecture" or "city".
#' @import dplyr
#' @importFrom sf st_sf
#' @importFrom tidyr unnest
#' @importFrom purrr pmap
#' @examples 
#' \dontrun{
#' administration_mesh(code = c(35201), type = "city")
#' administration_mesh(code = c(35), type = "prefecture")
#' administration_mesh(code = c(33, 34), type = "prefecture")
#' }
#' @name administration_mesh
#' @export
administration_mesh <- function(code, type = c("prefecture")) {
  
  . <- city_code <- meshcode <- NULL
  
  if (type == "prefecture") {
    df_city_mesh <- df_city_mesh %>% 
      dplyr::mutate(meshcode = substr(meshcode, 1, 6))  
  }
  
  df_origin <- df_city_mesh %>% 
    dplyr::filter(
      grepl(paste0("^(", paste(code, collapse = "|"), ")"), city_code))
  
  res <- df_origin %>% 
    dplyr::distinct(meshcode) %>% 
    dplyr::mutate(out = purrr::pmap(., ~ mesh_to_coords(...))) %>% 
    tidyr::unnest() %>% 
    dplyr::mutate(geometry = purrr::pmap(., ~ mesh_to_poly(...))) %>% 
    sf::st_sf(crs = 4326)

  return(res)
}
