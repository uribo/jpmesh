#' Find out neighborhood meshes collection
#' 
#' @inheritParams mesh_to_coords
#' @param contains logical. contains input meshcode (default `TRUE`)
#' @description input should use meshcode under the 1km mesh size.
#' @return mesh code vectors (`character`)
#' @examples 
#' neighbor_mesh(53394501)
#' neighbor_mesh(533945011)
#' neighbor_mesh(533945011, contains = FALSE)
#' @name neighbor_mesh
#' @export
neighbor_mesh <- function(meshcode, contains = TRUE) {
  
  if (!is_meshcode(meshcode)) {
    stop("Unexpect meshcode value")
  }
  
  size <- mesh_size(meshcode)
  
  res <- if (size >= units::as.units(1, "km")) {
    find_neighbor_mesh(meshcode, contains = contains)  
  } else if (size == units::as.units(0.5, "km")) {
    find_neighbor_finemesh(meshcode, contains = contains)
  }
  
  return(res)
}

find_neighbor_mesh <- function(meshcode = NULL, contains = TRUE) {
  
  meshcode <- as.numeric(meshcode)
  size <- mesh_size(meshcode)

  if (size == units::as.units(80, "km")) {
    res <- meshcode - c(1, -1, 101, 100, 0, 99, -99, -100, -101)
  } else if (size == units::as.units(10, "km")) {
    if (is_corner(meshcode)) {
      if (grepl("(00|70|07|77|0[1-6]|[1-6]7|[1-6]0|7[1-6])$", meshcode)) {
        res <- dplyr::case_when(
          grepl("00$", meshcode) ~ c(meshcode) + c(0, 1, -83, 10, 11, -93, -10023, -9930, -9929),
          grepl("07$", meshcode) ~ c(meshcode) + c(-1, 0, 1, 9, 10, 11, -9931, -9930, -9929),
          grepl("70$", meshcode) ~ c(meshcode) + c(0, 1, 9930, 9931, -9, -10, -93, -83, -103),
          grepl("77$", meshcode) ~ c(meshcode) + c(9929, 9930, 10023, -1, 0, 93, -11, -10, 83),
          grepl("0[1-6]$", meshcode) ~ c(meshcode) + c(-1, 0, 1, 9, 10, 11, -9931, -9930, -9929),
          grepl("[1-6]7$", meshcode) ~ c(meshcode) + c(-1, 0, 1, 9, 10, 11, -9, -10, -11),
          grepl("[1-6]0$", meshcode) ~ c(meshcode) + c(0, 1, -9, -10, 11, 10, -83, -93, -103),
          grepl("7[1-6]$", meshcode) ~ c(meshcode) + c(-1, 0, 1, 9929, 9930, 9931, -11, -10, -9))
      }} else {
        res <- meshcode + c(9, 10, 11, -1, 1, -9, -10, -11)
      }
    # Must be ends 1-7
    res <- res[grepl("[8-9]$", res) == FALSE] %>%
      unique()
  } else if (size == units::as.units(1, "km")) {
    
    if (is_corner(meshcode)) {
      if (grepl("(00|09|90|99|010[1-8]|[1-8]9|[1-8]0|9[1-8]|0[1-8])$", meshcode)) {

        res <- dplyr::case_when(
          grepl("0000$", meshcode) ~ c(meshcode) - c(9281, -10, -11, 9291, 0, -1, 1002201, 992910, 992909),
          grepl("0[1-9]00$", meshcode) ~ c(meshcode) - c(81, -10, -11, 91, 0, -1, 993001, 992910, 992909),
          grepl("[1-9]000$", meshcode) ~ c(meshcode) - c(9281, -10, -11, 9291, 0, -1, 10201, 910, 909),
          grepl("[0-9][1-9]00$", meshcode) ~ c(meshcode) - c(81, -10, -11, 91, 0, -1, 1001, 910, 909),
          grepl("[1-9][0-9]09$", meshcode) ~ c(meshcode) - c(-9, -10, -101, 1, 0, -91, 911, 910, 819), # 51331109 
          grepl("0[0-9]09$", meshcode) ~ c(meshcode) - c(-9, -10, -101, 1, 0, -91, 992911, 992910, 992819), 
          grepl("0009$", meshcode) ~ c(meshcode) - c(-9, -10, -101, 1, 0, -91, 992911, 992910, 992819), 
          grepl("[0-9][1-9]90$", meshcode) ~ c(meshcode) - c(-819, -910, -911, 91, 0, -1, 101, 10, 9),
          grepl("[0-9]090$", meshcode) ~ c(meshcode) - c(8381, -910, -911, 9291, 0, -1, 9301, 10, 9),
          grepl("99$", meshcode) ~ c(meshcode) - c(-909, -910, -1001, 1, 0, -91, 11, 10, -81),
          grepl("(0[1-9]0[1-8])$", meshcode) ~ c(meshcode) - c(-9, -10, -11, 1, 0, -1, 992911, 992910, 992909),
          grepl("([1-8]9)$", meshcode) ~ c(meshcode) - c(-9, -10, -101, 1, 0, -91, 11, 10, -81),
          grepl("[0-9][1-9][1-8]0$", meshcode) ~ c(meshcode) - c(81, -10, -11, 91, 0, -1, 101, 10, 9),
          grepl("[0-9]0[1-8]0$", meshcode) ~ c(meshcode) - c(9281, -10, -11, 9291, 0, -1, 9301, 10, 9),
          grepl("9[1-8]$", meshcode) ~ meshcode - c(-909, -910, -911, 1, 0, -1, 11, 10, 9), # 53394592
          grepl("[1-9][0-9]0[1-8]$", meshcode) ~ meshcode - c(-9, -10, -11, 1, 0, -1, 911, 910, 909),
          grepl("0[0-9]0[1-8]$", meshcode) ~ meshcode - c(-9, -10, -11, 1, 0, -1, 992911, 992910, 992909)
        )
        
      }} else {
        res <- meshcode + c(9, 10, 11, -1, 0, 1, -9, -10, -11)
      }}
  
  if (rlang::is_false(contains)) {
    res <- res[res != meshcode]
  }
  
  neighbor <- cut_off(res) %>% unique()
  
  return(neighbor)
}

find_neighbor_finemesh <- function(meshcode, contains = TRUE) {
  
  . <- NULL
  meshcode <- as.numeric(meshcode)
  size <- mesh_size(meshcode)
  
  if (size == units::as.units(0.5, "km")) {
    df_poly <- substr(meshcode, 1, nchar(meshcode) - 1) %>% 
      find_neighbor_mesh() %>% 
      purrr::map(bind_meshpolys) %>% 
      purrr::reduce(rbind)
    
    touches_row <- 
      suppressMessages(
        1:nrow(df_poly) %>% 
          purrr::map_dbl(., ~ sum(as.numeric(sf::st_touches(df_poly[.x, ],
                                                            df_poly[which(
                                                              df_poly$meshcode == meshcode), "geometry"])))))
    
    neighbor <- df_poly %>% 
      dplyr::slice(c(which(!is.na(touches_row))))
    
    neighbor <- neighbor$meshcode
    
    if (rlang::is_true(contains)) {
      neighbor <- c(neighbor, meshcode)
    }
    
    return(neighbor)
    
  }
} 
