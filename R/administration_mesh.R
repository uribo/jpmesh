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

  rlang::arg_match(type)
  
  . <- city_code <- NULL
  
  # [todo] replace to jpndistrict:::admins_code_validate in the future
  if (code[1] %>% purrr::map_lgl(
    purrr::negate(~ nchar(.x) %in% c(1, 2, 5))) == TRUE) {
    rlang::abort("Input code must to 2 or 5 digits.")
  }
  
  if (nchar(code[1]) == 1)
    code <- 
      sprintf("%02d", as.numeric(code[1]))

  if (nchar(code[1]) == 2) 
    code_nchar <- 2
  if (nchar(code[1]) == 5)
    code_nchar <- 5

  if (code_nchar == 2) 
    if (code[1] %in% sprintf("%02d", seq(1, 47, by = 1)) == FALSE)
      rlang::abort("Input prefecture code must to range from 1 to 47.")
  
  if (type == "prefecture") {
    df_city_mesh$meshcode <- substr(df_city_mesh$meshcode, 1, 6)
  }
  
  target <- 
    paste(sprintf(paste0("%0", code_nchar, "d"), as.numeric(code)), collapse = "|")
  
  subset(df_city_mesh, 
         grepl(paste0("^(", target, ")"), 
               city_code)) %>% 
    .$meshcode %>% 
    unique() %>% 
    export_meshes()
}
