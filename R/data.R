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

#' @title Meshcode include the prefecture
#' 
#' @description Japanese prefectures mesh dataset
#' @details  50km meshcode
#' @format A data frame with 240 rows 2 variables:
#' \itemize{
#'   \item{pref}
#'   \item{mesh}
#' }
"prefecture_mesh"
