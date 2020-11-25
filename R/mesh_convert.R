#' @title Mesh unit converter
#' @description Return different meshcode values included in the mesh.
#' @inheritParams mesh_to_coords
#' @param to_mesh_size target mesh type. From 80km to 0.100km. If `NULL`,
#' the meshcode of one small scale will be returned.
#' If it is the same as the original size, the meshcode of the input
#' will be return.
#' @examples
#' mesh_convert(meshcode = "52350432", to_mesh_size = 80)
#' mesh_convert("52350432", 10)
#' # Scale down
#' mesh_convert("52350432", 0.500)
#' mesh_convert("52350432", 0.250)
#' mesh_convert(meshcode = "52350432", 0.125)
#' mesh_convert("523504323", 0.250)
#' mesh_convert("5235043213", 0.125)
#' mesh_convert(64414315, 0.1)
#' # Not changes
#' mesh_convert("52350432", 1)
#' mesh_convert("52350432131", 0.125)
#' @export
#' @return [meshcode][meshcode]
#' @rdname converter
mesh_convert <- function(meshcode = NULL, to_mesh_size = NULL) { # nolint
  . <- .x <- NULL
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <-
      meshcode(meshcode)
  }
  from_mesh_size <- 
    df_mesh_size_unit$mesh_size[which(df_mesh_size_unit$mesh_size == mesh_size(meshcode))] # nolint
    if (rlang::is_null(to_mesh_size))
      to_mesh_size <-
        units::drop_units(
          df_mesh_size_unit$mesh_size[which(df_mesh_size_unit$mesh_size == mesh_size(meshcode)) + 1]) # nolint
    to_mesh_size <-
      units::as_units(to_mesh_size, "km")
    mesh_code <-
      vctrs::field(meshcode, "mesh_code")
    size <-
      vctrs::field(meshcode, "mesh_size")
    type <- 
      ifelse(to_mesh_size == units::as_units(0.1, "km"),
           "subdivision",
           "standard")
    if (type == "subdivision" && from_mesh_size >= units::as_units(1, "km")) {
      if (from_mesh_size >= units::as_units(10, "km")) {
        mesh_code <- 
          grep(pattern = paste0("^(", mesh_code, ")"),
             x = meshcode_set(1, .raw = TRUE), value = TRUE)
      }
      mesh_code %>% 
        purrr::map(
          ~ paste0(.x,
                   rep(seq.int(0, 9), each = 10),
                   rep(seq.int(0, 9), times = 10))) %>% 
        purrr::reduce(c) %>% 
        purrr::map(~ meshcode(.x, .type = type)) %>% 
        purrr::reduce(c)
    } else {
      if (from_mesh_size == to_mesh_size) {
        res <- 
          mesh_code
      } else if (from_mesh_size > to_mesh_size) {
        if (to_mesh_size == units::as_units(80, "km")) {
          res <-
            grep(pattern = paste0("^(", mesh_code, ")"),
                 x = meshcode_set(80, .raw = TRUE), value = TRUE)
        }
        if (to_mesh_size == units::as_units(10, "km")) {
          res <-
            grep(pattern = paste0("^(", mesh_code, ")"),
                 x = meshcode_set(10, .raw = TRUE), value = TRUE)
        }
        if (to_mesh_size == units::as_units(1, "km")) {
          res <-
            grep(pattern = paste0("^(", mesh_code, ")"),
                 x = meshcode_set(1, .raw = TRUE), value = TRUE)
        }
        if (to_mesh_size <= units::as_units(0.500, "km")) {
          res <- 
            substr(mesh_code, 1, 8) %>%
            purrr::map(
              ~ paste0(.x, seq_len(4))) %>%
            purrr::reduce(c)
          if (to_mesh_size <= units::as_units(0.250, "km")) {
            res <- 
              res %>%
              grep(substr(mesh_code, 1, 9), ., value = TRUE) %>%
              purrr::map(
                ~ paste0(.x, seq_len(4))) %>%
              purrr::reduce(c)
          } 
          if (to_mesh_size == units::as_units(0.125, "km")) {
            res <-
              res %>%
              grep(substr(mesh_code, 1, 10), ., value = TRUE) %>%
              purrr::map(
                ~ paste0(.x, seq_len(4))) %>%
              purrr::reduce(c)
          }
        }
      } else {
        if (to_mesh_size == units::as_units(80, "km")) {
          res <- 
            mesh_code %>% 
            substr(1, 4)
        } else if (to_mesh_size == units::as_units(10, "km")) {
          res <-
            mesh_code %>% 
            substr(1, 6)
        } else if (to_mesh_size == units::as_units(1, "km")) { # nolint
          res <-
            mesh_code %>% 
            substr(1, 8)
        } else {
          fine_mesh_set <-
            grep(pattern = paste0("^(",
                                  substr(mesh_code, 1, 8),
                                  ")"),
                 x = meshcode_set(1, .raw = TRUE), 
                 value = TRUE) %>%
            fine_separate() %>%
            purrr::map(fine_separate) %>%
            purrr::reduce(c) %>%
            purrr::map(fine_separate) %>%
            purrr::reduce(c) %>% 
            vctrs::field("mesh_code")
          if (to_mesh_size <= units::as_units(0.500, "km"))
            res <-
              grep(pattern = paste0("^(",
                                    substr(mesh_code, 1, 9),
                                    ")"),
                   x = substr(fine_mesh_set, 1, 9), value = TRUE) %>%
              unique() %>%
              paste0(seq_len(4))
        }
      }
      meshcode(res)
    }
}
