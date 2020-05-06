#' Find out neighborhood meshes collection
#' @inheritParams mesh_to_coords
#' @param contains logical. contains input meshcode (default `TRUE`)
#' @description input should use meshcode under the 1km mesh size.
#' @return mesh code vectors (`character`)
#' @examples
#' neighbor_mesh(53394501)
#' neighbor_mesh(533945011)
#' neighbor_mesh(533945011, contains = FALSE)
#' @rdname neighbor_mesh
#' @export
neighbor_mesh <- function(meshcode, contains = TRUE) {
  if (rlang::is_false(is_meshcode(meshcode))) { # nolint
    rlang::abort("Unexpect meshcode value")
  }
  size <- mesh_size(meshcode) # nolint
  if (size < units::as_units(0.5, "km")) {
    rlang::inform("Too small meshsize. Enable 80km to 500m size.")
  }
  res <- if (size >= units::as_units(1, "km")) {
    find_neighbor_mesh(meshcode, contains = contains) # nolint
  } else if (size == units::as_units(0.5, "km")) {
    find_neighbor_finemesh(meshcode, contains = contains) # nolint
  } else {
    NULL
  }
  return(res)
}

#' @rdname neighbor_mesh
#' @export
find_neighbor_mesh <- function(meshcode = NULL, contains = TRUE) { # nolint
  meshcode <- as.numeric(meshcode)
  size <- mesh_size(meshcode) # nolint
  # nolint start
  if (size == units::as_units(80, "km")) {
    res <- meshcode - c(1, -1, 101, 100, 0, 99, -99, -100, -101)
  } else if (size == units::as_units(10, "km")) {
    if (is_corner(meshcode)) {
      if (grepl("(00|70|07|77|0[1-6]|[1-6]7|[1-6]0|7[1-6])$", meshcode)) {
        res <- meshcode + 
          if (grepl("00$", meshcode)) 
            c(0, 1, -83, 10, 11, -93, -10023, -9930, -9929)
          else if (grepl("07$", meshcode))
            c(-1, 0, 93, 9, 10, 103, -9931, -9930, -9837)
          else if (grepl("70$", meshcode))
            c(0, 1, 9930, 9931, -9, -10, -93, -83, -103)
          else if (grepl("77$", meshcode))
            c(9929, 9930, 10023, -1, 0, 93, -11, -10, 83)
          else if (grepl("0[1-6]$", meshcode))
            c(-1, 0, 1, 9, 10, 11, -9931, -9930, -9929)
          else if (grepl("[1-6]7$", meshcode))
            c(-1, 0, 93, 9, 10, 103, -11, -10, 83)
          else if (grepl("[1-6]0$", meshcode))
            c(0, 1, -9, -10, 11, 10, -83, -93, -103)    
          else if (grepl("7[1-6]$", meshcode))
            c(-1, 0, 1, 9929, 9930, 9931, -11, -10, -9)    
      }} else
        res <- meshcode + c(9, 10, 11, -1, 0, 1, -9, -10, -11)
    # Must be ends 1-7
    res <- unique(res[grepl("[8-9]$", res) == FALSE])  
  } else if (size == units::as_units(1, "km")) {
    if (is_corner(meshcode)) {
      if (grepl("(00|09|90|99|010[1-8]|[1-8]9|[1-8]0|9[1-8]|0[1-8])$", meshcode)) {
        res <- 
          meshcode - 
          if (grepl("0000$", meshcode)) {
          c(9281, -10, -11, 9291, 0, -1, 1002201, 992910, 992909)
        } else if (grepl("0[1-9]00$", meshcode)) {
          c(81, -10, -11, 91, 0, -1, 993001, 992910, 992909)
        } else if (grepl("[1-9]000$", meshcode)) {
          c(9281, -10, -11, 9291, 0, -1, 10201, 910, 909)
        } else if (grepl("[0-9][1-9]00$", meshcode)) {
          c(81, -10, -11, 91, 0, -1, 1001, 910, 909)
        } else if (grepl("[1-9][0-9]09$", meshcode)) {
          c(-9, -10, -101, 1, 0, -91, 911, 910, 819) # 51331109 
        } else if (grepl("0[0-9]09$", meshcode)) {
          c(-9, -10, -101, 1, 0, -91, 992911, 992910, 992819)
        } else if (grepl("0009$", meshcode)) {
          c(-9, -10, -101, 1, 0, -91, 992911, 992910, 992819)
        } else if (grepl("[0-9][1-9]90$", meshcode)) {
          c(-819, -910, -911, 91, 0, -1, 101, 10, 9)
        } else if (grepl("[0-9]090$", meshcode)) {
          c(8381, -910, -911, 9291, 0, -1, 9301, 10, 9)
        } else if (grepl("99$", meshcode)) {
          c(-909, -910, -1001, 1, 0, -91, 11, 10, -81)
        } else if (grepl("(0[1-9]0[1-8])$", meshcode)) {
          c(-9, -10, -11, 1, 0, -1, 992911, 992910, 992909)
        } else if (grepl("([1-8]9)$", meshcode)) {
          c(-9, -10, -101, 1, 0, -91, 11, 10, -81)
        } else if (grepl("[0-9][1-9][1-8]0$", meshcode)) {
          c(81, -10, -11, 91, 0, -1, 101, 10, 9)
        } else if (grepl("[0-9]0[1-8]0$", meshcode)) {
          c(9281, -10, -11, 9291, 0, -1, 9301, 10, 9)
        } else if (grepl("[0-6][0-9]9[1-8]$", meshcode)) {
          c(-909, -910, -911, 1, 0, -1, 11, 10, 9) # 53394592
        } else if (grepl("7[0-9]9[1-8]$", meshcode)) {
          c(-992909, -992910, -992911, 1, 0, -1, 11, 10, 9) # 65417592
        } else if (grepl("[1-9][0-9]0[1-8]$", meshcode)) {
          c(-9, -10, -11, 1, 0, -1, 911, 910, 909)
        } else if (grepl("0[0-9]0[1-8]$", meshcode)) {
          c(-9, -10, -11, 1, 0, -1, 992911, 992910, 992909)
        }
      }} else {
        res <- meshcode + c(9, 10, 11, -1, 0, 1, -9, -10, -11)
      }}
  # nolint end
  if (rlang::is_false(contains)) {
    res <- res[res != meshcode]
  }
  neighbor <- unique(cut_off(res)) # nolint
  return(neighbor)
}

