#' @title Generate random sample meshcode
#' @description Generate random sample meshcode
#' @param n Number of samples
#' @inheritParams meshcode_set
#' @examples
#' rmesh(3, mesh_size = 1)
#' @export
rmesh <- function(n, mesh_size = 1) {
  if (mesh_size %in% c(80, 10, 5, 1)) {
    sample(meshcode_set(mesh_size = mesh_size), n) # nolint
  } else {
    rlang::abort(paste0(
      "`mesh_size` should be one of: ",
      paste(
        units::drop_units(mesh_units)[c(1, 2, 3)],
        collapse = ", "
      ),
      " or ",
      paste(units::drop_units(mesh_units)[4])
    ))
  }
}
