#' @title Separate more fine mesh order
#' 
#' @description Return contains fine mesh codes
#' @param mesh mesh code
#' @param ... other parameters for paste
#' @return character vector
#' @importFrom purrr map
#' @examples 
#' fine_separate(52350400)
#' fine_separate(52350400)
#' fine_separate(52350400)
#' @export
fine_separate <- function(mesh = NULL, ...) {
  
  mesh_length <- nchar(mesh)
  
  res <- if (between(mesh_length, 4, 8)) {
    res <- paste0(mesh,
                rep(1:8, each = 8),
                rep(1:8, times = 8))
  } else if (between(mesh_length, 9, 10)) {
    paste0(mesh, 1:4)

  } else {
    NA_character_
  }

  return(res)
  
}
