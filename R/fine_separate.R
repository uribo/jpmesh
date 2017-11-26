#' @title Separate more fine mesh order
#' 
#' @description Return contains fine mesh codes
#' @param meshcode mesh code
#' @param order Choose mesh order
#' @param ... other parameters for paste
#' @return character vector
#' @importFrom purrr map
#' @examples 
#' fine_separate(52350400, "harf")
#' fine_separate(52350400, "quarter")
#' fine_separate(52350400, "quarter", collapse = ",")
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
