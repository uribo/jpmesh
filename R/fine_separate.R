#' @title Detect file scale mesh code
#' @param meshcode mesh code
#' @param lat latitude
#' @param long longitude
#' @export
detect_mesh <- function(meshcode, lat, long) {
  
  df.mesh <- jpmesh:::fine_mesh_to_latlon(meshcode)
  
  if (lat >= df.mesh$lat_center) {
    if (long >= df.mesh$long_center) {
      code <- 4
    } else {
      code <- 3
    }
  }
  if (lat < df.mesh$lat_center) {
    if (long >= df.mesh$long_center) {
      code <- 2
    } else {
      code <- 1
    }
  }
  
  res <- paste0(meshcode, code)
  res <- as.numeric(res)
  return(res)
}

#' @title Separate more fine mesh order
#' @param meshcode mesh code
#' @param order Choose mesh order
#' @param ... other parameters for paste
#' @return character vector
#' @examples 
#' \dontrun{
#' fine_separate(52350400, "harf")
#' fine_separate(52350400, "quarter")
#' fine_separate(52350400, "quarter", collapse = ",")
#' }
#' @export
fine_separate <- function(meshcode = NULL, order = c("harf", "quarter"), ...) {
  
  code9 <- paste0(meshcode, 1:4)
  
  res <- paste(code9, ...)
  
  if (order == "quarter") {
    code10 <- purrr::map(code9, paste0, 1:4) %>% 
      unlist()
    
    res <- paste(code10, ...)
  }
  
  return(res)
  
}
