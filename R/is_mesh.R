#' @title Predict meshcode format and positions
#' @description Predict meshcode format and positions for utility and certain.
#' @inheritParams mesh_to_coords
#' @name is_mesh
NULL # nolint

#' @export
#' @rdname is_mesh
is_meshcode <- function(meshcode) {
  purrr::map_lgl(
    meshcode,
    function(meshcode) {
      res <- ifelse(grepl("^[0-9]{4,11}$", meshcode), TRUE, FALSE)
      if (res == FALSE) {
        rlang::inform(
          # nolint start
          paste("meshcode must be numeric ranges", 
                min(df_mesh_size_unit$mesh_length), 
                "to",
                max(df_mesh_size_unit$mesh_length),
                "digits"))
      } else {
        res <- ifelse(is.na(units::drop_units(mesh_size(meshcode))), FALSE, TRUE)
        if (res == FALSE) {
          rlang::inform(paste("meshcode must be follow digits:",
                              paste(df_mesh_size_unit$mesh_length[1:nrow(df_mesh_size_unit) - 1], # nolint
                                    collapse = ", "),
                              "and",
                              df_mesh_size_unit$mesh_length[nrow(df_mesh_size_unit)]))
        } else {
          res <- 
            is_meshcode_regex(meshcode)
          if (res == FALSE) {
            rlang::inform("There are unavailable numbered digits in the meshcode.")
          }
        }
      }
      # nolint end
      return(res)   
    }
  )
}

is.mesh <- function(meshcode) { # nolint
  invisible(is_meshcode(meshcode)) # nolint
}

#' @export
#' @rdname is_mesh
is_corner <- function(meshcode) {
  size <- mesh_size(meshcode) # nolint
  if (size == units::as_units(80, "km")) {
    rlang::abort("enable 10km or 1km mesh")
  } else if (size == units::as_units(10, "km")) {
    res <- grepl("(0[0-7]|[0-7]0|7[0-7]|[0-7]7)$", meshcode)
  } else if (size == units::as_units(1, "km")) {
    res <- grepl("(0[0-9]|[0-9]0|9[0-9]|[0-9]9)$", meshcode)
  }
  return(res)
}

is_meshcode_regex <- function(meshcode) {
  purrr::map_lgl(meshcode,
                 function(meshcode) {
                   if (mesh_size(meshcode) == mesh_units[1])
                     res <- grepl(meshcode_regexp[["80km"]], meshcode)  
                   if (mesh_size(meshcode) == mesh_units[2])
                     res <- grepl(meshcode_regexp[["10km"]], meshcode)
                   if (mesh_size(meshcode) == mesh_units[3])
                     res <- grepl(meshcode_regexp[["5km"]], meshcode)
                   if (mesh_size(meshcode) == mesh_units[4])
                     res <- grepl(meshcode_regexp[["1km"]], meshcode)
                   if (mesh_size(meshcode) == mesh_units[5])
                     res <- grepl(meshcode_regexp[["500m"]], meshcode)
                   if (mesh_size(meshcode) == mesh_units[6])
                     res <- grepl(meshcode_regexp[["250m"]], meshcode)
                   if (mesh_size(meshcode) == mesh_units[7])
                     res <- grepl(meshcode_regexp[["125m"]], meshcode)
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
