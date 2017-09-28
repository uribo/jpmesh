#' Extract administration mesh
#' 
#' @param code administration code
#' @param type administration type. Should be one of "prefecture" or "city".
#' @import dplyr
#' @import sf
#' @importFrom magrittr use_series
#' @importFrom purrrlyr by_row
#' @examples 
#' \dontrun{
#' administration_mesh(code = c(35201))
#' administration_mesh(code = c(35), type = "prefecture")
#' administration_mesh(code = c(33, 34), type = "prefecture")
#' }
#' @name administration_mesh
#' @export
administration_mesh <- function(code, type = c("prefecture")) {
  
  city_code <- mesh_code <- .out <- NULL
  
  if (type == "prefecture") {
    df_city_mesh <- df_city_mesh %>% 
      dplyr::mutate(mesh_code = substr(mesh_code, 1, 6))  
  }
  
  df.origin <- df_city_mesh %>% 
    dplyr::filter(grepl(paste0("^(", paste(code, collapse = "|"), ")"), city_code))
  
  df.pref.mesh.geo <- df.origin %>% 
    dplyr::distinct(mesh_code) %>% 
    mesh_rectangle(code = "mesh_code") %>% 
    purrrlyr::by_row(mk_poly) %>%
    magrittr::use_series(.out) %>%
    sf::st_sfc() %>% 
    tibble::as_data_frame()
  
  res <- df.origin %>% 
    dplyr::distinct(mesh_code) %>% 
    dplyr::bind_cols(df.pref.mesh.geo) %>% 
    dplyr::left_join(df.origin, by = "mesh_code") %>% 
    sf::st_as_sf()
  
  return(res)
}
