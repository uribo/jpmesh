#' Find out neighborhood meshes collection
#' @inheritParams mesh_to_coords
#' @param contains logical. contains input meshcode (default `TRUE`)
#' @description input should use meshcode under the 1km mesh size.
#' @return [meshcode][meshcode]
#' @examples
#' neighbor_mesh(53394501)
#' neighbor_mesh(533945011)
#' neighbor_mesh(533945011, contains = FALSE)
#' @rdname neighbor_mesh
#' @export
neighbor_mesh <- function(meshcode, contains = TRUE) {
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <- 
      meshcode(meshcode)    
  }
  size <- 
    mesh_size(meshcode)
  if (size < mesh_units[5]) {
    rlang::inform("Too small meshsize. Enable 80km to 500m size.")
  } else if (size >= mesh_units[4]) {
    find_neighbor_mesh(meshcode, contains = contains) # nolint
  } else if (size == mesh_units[5]) {
    find_neighbor_finemesh(meshcode, contains = contains) # nolint
  } else {
    NULL
  }
}

#' @rdname neighbor_mesh
#' @export
find_neighbor_mesh <- function(meshcode = NULL, contains = TRUE) { # nolint
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <- 
      meshcode(meshcode)
  }
  size <- 
    mesh_size(meshcode)
  mesh_code <- 
    as.numeric(vctrs::field(meshcode, "mesh_code"))
  # nolint start
  if (size == mesh_units[1]) {
    res <- 
      mesh_code - c(1, -1, 101, 100, 0, 99, -99, -100, -101)
  } else if (size == mesh_units[2]) {
    if (is_corner(meshcode)) {
      if (grepl("(00|70|07|77|0[1-6]|[1-6]7|[1-6]0|7[1-6])$", mesh_code)) {
        res <- mesh_code + 
          if (grepl("00$", mesh_code)) 
            c(0, 1, -83, 10, 11, -93, -10023, -9930, -9929)
          else if (grepl("07$", mesh_code))
            c(-1, 0, 93, 9, 10, 103, -9931, -9930, -9837)
          else if (grepl("70$", mesh_code))
            c(0, 1, 9930, 9931, -9, -10, -93, -83, -103)
          else if (grepl("77$", mesh_code))
            c(9929, 9930, 10023, -1, 0, 93, -11, -10, 83)
          else if (grepl("0[1-6]$", mesh_code))
            c(-1, 0, 1, 9, 10, 11, -9931, -9930, -9929)
          else if (grepl("[1-6]7$", mesh_code))
            c(-1, 0, 93, 9, 10, 103, -11, -10, 83)
          else if (grepl("[1-6]0$", mesh_code))
            c(0, 1, -9, -10, 11, 10, -83, -93, -103)    
          else if (grepl("7[1-6]$", mesh_code))
            c(-1, 0, 1, 9929, 9930, 9931, -11, -10, -9)    
      }} else
        res <- mesh_code + c(9, 10, 11, -1, 0, 1, -9, -10, -11)
    # Must be ends 1-7
    res <- unique(res[grepl("[8-9]$", res) == FALSE])  
  } else if (size == mesh_units[4]) {
    if (is_corner(mesh_code)) {
      if (grepl("(00|09|90|99|010[1-8]|[1-8]9|[1-8]0|9[1-8]|0[1-8])$", mesh_code)) {
        res <- 
          mesh_code - 
          if (grepl("0000$", mesh_code)) {
          c(9281, -10, -11, 9291, 0, -1, 1002201, 992910, 992909)
        } else if (grepl("0[1-9]00$", mesh_code)) {
          c(81, -10, -11, 91, 0, -1, 993001, 992910, 992909)
        } else if (grepl("[1-9]000$", mesh_code)) {
          c(9281, -10, -11, 9291, 0, -1, 10201, 910, 909)
        } else if (grepl("[0-9][1-9]00$", mesh_code)) {
          c(81, -10, -11, 91, 0, -1, 1001, 910, 909)
        } else if (grepl("[1-9][0-9]09$", mesh_code)) {
          c(-9, -10, -101, 1, 0, -91, 911, 910, 819) # 51331109 
        } else if (grepl("0[0-9]09$", mesh_code)) {
          c(-9, -10, -101, 1, 0, -91, 992911, 992910, 992819)
        } else if (grepl("0009$", mesh_code)) {
          c(-9, -10, -101, 1, 0, -91, 992911, 992910, 992819)
        } else if (grepl("[0-9][1-9]90$", mesh_code)) {
          c(-819, -910, -911, 91, 0, -1, 101, 10, 9)
        } else if (grepl("[0-9]090$", mesh_code)) {
          c(8381, -910, -911, 9291, 0, -1, 9301, 10, 9)
        } else if (grepl("99$", mesh_code)) {
          c(-909, -910, -1001, 1, 0, -91, 11, 10, -81)
        } else if (grepl("(0[1-9]0[1-8])$", mesh_code)) {
          c(-9, -10, -11, 1, 0, -1, 992911, 992910, 992909)
        } else if (grepl("([1-8]9)$", mesh_code)) {
          c(-9, -10, -101, 1, 0, -91, 11, 10, -81)
        } else if (grepl("[0-9][1-9][1-8]0$", mesh_code)) {
          c(81, -10, -11, 91, 0, -1, 101, 10, 9)
        } else if (grepl("[0-9]0[1-8]0$", mesh_code)) {
          c(9281, -10, -11, 9291, 0, -1, 9301, 10, 9)
        } else if (grepl("[0-6][0-9]9[1-8]$", mesh_code)) {
          c(-909, -910, -911, 1, 0, -1, 11, 10, 9) # 53394592
        } else if (grepl("7[0-9]9[1-8]$", mesh_code)) {
          c(-992909, -992910, -992911, 1, 0, -1, 11, 10, 9) # 65417592
        } else if (grepl("[1-9][0-9]0[1-8]$", mesh_code)) {
          c(-9, -10, -11, 1, 0, -1, 911, 910, 909)
        } else if (grepl("0[0-9]0[1-8]$", mesh_code)) {
          c(-9, -10, -11, 1, 0, -1, 992911, 992910, 992909)
        }
      }} else {
        res <- 
          mesh_code + c(9, 10, 11, -1, 0, 1, -9, -10, -11)
      }}
  # nolint end
  if (rlang::is_false(contains)) {
    res <- 
      res[res != mesh_code]
  }
  meshcode(unique(cut_off(res))) # nolint
}

find_neighbor_finemesh <- function(meshcode, contains = TRUE) {
  relate <- NULL
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <-
      meshcode(meshcode)
  }
  df_poly <-
    coarse_gather(meshcode) %>%
    find_neighbor_mesh() %>% # nolint
    bind_meshpolys()
  df_poly$n <- 
    seq_len(nrow(df_poly))
  # nolint start
  df_poly$relate <- 
    suppressWarnings(
      suppressMessages(
        sapply(df_poly$geometry, 
               sf::st_relate, 
               y = sf::st_buffer(
                 df_poly$geometry[which(
                   vctrs::field(df_poly$meshcode, "mesh_code") == vctrs::field(meshcode, "mesh_code"))], 
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
    neighbor <- 
      subset(df_poly, relate %in% c("212101212", "2FF1FF212"))$meshcode # nolint
    if (rlang::is_false(contains))
      neighbor <- 
      neighbor[!vctrs::field(neighbor, "mesh_code") %in% vctrs::field(meshcode, "mesh_code")]
    return(neighbor)
}
