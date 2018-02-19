#' @title Export meshcode to geometry
#' 
#' @description Convert and export meshcode area to sf polygon.
#' @param mesh mesh code
#' @importFrom purrr pmap_chr
#' @importFrom sf st_as_sfc
#' @return sf object
#' @examples
#' export_mesh(6441427712)
#' @export
export_mesh <- function(mesh) {
  
  . <- NULL
  
  if (is.mesh(mesh))
    mesh_to_coords(mesh) %>% 
    purrr::pmap_chr(., ~ mesh_to_poly(...)) %>% 
    sf::st_as_sfc(crs = 4326)
}
