#' Extract administration mesh code
#'
#' @param code administration code
#' @inheritParams mesh_convert
#' @examples
#' \dontrun{
#' administration_mesh(code = "35201", to_mesh_size = 1)
#' administration_mesh(code = "08220", to_mesh_size = 80)
#' administration_mesh(code = c("08220", "08221"), to_mesh_size = 10)
#' administration_mesh(code = "35", to_mesh_size = 80)
#' administration_mesh(code = c("33", "34"), to_mesh_size = 80)
#' }
#' @name administration_mesh
#' @export
administration_mesh <- function(code, to_mesh_size) {
  city_code <- NULL
  to_mesh_size_chr <-
    as.character(to_mesh_size)
  rlang::arg_match(to_mesh_size_chr,
                   c("80", "10", "1", "0.5", "0.25", "0.125", "0.1"))
  to_mesh_size <-
    units::as_units(as.numeric(to_mesh_size), "km")
  checked_code <-
    code_reform(code)
  mis_match <-
    checked_code[!checked_code %in% c(sprintf("%02d", seq_len(47)),
                                      unique(df_city_mesh$city_code))]
  if (rlang::is_false(identical(mis_match, character(0))))
    rlang::inform(paste(length(mis_match), "matching code were not found."))
  checked_code <- 
    checked_code[!checked_code %in% mis_match]
  if (length(unique(nchar(checked_code))) > 1)
    rlang::inform("The city and the prefecture including it was givend.\nWill return prefecture's meshes.") # nolint
  res_meshes <-
    purrr::map(checked_code,
               memoise::memoise(
                 function(.x) {
                   subset(df_city_mesh,
                          grepl(paste0("^(", .x, ")"),
                                city_code)) %>%
                     purrr::pluck("meshcode")
                 }
               )) %>%
    purrr::flatten_chr() %>%
    unique()
  if (to_mesh_size == mesh_units[1]) {
    res_meshes <-
      res_meshes %>%
      substr(1, 4)
  } else if (to_mesh_size == mesh_units[2]) {
    res_meshes <-
      res_meshes %>%
      substr(1, 6)
  } else if (to_mesh_size <= mesh_units[5] & to_mesh_size >= mesh_units[7]) {
    res_meshes <- 
      res_meshes %>% 
      purrr::map(
        ~ mesh_convert(.x, to_mesh_size = units::drop_units(to_mesh_size))) %>% 
      purrr::reduce(c)
  } else if (to_mesh_size == mesh_units[8]) {
    res_meshes <-
      res_meshes %>% 
      fine_separate(.type = "subdivision")
  }
  res_meshes %>%
    unique() %>%
    export_meshes()
}
