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
  checked_code <- code_reform(code)
  # nolint start
  mis_match <- checked_code[!checked_code %in% c(sprintf("%02d", seq_len(47)), unique(df_city_mesh$city_code))] # nolint
  if (rlang::is_false(identical(mis_match, character(0)))) {
    rlang::inform(
      paste(length(mis_match), "matching code were not found."))
    checked_code <- checked_code[!checked_code %in% mis_match]
  }
  if (length(purrr::map_chr(checked_code, 
                            ~ substr(.x, 1, 2)) %>% 
             unique()) < length(checked_code))
    rlang::inform("The city and the prefecture including it was givend.\nWill return prefecture meshes.") # nolint
  if (type == "prefecture") {
    df_city_mesh$meshcode <- substr(df_city_mesh$meshcode, 1, 6)
  }
    purrr::map(checked_code,
               ~ subset(df_city_mesh, 
               grepl(paste0("^(", .x, ")"), 
                     city_code)) %>% 
        purrr::pluck("meshcode")) %>% 
    purrr::flatten_chr() %>% 
    unique() %>% 
    purrr::map(
      ~ export_meshes(.x)  
    ) %>% 
    purrr::reduce(rbind)
    # nolint end
}
