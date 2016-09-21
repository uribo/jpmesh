detect_gird_area <- function(d = NULL, code = NULL){
  
  lat.e <- d$lat_error / 2
  lng.e <- d$long_error / 2
  
  lng.p <- d$long_center + lng.e
  lat.p <- d$lat_center + lat.e
  
  lng.n <- d$long_center - lng.e
  lat.n <- d$lat_center - lat.e
  
  if (code == 4) {
    res <- data.frame(lng1 = lng.p + lng.e,
                      lat1 = lat.p + lat.e,
                      lng2 = lng.p - lng.e,
                      lat2 = lat.p - lat.e)
  } else if (code == 3) {
    res <- data.frame(lng1 = lng.n + lng.e,
                      lat1 = lat.p + lat.e,
                      lng2 = lng.n - lng.e,
                      lat2 = lat.p - lat.e)
  } else if (code == 2) {
    res <- data.frame(lng1 = lng.p + lng.e,
                      lat1 = lat.n + lat.e,
                      lng2 = lng.p - lng.e,
                      lat2 = lat.n - lat.e)
  } else if (code == 1) {
    res <- data.frame(lng1 = lng.n + lng.e,
                      lat1 = lat.n + lat.e,
                      lng2 = lng.n - lng.e,
                      lat2 = lat.n - lat.e)
  }
  
  return(res)
  
}

mesh_harf <- function(d = NULL, code = code9) {
  
  res <- detect_gird_area(d, code)
  
  return(res)
}

mesh_to_latlon2 <- function(d = NULL, code = NULL) {
  
  d <- data.frame(lat_center = d$lat2 + (d$lat1 - d$lat2) / 2,
                  long_center = d$lng2 + (d$lng1 - d$lng2) / 2,
                  lat_error = (d$lat1 - d$lat2) / 2,
                  long_error = (d$lng1 - d$lng2) / 2)
  
  res <- detect_gird_area(d, code)
  return(res)
}
