#' @title Predict meshcode format and positions
#' @description Predict meshcode format and positions for utility and certain.
#' @inheritParams mesh_to_coords
#' @name is_mesh
NULL # nolint

#' @export
#' @rdname is_mesh
is_meshcode <- function(meshcode) {
  inherits(meshcode, c("meshcode", "subdiv_meshcode"))
}

#' @export
#' @rdname is_mesh
is_corner <- function(meshcode) {
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <-
      meshcode(meshcode)
  }
  size <- 
    mesh_size(meshcode) # nolint
  if (size == units::as_units(80, "km")) {
    rlang::abort("enable 10km or 1km mesh")
  } else if (size == units::as_units(10, "km")) {
    grepl("(0[0-7]|[0-7]0|7[0-7]|[0-7]7)$", 
          vctrs::field(meshcode, "mesh_code"))
  } else if (size == units::as_units(1, "km")) {
    grepl("(0[0-9]|[0-9]0|9[0-9]|[0-9]9)$",
          vctrs::field(meshcode, "mesh_code"))
  }
}

is_meshcode_regex <- function(meshcode) {
  purrr::map_lgl(meshcode,
                 function(meshcode) {
                   if (mesh_size(meshcode) == mesh_units[1])
                     res <- grepl(meshcode_regexp[["80km"]],
                                  vctrs::field(meshcode[1], "mesh_code"))
                   if (mesh_size(meshcode) == mesh_units[2])
                     res <- grepl(meshcode_regexp[["10km"]],
                                  vctrs::field(meshcode, "mesh_code"))
                   if (mesh_size(meshcode) == mesh_units[3])
                     res <- grepl(meshcode_regexp[["5km"]], 
                                  vctrs::field(meshcode, "mesh_code"))
                   if (mesh_size(meshcode) == mesh_units[4])
                     res <- grepl(meshcode_regexp[["1km"]], 
                                  vctrs::field(meshcode, "mesh_code"))
                   if (mesh_size(meshcode) == mesh_units[5])
                     res <- grepl(meshcode_regexp[["500m"]], 
                                  vctrs::field(meshcode, "mesh_code"))
                   if (mesh_size(meshcode) == mesh_units[6])
                     res <- grepl(meshcode_regexp[["250m"]], 
                                  vctrs::field(meshcode, "mesh_code"))
                   if (mesh_size(meshcode) == mesh_units[7])
                     res <- grepl(meshcode_regexp[["125m"]], 
                                  vctrs::field(meshcode, "mesh_code"))
                   res                   
                 })
}

meshcode_regexp <- 
  list(`80km` = "^([3-6][0-9][2-5][0-9])")  %>% 
  purrr::list_modify(
    `10km` = paste0(.[[1]], "([0-7]{2})")) %>% 
  purrr::list_modify(
    `5km` = paste0(.[[2]], "([1-4]{1})")) %>% 
  purrr::list_modify(
    `1km` = paste0(.[[2]], "([0-9]{2})")
  ) %>% 
  purrr::list_modify(
    `500m` = paste0(.[[4]], "([1-4]{1})"),
    `250m` = paste0(.[[4]], "([1-4]{2})"),
    `125m` = paste0(.[[4]], "([1-4]{3})")
  ) %>% 
  purrr::map(~ paste0(.x, "$"))
