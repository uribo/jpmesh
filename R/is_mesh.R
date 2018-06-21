#' Predict meshcode format and positions
#' 
#' @description Predict meshcode format and positions for utility and certain.
#' @inheritParams mesh_to_coords
#' @name is_mesh
NULL 

#' @export
#' @rdname is_mesh
is_meshcode <- function(meshcode) {
  
  res <- ifelse(grepl("^[0-9]{4,11}$", meshcode), TRUE, FALSE)
  
  if (res == FALSE) {
    rlang::inform(paste("meshcode must be numeric ranges", 
                        min(df_mesh_size_unit$mesh_length), 
                        "to",
                        max(df_mesh_size_unit$mesh_length),
                        "digits"
    ))
  } else {
    res <- ifelse(is.na(units::drop_units(mesh_size(meshcode))),
                          FALSE,
                          TRUE)
    if (res == FALSE) {
      rlang::inform(paste("meshcode must be follow digits:",
                          paste(df_mesh_size_unit$mesh_length[1:nrow(df_mesh_size_unit) - 1], 
                                collapse = ", "),
                          "and",
                          df_mesh_size_unit$mesh_length[nrow(df_mesh_size_unit)]
      ))
    }
  }
  
  return(res)
}

is.mesh <- function(meshcode) {
  invisible(is_meshcode(meshcode))
}

#' @export
#' @rdname is_mesh
is_corner <- function(meshcode) {
  size <- mesh_size(meshcode)
  
  if (size == units::as_units(80, "km")) {
    rlang::abort("enable 10km or 1km mesh")
  } else if (size == units::as_units(10, "km")) {
    res <- grepl("(0[0-7]|[0-7]0|7[0-7]|[0-7]7)$", meshcode)
  } else if (size == units::as_units(1, "km")) {
    res <- grepl("(0[0-9]|[0-9]0|9[0-9]|[0-9]9)$", meshcode)
  }
  
  return(res)
  
}
