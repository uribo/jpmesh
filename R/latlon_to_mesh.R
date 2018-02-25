#' @title Convert from coordinate to mesh code
#' 
#' @description From coordinate to mesh codes.
#' @param longitude longitude that approximately to .120.0 to 154.0 (`double`)
#' @param latitude latitude that approximately to 20.0 to 46.0 (`double`)
#' @param mesh_size mesh type. From 80km to 125m
#' @param ... other parameters
#' @importFrom dplyr case_when
#' @importFrom rlang is_true quo_expr warn
#' @return mesh code (default 3rd meshcode aka 1km mesh)
#' @references Akio Takenaka: [http://takenaka-akio.org/etc/j_map/index.html](http://takenaka-akio.org/etc/j_map/index.html)
#' @seealso [mesh_to_coords()] for convert from meshcode to coordinates
#' @examples 
#' coords_to_mesh(141.3468, 43.06462, mesh_size = "10km")
#' coords_to_mesh(139.6917, 35.68949, mesh_size = "250m")
#' coords_to_mesh(139.71475, 35.70078)
#' @export
coords_to_mesh <- function(longitude, latitude, mesh_size = "1km", ...) {
  
  longitude <- rlang::quo_expr(longitude)
  latitude <- rlang::quo_expr(latitude)
  
  coords_evalated <- eval_jp_boundary(longitude, latitude)

  if (coords_evalated == TRUE) {
    code12 <- (latitude * 60) %/% 40
    code34 <- as.integer(longitude - 100)
    
    check_80km_ares <- paste0(code12, code34) %>% 
      match(meshcode_set(mesh_size = "80km")) %>% 
      any()
    
    if (rlang::is_true(check_80km_ares)) {
   
      code_a <- (latitude * 60) %% 40
      
      code5 <- code_a %/% 5
      code_b <- code_a %% 5
      
      code7 <- (code_b * 60) %/% 30
      code_c <- (code_b * 60) %% 30
      
      code_s <- code_c %/% 15
      code_d <- code_c %% 15
      code_t <- code_d %/% 7.5
      code_e <- code_d %% 7.5
      code_u <- code_e %/% 3.75
      
      code_f <- (longitude - 100) - as.integer(longitude - 100)
      
      code6 <- (code_f * 60) %/% 7.5
      code_g <- (code_f * 60) %% 7.5
      
      code8 <- (code_g * 60) %/% 45
      code_h <- (code_g * 60) %% 45
      
      code_x <- code_h %/% 22.5
      code_i <- code_h %% 22.5
      code_y <- code_i %/% 11.25
      code_j <- code_i %% 11.25
      code_z <- code_j %/% 5.625
      
      code9 <- (code_s * 2) + (code_x + 1)
      code10 <- (code_t * 2) + (code_y + 1)
      code11 <- (code_u * 2) + (code_z + 1)
      
      meshcode <- paste0(code12, code34, 
                         code5, code6, 
                         code7, code8, 
                         code9, code10, code11)
      
      mesh_sets <- list(
        mesh_size == "80km" ~ substr(meshcode, 1, 4),
        mesh_size == "10km" ~ substr(meshcode, 1, 6),
        mesh_size == "1km" ~ substr(meshcode, 1, 8),
        mesh_size == "500m" ~ substr(meshcode, 1, 9),
        mesh_size == "250m" ~ substr(meshcode, 1, 10),
        mesh_size == "125m" ~ meshcode
      )
      
      meshcode <- dplyr::case_when(
        !!! mesh_sets
      )
      
      return(meshcode)   
    } else if (is.na(check_80km_ares)) {
      rlang::warn("Longitude / Latitude values is out of range.")
      return(NA_character_)
    }
    } else if (coords_evalated == FALSE) {
      rlang::warn("Longitude / Latitude values is out of range.")
      return(NA_character_)
    }
}
