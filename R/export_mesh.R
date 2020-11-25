#' @title Export meshcode to geometry
#' @description Convert and export meshcode area to `sfc_POLYGON`.
#' @inheritParams mesh_to_coords
#' @importFrom purrr pmap_chr
#' @importFrom sf st_as_sfc st_polygon st_sfc
#' @return [sfc][sf::st_as_sfc] object
#' @examples
#' export_mesh("6441427712")
#' @export
export_mesh <- 
  memoise::memoise(
    function(meshcode) {
      if (is_meshcode(meshcode) == FALSE) {
        meshcode <-
          meshcode(meshcode)
      }
      if (mesh_size(meshcode) == units::set_units(0.1, "km")) {
        export_mesh_subdiv(meshcode)
      } else {
        size <- 
          mesh_size(meshcode)
        mesh_to_coords(meshcode) %>% 
          purrr::discard(names(.) %in% "meshcode") %>% 
          purrr::pmap_chr(mesh_to_poly) %>% 
          sf::st_as_sfc(crs = 4326)        
      }
})

export_mesh_subdiv <- function(meshcode) {
  mesh <- NULL
  m1km <-
    mesh_convert(meshcode, to_mesh_size = 1)
  subset(sf::st_sf(mesh = paste0(m1km,
                                 sprintf("%02d", seq.int(0, 99))),
                   geometry = sf::st_make_grid(
                     export_mesh(m1km), n = c(10, 10))), 
         subset = mesh == as.character(meshcode)) %>% 
    purrr::pluck("geometry")
}

#' @title Export meshcode to geometry
#' @description Convert and export meshcode area to `sf`.
#' @inheritParams mesh_to_coords
#' @importFrom purrr map_chr
#' @importFrom sf st_as_sfc st_as_text st_sf
#' @importFrom tibble tibble
#' @examples
#' export_meshes("4128")
#' find_neighbor_mesh("37250395") %>%
#'   export_meshes()
#' @export
#' @name export_meshes
export_meshes <- function(meshcode) {
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <- 
      meshcode(meshcode)
  }
  df_meshes <-
    tibble::tibble("meshcode" = meshcode)
  size <-
    vctrs::field(df_meshes$meshcode, "mesh_size") %>% 
    unique()
  if (size == 0.1) {
    df_meshes$geometry <- 
      purrr::map_chr(vctrs::field(df_meshes$meshcode, "mesh_code"),
                   ~ export_mesh_subdiv(meshcode = .x) %>%
                     sf::st_as_text()) %>%
      sf::st_as_sfc()
  } else {
    df_meshes$geometry <-
      purrr::map_chr(vctrs::field(df_meshes$meshcode, "mesh_code"),
                     ~ export_mesh(meshcode = .x) %>%
                       sf::st_as_text()) %>%
      sf::st_as_sfc()    
  }
  df_meshes %>% 
    sf::st_sf(crs = 4326) %>% 
    tibble::new_tibble(class = "sf", nrow = nrow(df_meshes))
}

#' @name export_meshes
#' @param data data.frame
#' @param mesh_var unquoted expressions for meshcode variable.
#' @export
#' @examples
#' d <- data.frame(id = seq.int(4),
#'             meshcode = rmesh(4),
#'             stringsAsFactors = FALSE)
#' meshcode_sf(d, meshcode)
meshcode_sf <- function(data, mesh_var) {
  meshcode <-
    rlang::quo_name(rlang::enquo(mesh_var))
  sf::st_sf(
    data,
    geometry = data %>%
      purrr::pluck(meshcode) %>%
      export_meshes() %>%
      sf::st_geometry(),
    crs = 4326
  ) %>%
    tibble::new_tibble(nrow = nrow(data), class = "sf")
}
