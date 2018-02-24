#' @title Export meshcode to geometry
#' 
#' @description Convert and export meshcode area to sf polygon.
#' @inheritParams mesh_to_coords
#' @importFrom purrr pmap_chr
#' @importFrom sf st_as_sfc
#' @return sf object
#' @examples
#' export_mesh(6441427712)
#' @export
export_mesh <- function(meshcode) {
  
  . <- NULL
  
  if (is.mesh(meshcode))
    mesh_to_coords(meshcode) %>% 
    purrr::pmap_chr(., ~ mesh_to_poly(...)) %>% 
    sf::st_as_sfc(crs = 4326)
}

#' @param meshes mesh code sets
#' @examples 
#' export_meshes("4128")
#' @export
export_meshes <- function(meshes) {
  meshes %>% 
    as.character() %>% 
    tibble::tibble("meshcode" = .) %>% 
    dplyr::mutate(geometry = purrr::pmap(., ~ export_mesh(mesh = ..1) %>% 
                                           sf::st_as_text())) %>% 
    tidyr::unnest() %>% 
    dplyr::mutate(geometry = sf::st_as_sfc(geometry)) %>% 
    sf::st_sf(crs = 4326)
}
