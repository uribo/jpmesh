#' Find out neighborhood meshes collection
#' 
#' @param mesh meshcode (under the 1km mesh size)
#' @param contains logical. contains input meshcode
#' @examples 
#' find_neighbor_mesh(53394501)
#' find_neighbor_mesh(533945011)
#' find_neighbor_mesh(533945011, contains = FALSE)
#' @name find_neighbor_mesh
#' @export
find_neighbor_mesh <- function(mesh = NULL, contains = TRUE) {
  
  mesh <- as.numeric(mesh)
  
  last_meshcode <- substr(mesh, nchar(mesh), nchar(mesh))

  if (nchar(mesh) == 4) {
    # res1 <- mesh - c(101, 100, 99)
    # res2 <- mesh - c(1, -1)
    # res3 <- mesh + c()
    res <- mesh - c(1, -1, 101, 100, 99,  -99, -100, -101)
  } else if (nchar(mesh) == 6) {
    if (last_meshcode == 7) {
      res <- mesh + c(9, 10, 93, 103, 83, -1, -11, -10)
    } else if (last_meshcode == 0) {
      res <- mesh + c(1, 10, 11, -10, -9, -83, -93, -103)
    } else {
      res <- mesh + c(1, -1, 9, 10, 11, -11, -10, -9)
    }
  } else if (nchar(mesh) == 8) {
    if (last_meshcode == 0) {
      res <- mesh + c(-81, 10:11, -91, 1, -101, -9:-10)
    } else if (last_meshcode == 9) {
      res <- mesh + c(9:10, 101, -1, 91, -11, -10, 81)
    } else {
      res <- mesh + c(9:11, -1, 1, -9:-11)  
    }  
  } else if (nchar(mesh) > 8) {
    if (last_meshcode == 1) {
      res <- mesh + c(1:3, -97:-98, -9, -7, -107)
      # res1 <- mesh + 1:3
      # res2 <- (mesh - 100) + 2:3
      # res3 <- (mesh - 10) + c(1, 3)
      # res4 <- (mesh - 110) + 3
    } else if (last_meshcode == 2) {
      res <- mesh + c(-1, 1:2, 11, 9, -98:-99, -89)
      # res1 <- mesh + c(-1, 1, 2)
      # res2 <- (mesh + 10) + c(-1, 1)
      # res3 <- (mesh - 100) + 1:2
      # res4 <- (mesh - 90) + 1
    } else if (last_meshcode == 3) {
      res <- mesh + c(-2:-1, 1, 98:99, -11, -9, 89) 
      # res1 <- mesh + c(-2:-1, 1)
      # res2 <- (mesh + 100) + c(-1:-2)
      # res3 <- (mesh - 10) + c(-1, 1)
      # res4 <- (mesh + 90)  - 1
    } else if (last_meshcode == 4) {
      res <- mesh + c(-1:-3, 9, 7, 107, 97:98)
      # res1 <- mesh - 3:1
      # res2 <- (mesh + 10) + c(-1, -3)
      # res3 <- (mesh + 110) + c(-3)
      # res4 <- (mesh + 100) + c(-2, -3)
    }
  }
  
  if (contains == TRUE) {
    res <- c(mesh, res)
  }
  
  res <- sort(res)
  
  return(res)
}
