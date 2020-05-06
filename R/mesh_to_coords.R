#' @title Get from mesh code to latitude and longitude
#' @description mesh centroid
#' @param meshcode `character`. mesh code
#' @param ... other parameters
#' @references Akio Takenaka: [http://takenaka-akio.org/etc/j_map/index.html](http://takenaka-akio.org/etc/j_map/index.html) # nolint
#' @seealso [coords_to_mesh()] for convert from coordinates to meshcode.
#' @examples
#' mesh_to_coords("64414277")
#' @export
mesh_to_coords <- function(meshcode, ...) { # nolint
  if (rlang::is_false(is_meshcode(meshcode)))
    rlang::abort("Unexpect meshcode value")
  size <- mesh_size(meshcode) # nolint
  if (size <= units::as_units(80, "km")) {
    code12 <- as.numeric(substring(meshcode, 1, 2))
    code34 <- as.numeric(substring(meshcode, 3, 4))
    lat_width  <- 2 / 3
    long_width <- 1
  }
  if (size <= units::as_units(10, "km")) {
    code5 <- as.numeric(substring(meshcode, 5, 5))
    code6 <- as.numeric(substring(meshcode, 6, 6))
    lat_width  <- lat_width / 8
    long_width <- long_width / 8
  }
  if (size == units::as_units(5, "km")) {
    km5_code7 <- as.numeric(substring(meshcode, 7, 7))
  }
  if (size <= units::as_units(1, "km")) {
    code7 <- as.numeric(substring(meshcode, 7, 7))
    code8 <- as.numeric(substring(meshcode, 8, 8))
    lat_width  <- lat_width / 10
    long_width <- long_width / 10
  }
  if (size <= units::as_units(0.5, "km"))
    code9 <- as.numeric(substring(meshcode, 9, 9))
  if (size <= units::as_units(0.25, "km"))
    code10 <- as.numeric(substring(meshcode, 10, 10))
  if (size <= units::as_units(0.125, "km"))
    code11 <- as.numeric(substring(meshcode, 11, 11))
  lat  <- code12 * 2 / 3
  long <- code34 + 100
  if (exists("code5") && exists("code6")) {
    lat  <- lat  + (code5 * 2 / 3) / 8
    long <- long +  code6 / 8
  }
  if (exists("code7") && exists("code8")) {
    lat  <- lat  + (code7 * 2 / 3) / 8 / 10
    long <- long +  code8 / 8 / 10
  }
  lat_c  <- as.numeric(sprintf("%.10f", lat  + lat_width  / 2))
  long_c <- as.numeric(sprintf("%.10f", long + long_width / 2))
  res <- data.frame(lng_center  = long_c,
                    lat_center  = lat_c,
                    lng_error   = long_c - long,
                    lat_error   = lat_c - lat)
  finename_centroid <- function(df, last_code) {
    if (last_code == 1) {
      df$lat_center <-
        (df$lat_center + df$lat_error) - (df$lat_error / 2) * 3
      df$lng_center <-
        (df$lng_center + df$lng_error) - (df$lng_error / 2) * 3
    } else if (last_code == 2) {
      df$lat_center <-
        (df$lat_center + df$lat_error) - (df$lat_error / 2) * 3
      df$lng_center <-
        (df$lng_center + df$lng_error) - (df$lng_error / 2)
    } else if (last_code == 3) {
      df$lat_center <-
        (df$lat_center + df$lat_error) - (df$lat_error / 2)
      df$lng_center <-
        (df$lng_center + df$lng_error) - (df$lng_error / 2) * 3
    } else if (last_code == 4) {
      df$lat_center <-
        (df$lat_center + df$lat_error) - (df$lat_error / 2)
      df$lng_center <-
        (df$lng_center + df$lng_error) - (df$lng_error / 2)
    }
    df$lat_error <- df$lat_error / 2
    df$lng_error <- df$lng_error / 2
    res <- df
    return(res)
  }
  if (exists("km5_code7"))
    res <- finename_centroid(res, km5_code7)
  if (exists("code9"))
    res <- finename_centroid(res, code9)
  if (exists("code10"))
    res <- finename_centroid(res, code10)
  if (exists("code11"))
    res <- finename_centroid(res, code11)
  tibble::as_tibble(res)
}
