#' @title Export meshcode to geometry
#' 
#' @description Convert and export meshcode area to sf polygon.
#' @param meshcode mesh code
#' @param ... other parameters
#' @importFrom dplyr mutate
#' @importFrom purrr pmap
#' @importFrom sf st_sf
#' @return sf object
#' @examples
#' export_mesh(6441427712)
#' @export
export_mesh <- function(meshcode) {
  
  . <- NULL
  
  mesh_to_coords(meshcode) %>% 
  purrr::pmap_chr(., ~ mesh_to_poly(...)) %>% 
    sf::st_as_sfc()
}
