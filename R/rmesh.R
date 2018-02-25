#' Generate random sample meshcode
#' 
#' @description Generate random sample meshcode
#' @param n Number of samples
#' @inheritParams meshcode_set
#' @example 
#' rmesh(3, mesh_size = "1km")
#' @export
rmesh <- function(n, mesh_size = c("1km")) {
  meshcode_set(mesh_size = mesh_size) %>% 
    sample(n)
} 
