#' @title Check include mesh areas
#' 
#' @description It roughly judges whether the given coordinates are within the mesh area.
#' @param longitude longitude (double)
#' @param latitude latitude (double)
#' @importFrom dplyr between if_else
#' @examples 
#' \dontrun{
#' eval_jp_boundary(139.71471056, 35.70128943)
#' }
#' @aliases eval_jp_boundary
#' @export
eval_jp_boundary <- function(longitude = NULL, 
                             latitude = NULL) {
  
  # ref) https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E7%AB%AF%E3%81%AE%E4%B8%80%E8%A6%A7
  res <- dplyr::if_else(
    dplyr::between(latitude,
                   20.0,
                   46.0) &
      dplyr::between(longitude,
                     120.0,
                     154.0),
    TRUE,
    FALSE
  )
  
  return(res)
}


mesh_to_poly <- function(lng_center, lat_center, lng_error, lat_error, ...) 
{
  res <- sf::st_polygon(list(rbind(c(lng_center - lng_error, 
                                     lat_center - lat_error), 
                                   c(lng_center + lng_error, 
                                     lat_center - lat_error), 
                                   c(lng_center +  lng_error, 
                                     lat_center + lat_error), 
                                   c(lng_center - lng_error, lat_center + lat_error), 
                                   c(lng_center - lng_error, lat_center - lat_error)))) %>% 
    sf::st_sfc() %>% 
    sf::st_as_text()
  return(res)
}
