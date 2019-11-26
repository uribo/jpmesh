#' @title Mesh unit converter
#' @description Return different meshcode values included in the mesh.
#' @inheritParams mesh_to_coords
#' @param to_mesh_size target mesh type. From 80km to 0.125km. If `NULL`,
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
#' mesh_convert("52350432", 1)
#' mesh_convert("52350432131", 0.125)
#' @export
#' @rdname converter
mesh_convert <- function(meshcode = NULL, to_mesh_size = NULL) { # nolint
  . <- NULL
  if (rlang::is_false(is_meshcode(meshcode))) {
    return(NA_character_)
  }
  from_mesh_size <- df_mesh_size_unit$mesh_size[which(df_mesh_size_unit$mesh_size == mesh_size(meshcode))] # nolint
    if (rlang::is_null(to_mesh_size))
      to_mesh_size <-
        units::drop_units(
          df_mesh_size_unit$mesh_size[which(df_mesh_size_unit$mesh_size == mesh_size(meshcode)) + 1]) # nolint
    to_mesh_size <- units::as_units(to_mesh_size, "km")
    if (from_mesh_size == to_mesh_size) {
      res <- meshcode
    } else if (from_mesh_size > to_mesh_size) {
      if (to_mesh_size == units::as_units(10, "km"))
        res <- grep(pattern = paste0("^(", meshcode, ")"),
                    x = meshcode_set_10km, value = TRUE)
      if (to_mesh_size == units::as_units(1, "km"))
        res <- grep(pattern = paste0("^(", meshcode, ")"),
                    x = meshcode_set_1km, value = TRUE)
      if (to_mesh_size <= units::as_units(0.500, "km"))
        res <- grep(pattern = paste0("^(",
                                     substr(meshcode, 1, 8),
                                     ")"),
                    x = meshcode_set_1km, value = TRUE) %>%
          purrr::map(
            ~ paste0(.x, seq_len(4))) %>%
          purrr::reduce(c)
      if (to_mesh_size <= units::as_units(0.250, "km"))
        res <- res %>%
          grep(substr(meshcode, 1, 9), ., value = TRUE) %>%
          purrr::map(
            ~ paste0(.x, seq_len(4))) %>%
          purrr::reduce(c)
      if (to_mesh_size == units::as_units(0.125, "km"))
        res <- res %>%
          grep(substr(meshcode, 1, 10), ., value = TRUE) %>%
          purrr::map(
            ~ paste0(.x, seq_len(4))) %>%
          purrr::reduce(c)
    } else {
      fine_mesh_set <-
        grep(pattern = paste0("^(",
                              substr(meshcode, 1, 8),
                              ")"),
             x = meshcode_set_1km, value = TRUE) %>%
        fine_separate() %>%
        purrr::map(fine_separate) %>%
        purrr::reduce(c) %>%
        purrr::map(fine_separate) %>%
        purrr::reduce(c)
      if (to_mesh_size == units::as_units(80, "km"))
        res <- grep(pattern = paste0("^(",
                                     substr(meshcode, 1, 4),
                                     ")"),
                    x = meshcode_set_80km, value = TRUE)
      if (to_mesh_size == units::as_units(10, "km"))
        res <- grep(pattern = paste0("^(",
                                     substr(meshcode, 1, 6),
                                     ")"),
                    x = meshcode_set_10km, value = TRUE)
      if (to_mesh_size == units::as_units(1, "km"))
        res <- grep(pattern = paste0("^(",
                                     substr(meshcode, 1, 8),
                                     ")"),
                    x = meshcode_set_1km, value = TRUE)
      if (to_mesh_size <= units::as_units(0.500, "km"))
        res <-
        grep(pattern = paste0("^(",
                            substr(meshcode, 1, 9),
                            ")"),
           x = substr(fine_mesh_set, 1, 9), value = TRUE) %>%
        unique() %>%
        paste0(seq_len(4))
      if (to_mesh_size <= units::as_units(0.250, "km"))
        res <-  grep(substr(meshcode, 1, 9),
                     res,
                     value = TRUE) %>%
          purrr::map(
            ~ paste0(.x, seq_len(4))) %>%
          purrr::reduce(c)
      if (to_mesh_size <= units::as_units(0.125, "km"))
        res <-  grep(substr(meshcode, 1, 10),
                     res,
                     value = TRUE) %>%
          purrr::map(
            ~ paste0(.x, seq_len(4))) %>%
          purrr::reduce(c)
    }
    res
}
