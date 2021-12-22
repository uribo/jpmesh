#' @title Generate random sample meshcode
#' @description Generate random sample meshcode
#' @param n Number of samples
#' @inheritParams meshcode_set
#' @examples
#' rmesh(3, mesh_size = 1)
#' @return [meshcode][meshcode]
#' @export
rmesh <- function(n, mesh_size = 1) {
  mesh_size <- 
    as.character(mesh_size)
  rlang::arg_match(mesh_size,
                   c("80", "10", "1"))
  meshcode(sample(meshcode_set(mesh_size = mesh_size), n))
}
