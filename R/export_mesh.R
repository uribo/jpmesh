#' @title Export meshcode to geometry
#' 
#' @description Convert and export meshcode area to `sfc_POLYGON`.
#' @inheritParams mesh_to_coords
#' @importFrom purrr pmap_chr
#' @importFrom sf st_as_sfc st_polygon st_sfc
#' @return sf object
#' @examples
#' export_mesh(6441427712)
#' @export
export_mesh <- function(meshcode) {
  
  if (is.mesh(meshcode))
    if (mesh_size(meshcode) <= units::as_units(0.5, "km")) {

      res <- 
        export_mesh(substr(meshcode, 1, nchar(meshcode) - 1)) %>% 
        sf::st_make_grid(n = c(2, 2))
      
      res <- 
        res[as.numeric(substr(meshcode, nchar(meshcode), nchar(meshcode)))]
      
    } else {
      res <- 
        purrr::pmap_chr(mesh_to_coords(meshcode), 
                        mesh_to_poly) %>% 
        sf::st_as_sfc(crs = 4326)  
    }

  return(res)
  
}

#' Export meshcode to geometry
#' 
#' @description Convert and export meshcode area to `sf`.
#' @param meshes mesh code sets
#' @importFrom purrr map_chr
#' @importFrom sf st_as_sfc st_as_text st_sf
#' @importFrom tibble tibble
#' @examples 
#' export_meshes("4128")
#' \dontrun{
#' find_neighbor_mesh(37250395) %>% 
#'   export_meshes()
#' }
#' @export
export_meshes <- function(meshes) {

  df_meshes <- 
    tibble::tibble("meshcode" = as.character(meshes))
  
  df_meshes$geometry <- 
    purrr::map_chr(df_meshes$meshcode,
                   ~ export_mesh(meshcode = .x) %>% 
                     sf::st_as_text()) %>% 
    sf::st_as_sfc()
    
  df_meshes %>% 
    sf::st_sf(crs = 4326)
}
