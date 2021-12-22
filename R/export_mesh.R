#' @title Export meshcode to geometry
#' @description Convert and export meshcode area to `sfc_POLYGON` and `sf`.
#' @inheritParams mesh_to_coords
#' @importFrom purrr discard pmap_chr
#' @importFrom sf st_as_sfc st_polygon st_sfc
#' @return [sfc][sf::st_sfc] object
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
        if (size >= units::as_units(1, "km")) {
          mesh_to_coords(meshcode) %>% 
            purrr::discard(names(.) %in% "meshcode") %>% 
            purrr::pmap_chr(mesh_to_poly) %>% 
            sf::st_as_sfc(crs = 4326)                  
        } else {
          mesh1km <-
            mesh_convert(meshcode, to_mesh_size = 1)
          x <- 
            mesh_to_coords(meshcode)
          st_mesh_grid(meshcode, 
                       to_mesh_size = units::drop_units(size)) %>% 
            st_sf() %>% 
            sf::st_join(
              sf::st_sfc(sf::st_point(c(x$lng_center, 
                                        x$lat_center)),
                         crs = 4326) %>% 
                sf::st_sf(), 
              left = FALSE) %>% 
            sf::st_geometry()
        }
      }
})

st_mesh_grid <- function(meshcode, to_mesh_size = NULL) {
  size <- 
    mesh_size(meshcode)
  if (size > mesh_units[4]) {
    rlang::abort("Target mesh size must be less than 1km.")
  }
  mesh1km <- 
    mesh_convert(meshcode, to_mesh_size = 1)
  if (to_mesh_size == 0.5) {
    sf::st_make_grid(
      export_mesh(mesh1km),
      n = c(2, 2))
  } else if (to_mesh_size == 0.25) {
    sf::st_make_grid(
      export_mesh(mesh1km),
      n = c(4, 4))
  } else if (to_mesh_size == 0.125) {
    sf::st_make_grid(
      export_mesh(mesh1km),
      n = c(8, 8))
  } else if (to_mesh_size == 0.100) {
    sf::st_make_grid(
      export_mesh(mesh1km),
      n = c(10, 10))
  }
}

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


#' @inheritParams mesh_to_coords
#' @param .keep_class Do you want to assign a class to the meshcode column 
#' in data.frame? If `FALSE`, it will be treated as a character type.
#' @importFrom purrr map_chr modify_at
#' @importFrom sf st_as_sfc st_as_text st_sf
#' @importFrom tibble tibble
#' @return [sf][sf::st_sf] object
#' @examples
#' export_meshes("4128")
#' find_neighbor_mesh("37250395") %>%
#'   export_meshes()
#' @export
#' @name export_mesh
export_meshes <- function(meshcode, .keep_class = FALSE) {
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
  res <- 
    df_meshes %>% 
    sf::st_sf(crs = 4326) %>% 
    tibble::new_tibble(class = "sf", nrow = nrow(df_meshes))
  if (.keep_class == FALSE) {
    res <-
      res %>% 
      purrr::modify_at(1, ~ as.character(.x))
  }
  res
}

#' @title Conversion to sf objects containing meshcode 
#' @description Convert and export meshcode area to `sf`.
#' @param data data.frame
#' @param mesh_var unquoted expressions for meshcode variable.
#' @inheritParams meshcode
#' @inheritParams export_mesh
#' @return [sf][sf::st_sf] object
#' @export
#' @examples
#' d <- data.frame(id = seq.int(4),
#'             meshcode = rmesh(4),
#'             stringsAsFactors = FALSE)
#' meshcode_sf(d, meshcode)
#' @rdname meshcode_sf
meshcode_sf <- function(data, mesh_var, .type, .keep_class = FALSE) {
  meshcode <-
    rlang::quo_name(rlang::enquo(mesh_var))
  meshes <-
    data %>%
    purrr::pluck(meshcode)
  if (is_meshcode(meshes) == FALSE)
    meshes <- 
      meshes %>%
      as_meshcode(.type = .type)
  res <- 
    sf::st_sf(
    data,
    geometry = meshes %>%
      export_meshes() %>%
      sf::st_geometry(),
    crs = 4326) %>%
    tibble::new_tibble(nrow = nrow(data), class = "sf")
  if (.keep_class == FALSE) {
    res <- 
      res %>% 
      purrr::modify_at(which(names(res) %in% meshcode),
                       ~ as.character(.x))
  }
  res
}
