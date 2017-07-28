#' Rectange mesh grid area
#' 
#' @description Single mesh coverd area.
#' @param code mesh code
#' @param order mesh order
#' @importFrom dplyr mutate
#' @importFrom tibble rownames_to_column
#' @examples 
#' mesh_area(523504221, order = "harf")
#' @export
mesh_area <- function(code, order = c("harf", "quarter", "eight")) {

  if (nchar(code) < 8) {
    stop("The code must be 8 digits or more.")
  } 
  
  if (is.null(order) == FALSE) {
    order = "harf"
  }
  
  d <- meshcode_to_latlon(code) %>% 
    bundle_mesh_vars()
  
  # 500m mesh
  if (length(grep("^[0-9]{9}", code)) == 1) {
    code9 <- as.numeric(substring(code, 9, 9))
  }
  
  # 250m mesh
  if (length(grep("^[0-9]{10}", code)) == 1) {
    code10 <- as.numeric(substring(code, 10, 10))
  }
  
  # 125m mesh
  if (length(grep("^[0-9]{11}", code)) == 1) {
    code11 <- as.numeric(substring(code, 11, 11))
  }
  
  if (order == "harf") {
    res <- mesh_harf(d, code9)
  }
  
  if (order == "quarter") {
    res <- mesh_to_latlon2(mesh_harf(d, code9), code10)
  }
  
  if (order == "eight") {
    res <- mesh_to_latlon2(mesh_to_latlon2(mesh_harf(d, code9), code10), code = code11)
  }
  
  return(res)
}