find_neighbor_finemesh <- function(meshcode, contains = TRUE) {
  relate <- NULL
  df_poly <-
    coarse_gather(meshcode) %>%
    find_neighbor_mesh() %>% # nolint
    purrr::map(bind_meshpolys) %>%
    purrr::reduce(rbind)
  df_poly$n <- seq_len(nrow(df_poly))
  # nolint start
  df_poly$relate <- 
    suppressWarnings(
      suppressMessages(
        sapply(df_poly$geometry, 
               sf::st_relate, 
               y = sf::st_buffer(
                 df_poly$geometry[which(df_poly$meshcode == meshcode)], 
                 dist = 0.00005), 
               sparse = FALSE)))
  if (length(df_poly$meshcode[df_poly$relate %in% c("212101212", "2FF1FF212")]) != 9) { # nolint
      df_poly$relate <- 
        suppressWarnings(
          suppressMessages(
            sapply(df_poly$geometry, 
                   sf::st_relate, 
                   y = sf::st_buffer(
                     df_poly$geometry[which(df_poly$meshcode == meshcode)], 
                     dist = 0.0002), 
                   sparse = FALSE)))  
  }
  # nolint end
    neighbor <- subset(df_poly, relate %in% c("212101212", "2FF1FF212"))$meshcode # nolint
    if (rlang::is_false(contains))
      neighbor <- neighbor[!neighbor %in% meshcode]
    return(neighbor)
}
