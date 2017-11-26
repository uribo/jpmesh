#' @title Simple displaed as rectangel for Japan (fortified)
#' 
#' @description Rectangle Japanese prefectures positions.
#' @format A data frame with 235 rows 11 variables:
#' \itemize{
#'   \item{long}
#'   \item{lat}
#'   \item{order}
#'   \item{hole}
#'   \item{piece}
#'   \item{id}
#'   \item{group}
#'   \item{mesh_code}
#'   \item{latitude}
#'   \item{longitude}
#'   \item{abb_name}
#' }
#' @examples 
#' \dontrun{
#' plot(jpnrect["abb_name"])
#' }
"jpnrect"

#' @title 1:200,000 Scale Maps Name with Meshcode of Japan.
#' 
#' @description Information for the 1:200,000 Scale Maps.
#' @format A data frame with 175 rows 9 variables:
#' \itemize{
#'   \item{meshcode: 80km meshcode}
#'   \item{name: names for map}
#'   \item{name_roman: names for map (roman)}
#'   \item{lng_center: centroid coordiates of mesh}
#'   \item{lat_center: centroid coordiates of mesh}
#'   \item{lng_error: mesh area}
#'   \item{lat_error: mesh area}
#'   \item{type: evalueate value to mesh}
#' }
#' @examples 
#' \dontrun{
#' plot(sf_jpmesh["name_roman"])
#' }
"sf_jpmesh"
