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

mesh_harf <- function(d = NULL, code = code) {
  
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

fine_mesh_to_latlon <- function(code) {
  
  code <- as.character(code)
  
  # 80km mesh
  if (length(grep("^[0-9]{4}", code)) == 1) {
    code12 <- as.numeric(substring(code, 1, 2))
    code34 <- as.numeric(substring(code, 3, 4))
    lat_width  <- 2 / 3
    long_width <- 1
  }
  else {
    return(NULL)
  }
  
  # 10km mesh
  if (length(grep("^[0-9]{6}", code)) == 1) {
    code5 <- as.numeric(substring(code, 5, 5))
    code6 <- as.numeric(substring(code, 6, 6))
    lat_width  <- lat_width / 8
    long_width <- long_width / 8
  }
  
  # 1km mesh
  if (length(grep("^[0-9]{8}", code)) == 1) {
    code7 <- as.numeric(substring(code, 7, 7))
    code8 <- as.numeric(substring(code, 8, 8))
    lat_width  <- lat_width / 10
    long_width <- long_width / 10
  }
  
  # 500m mesh
  if (length(grep("^[0-9]{9}", code)) == 1) {
    code9 <- as.numeric(substring(code, 9, 9))
    lat_width  <- lat_width / 2
    long_width <- long_width / 2
  }
  
  # 250m mesh
  if (length(grep("^[0-9]{10}", code)) == 1) {
    code10 <- as.numeric(substring(code, 10, 10))
    lat_width  <- lat_width / 2
    long_width <- long_width / 2
  }
  
  # 125m mesh
  if (length(grep("^[0-9]{11}", code)) == 1) {
    code11 <- as.numeric(substring(code, 11, 11))
    lat_width  <- lat_width / 2
    long_width <- long_width / 2
  }
  
  # Below, the coordinates of the southwestern corner are obtained
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
  
  lat.c  <- lat  + lat_width  / 2
  long.c <- long + long_width / 2
  
  lat.c  <- as.numeric(sprintf("%.10f", lat.c))
  long.c <- as.numeric(sprintf("%.10f", long.c))
  
  res <- data.frame(lat_center  = lat.c, 
                    long_center = long.c, 
                    lat_error   = lat.c - lat,
                    long_error  = long.c - long)

  if (exists("code9")) {
    
    lat.e <- res$lat_error
    lng.e <- res$long_error
    
    lng.p <- res$long_center + lng.e
    lat.p <- res$lat_center + lat.e
    
    lng.n <- res$long_center - lng.e
    lat.n <- res$lat_center - lat.e
    
    if (code9 == 4L) {
      d <- data.frame(
        lng1 = lng.p + lng.e,
        lat1 = lat.p + lat.e,
        lng2 = lng.p - lng.e,
        lat2 = lat.p - lat.e)
    } else if (code9 == 3L) {
      d <- data.frame(
        lng1 = lng.n + lng.e,
        lat1 = lat.p + lat.e,
        lng2 = lng.n - lng.e,
        lat2 = lat.p - lat.e)
    } else if (code9 == 2L) {
      d <- data.frame(
        lng1 = lng.p + lng.e,
        lat1 = lat.n + lat.e,
        lng2 = lng.p - lng.e,
        lat2 = lat.n - lat.e)
    } else if (code9 == 1L) {
      d <- data.frame(
        lng1 = lng.n + lng.e,
        lat1 = lat.n + lat.e,
        lng2 = lng.n - lng.e,
        lat2 = lat.n - lat.e)
    }
    
    res <- data.frame(
      lat_center = d$lat2 + (d$lat1 - d$lat2),
      long_center = d$lng2 + (d$lng1 - d$lng2),
      lat_error = (d$lat1 - d$lat2),
      long_error = (d$lng1 - d$lng2))
    
    if (exists("code10")) {
      
      lat.e <- res$lat_error
      lng.e <- res$long_error
      
      lng.p <- res$long_center + lng.e
      lat.p <- res$lat_center + lat.e
      
      lng.n <- res$long_center - lng.e
      lat.n <- res$lat_center - lat.e
      
      if (code10 == 4L) {
        d <- data.frame(lng1 = lng.p + lng.e,
                        lat1 = lat.p + lat.e,
                        lng2 = lng.p - lng.e,
                        lat2 = lat.p - lat.e)
      } else if (code10 == 3L) {
        d <- data.frame(lng1 = lng.n + lng.e,
                        lat1 = lat.p + lat.e,
                        lng2 = lng.n - lng.e,
                        lat2 = lat.p - lat.e)
      } else if (code10 == 2L) {
        d <- data.frame(lng1 = lng.p + lng.e,
                        lat1 = lat.n + lat.e,
                        lng2 = lng.p - lng.e,
                        lat2 = lat.n - lat.e)
      } else if (code10 == 1L) {
        d <- data.frame(lng1 = lng.n + lng.e,
                        lat1 = lat.n + lat.e,
                        lng2 = lng.n - lng.e,
                        lat2 = lat.n - lat.e)
      }
      
      res <- data.frame(lat_center = d$lat2 + (d$lat1 - d$lat2),
                        long_center = d$lng2 + (d$lng1 - d$lng2),
                        lat_error = (d$lat1 - d$lat2),
                        long_error = (d$lng1 - d$lng2))
      
      if (exists("code11")) {
        
        lat.e <- res$lat_error
        lng.e <- res$long_error
        
        lng.p <- res$long_center + lng.e
        lat.p <- res$lat_center + lat.e
        
        lng.n <- res$long_center - lng.e
        lat.n <- res$lat_center - lat.e
        
        if (code11 == 4L) {
          d <- data.frame(lng1 = lng.p + lng.e,
                          lat1 = lat.p + lat.e,
                          lng2 = lng.p - lng.e,
                          lat2 = lat.p - lat.e)
        } else if (code11 == 3L) {
          d <- data.frame(lng1 = lng.n + lng.e,
                          lat1 = lat.p + lat.e,
                          lng2 = lng.n - lng.e,
                          lat2 = lat.p - lat.e)
        } else if (code11 == 2L) {
          d <- data.frame(lng1 = lng.p + lng.e,
                          lat1 = lat.n + lat.e,
                          lng2 = lng.p - lng.e,
                          lat2 = lat.n - lat.e)
        } else if (code11 == 1L) {
          d <- data.frame(lng1 = lng.n + lng.e,
                          lat1 = lat.n + lat.e,
                          lng2 = lng.n - lng.e,
                          lat2 = lat.n - lat.e)
        }
        
        res <- data.frame(lat_center = d$lat2 + (d$lat1 - d$lat2),
                          long_center = d$lng2 + (d$lng1 - d$lng2),
                          lat_error = (d$lat1 - d$lat2),
                          long_error = (d$lng1 - d$lng2))
        
      }
    }
  }
  
  return(res)
}

#' generate null variables for jpmesh
#' @param df data frame
bundle_mesh_vars <- function(df) {
  long_center <- long_error <- lat_center <- lat_error <- NULL

    res <- dplyr::mutate(df,
                       lng1 = long_center - long_error,
                       lat1 = lat_center - lat_error,
                       lng2 = long_center + long_error,
                       lat2 = lat_center + lat_error)
    
    return(res)
  
}

poly_to_geojson <- function(df) {
  
  i <- NULL
  
  list.polygons <- foreach(i = 1:nrow(df)) %do% {
    sp::Polygons(
      list(sp::Polygon(
        cbind(
          c(df[i, ]$lng1, df[i, ]$lng1, df[i, ]$lng2, df[i, ]$lng2, df[i, ]$lng1),
          c(df[i, ]$lat2, df[i, ]$lat1, df[i, ]$lat1, df[i, ]$lat2, df[i, ]$lat2)))),
      df[i, ]$mesh_code)
  }
  str.geojson <- geojsonio::geojson_json(sp::SpatialPolygons(Srl = list.polygons, pO = 1:nrow(df)), geometry = "polygon")
  
  return(str.geojson)
}
