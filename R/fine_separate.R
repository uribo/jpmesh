#' @title Separate more fine mesh order
#' 
#' @description Return contains fine mesh codes
#' @inheritParams mesh_to_coords
#' @param ... other parameters for paste
#' @return character vector
#' @importFrom purrr map
#' @importFrom rlang inform
#' @examples 
#' fine_separate(5235)
#' fine_separate(523504)
#' fine_separate(52350432)
#' fine_separate(523504321)
#' fine_separate(5235043211)
#' @export
fine_separate <- function(meshcode = NULL, ...) {
  
  if (is.mesh(meshcode))
  mesh_length <- nchar(meshcode)
  
  res <- if (mesh_length == 4) {
    res <- paste0(meshcode,
                rep(0:7, each = 8),
                rep(0:7, times = 8))
  } else if (mesh_length == 6) {
    res <- paste0(meshcode,
                  rep(0:9, each = 10),
                  rep(0:9, times = 10))
    } else if (mesh_length >= 8 & mesh_length <= 10) {
      res <- paste0(meshcode, 1:4)
  } else {
    rlang::inform("A value greater than the supported mesh size was inputed.")
    NA_character_
  }

  return(res)
  
}
