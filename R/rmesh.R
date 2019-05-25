#' Generate random sample meshcode
#' 
#' @description Generate random sample meshcode
#' @param n Number of samples
#' @inheritParams meshcode_set
#' @examples  
#' rmesh(3, mesh_size = "1km")
#' @export
rmesh <- function(n, mesh_size = c("1km")) {
   sample(meshcode_set(mesh_size = mesh_size), n)
}
