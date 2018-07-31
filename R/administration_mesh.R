#' Extract administration mesh
#' 
#' @param code administration code
#' @param type administration type. Should be one of "prefecture" or "city".
#' @examples 
#' \dontrun{
#' administration_mesh(code = c(35201), type = "city")
#' administration_mesh(code = "08220", type = "city")
#' administration_mesh(code = c("08220", "08221"), type = "city")
#' administration_mesh(code = 35, type = "prefecture")
#' administration_mesh(code = c(33, 34), type = "prefecture")
#' }
#' @name administration_mesh
#' @export
administration_mesh <- function(code, type = c("city", "prefecture")) {

  . <- city_code <- meshcode <- NULL
  
  if (type == "prefecture") {
    df_city_mesh$meshcode <- substr(df_city_mesh$meshcode, 1, 6)
  }

  target <- 
    paste(sprintf(paste0("%0", nchar(code), "d"), as.numeric(code)), collapse = "|")
  
  subset(df_city_mesh, 
         grepl(paste0("^(", target, ")"), 
               city_code)) %>% 
    .$meshcode %>% 
    unique() %>% 
    export_meshes()
}
