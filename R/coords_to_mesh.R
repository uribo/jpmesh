#' @title Convert from coordinate to mesh code
#' @description From coordinate to mesh codes.
#' @param longitude longitude that approximately to .120.0 to 154.0 (`double`)
#' @param latitude latitude that approximately to 20.0 to 46.0 (`double`)
#' @inheritParams mesh_convert
#' @param geometry XY sfg object
#' @param ... other parameters
#' @importFrom rlang is_true quo_squash warn
#' @return mesh code (default 3rd meshcode aka 1km mesh)
#' @references Akio Takenaka: [http://takenaka-akio.org/etc/j_map/index.html](http://takenaka-akio.org/etc/j_map/index.html) # nolint
#' @seealso [mesh_to_coords()] for convert from meshcode to coordinates
#' @examples
#' coords_to_mesh(141.3468, 43.06462, to_mesh_size = 1)
#' coords_to_mesh(139.6917, 35.68949, to_mesh_size = 0.250)
#' coords_to_mesh(139.71475, 35.70078)
#' coords_to_mesh(139.71475, 35.70078, to_mesh_size = 0.1)
#' coords_to_mesh(c(141.3468, 139.71475), 
#'                c(43.06462, 35.70078), 
#'                mesh_size = c(1, 10))
#' # Using sf (point as sfg object)
#' library(sf)
#' coords_to_mesh(geometry = st_point(c(139.71475, 35.70078)))
#' coords_to_mesh(geometry = st_point(c(130.4412895, 30.2984335)))
#' @export
coords_to_mesh <- function(longitude, latitude, to_mesh_size = 1, geometry = NULL, ...) { # nolint
  to_mesh_size <- 
    units::as_units(to_mesh_size, "km")
  if (rlang::is_true(identical(which(to_mesh_size %in% mesh_units), integer(0)))) # nolint
    rlang::abort(
      paste0("`mesh_size` should be one of: ",
             paste(
               units::drop_units(mesh_units)[-seq.int(8, 8)],
               collapse = ", "),
             " or ",
             paste(units::drop_units(mesh_units)[8])))
  if (rlang::is_false(is.null(geometry))) {
    geometry <- 
      sf::st_sfc(geometry)
    coords <-
      lapply(geometry, function(x) {
        if (sf::st_is(x, "POINT"))
          list(longitude = sf::st_coordinates(x)[1],
               latitude =  sf::st_coordinates(x)[2])
        else
          list(longitude = sf::st_coordinates(sf::st_centroid(x))[1],
               latitude =  sf::st_coordinates(sf::st_centroid(x))[2])
      })
    if (!rlang::is_missing(longitude) | !rlang::is_missing(latitude))
      rlang::inform("the condition assigned coord and geometry, only the geometry will be used") # nolint
    longitude <-
      coords %>%
      purrr::map("longitude")
    latitude <-
      coords %>%
      purrr::map("latitude")
  } else {
    longitude <- rlang::quo_squash(longitude)
    latitude <- rlang::quo_squash(latitude)
  }
  purrr::pmap(
    list(longitude = longitude,
         latitude = latitude,
         to_mesh_size = to_mesh_size),
    ~ .coord2mesh(..1, ..2, ..3)) %>% 
    purrr::reduce(c)
}

.coord2mesh <- function(longitude, latitude, to_mesh_size) {
  .x <- .y <- NULL
  coords_evalated <-
    purrr::map2_lgl(longitude,
                    latitude,
                    ~ eval_jp_boundary(.x, .y))
  if (is.na(coords_evalated)) {
    rlang::warn("Return missing because an inappropriate missing value was given.")
    return(NA_character_)
  }
  if (coords_evalated == FALSE) {
    rlang::warn("Longitude / Latitude values is out of range.")
    return(NA_character_)
  }
  if (coords_evalated == TRUE) {
    code12 <- (latitude * 60L) %/% 40L
    code34 <- as.integer(longitude - 100L)
    check_80km_ares <- 
      paste0(code12, code34) %>%
      match(meshcode_80km_num) %>% # nolint
      any()
    if (rlang::is_true(check_80km_ares)) {
      code_a <- (latitude * 60L) %% 40L
      code5 <- code_a %/% 5L
      code_b <- code_a %% 5L
      code7 <- (code_b * 60L) %/% 30L
      code_c <- (code_b * 60L) %% 30L
      code_s <- code_c %/% 15L
      code_d <- code_c %% 15L
      code_t <- code_d %/% 7.5
      code_e <- code_d %% 7.5
      code_u <- code_e %/% 3.75
      code_f <- (longitude - 100L) - as.integer(longitude - 100L)
      code6 <- (code_f * 60L) %/% 7.5
      code_g <- (code_f * 60L) %% 7.5
      code8 <- (code_g * 60L) %/% 45L
      code_h <- (code_g * 60L) %% 45L
      code_x <- code_h %/% 22.5
      code_i <- code_h %% 22.5
      code_y <- code_i %/% 11.25
      code_j <- code_i %% 11.25
      code_z <- code_j %/% 5.625
      code9 <- (code_s * 2L) + (code_x + 1L)
      code10 <- (code_t * 2L) + (code_y + 1L)
      code11 <- (code_u * 2L) + (code_z + 1L)
      meshcode <- paste0(code12,
                         code34,
                         code5,
                         code6,
                         code7,
                         code8,
                         code9,
                         code10,
                         code11)
      meshcode <-
        if (to_mesh_size == mesh_units[1]) {
          substr(meshcode, 1L, 4L)
        } else if (to_mesh_size == mesh_units[2]) {
          substr(meshcode, 1L, 6L)
        } else if (to_mesh_size == mesh_units[3]) {
          paste0(substr(meshcode, 1L, 6L),
                 (code_b %/% (5L / 2L) * 2L) + (code_g %/% (7.5 / 2L) + 1L))
        } else if (to_mesh_size == mesh_units[4]) {
          substr(meshcode, 1L, 8L)
        } else if (to_mesh_size == mesh_units[5]) {
          substr(meshcode, 1L, 9L)
        } else if (to_mesh_size == mesh_units[6]) {
          substr(meshcode, 1L, 10L)
        } else if (to_mesh_size == mesh_units[7]) {
          meshcode
        } else if (to_mesh_size == mesh_units[8]) {
          paste0(
            substr(meshcode, 1L, 8L),
            sprintf("%02d",
                    sf::st_intersects(
                      sf::st_sfc(sf::st_point(c(longitude,
                                                latitude)),
                                 crs = 4326),
                      st_mesh_grid(substr(meshcode, 1L, 8L),
                                   to_mesh_size = 0.1),
                      sparse = FALSE) %>%
                      which() - 1L)
          )
        }
      if (to_mesh_size == mesh_units[8]) {
        meshcode(meshcode, .type = "subdivision")
      } else {
        meshcode(meshcode) 
      }
    } else if (is.na(check_80km_ares)) {
      rlang::warn("Longitude / Latitude values is out of range.")
      return(NA_character_)
    }
  }
}
