#' @title Separate more fine mesh order
#' @description Return contains fine mesh codes
#' @inheritParams mesh_to_coords
#' @param ... other parameters for paste
#' @return character vector
#' @importFrom purrr map
#' @importFrom rlang inform
#' @examples
#' fine_separate("5235")
#' fine_separate("523504")
#' fine_separate("52350432")
#' fine_separate("523504321")
#' fine_separate("5235043211")
#' @return meshcode as `character`
#' @export
fine_separate <- function(meshcode = NULL, ...) {
  if (is_meshcode(meshcode))
    mesh_length <- nchar(meshcode)
  res <- if (mesh_length == 4) {
    res <- paste0(meshcode,
                  rep(seq.int(0, 7), each = 8),
                  rep(seq.int(0, 7), times = 8))
  } else if (mesh_length == 6) {
    res <- paste0(meshcode,
                  rep(seq.int(0, 9), each = 10),
                  rep(seq.int(0, 9), times = 10))
  } else if (mesh_length >= 8 & mesh_length <= 10) {
    res <- paste0(meshcode, seq_len(4))
  } else {
    rlang::inform("A value greater than the supported mesh size was inputed.") # nolint
    NA_character_
  }
  return(res)
}

#' @title Gather more coarse mesh
#' @description Return coarse gather mesh codes
#' @inheritParams mesh_to_coords
#' @param distinct return unique meshcodes
#' @return character vector
#' @importFrom purrr map_chr
#' @importFrom rlang is_true
#' @importFrom units as_units
#' @examples
#' m <- c("493214294", "493214392", "493215203", "493215301")
#' coarse_gather(m)
#' coarse_gather(coarse_gather(m))
#' coarse_gather(coarse_gather(m), distinct = TRUE)
#' @return meshcode as `character`
#' @export
coarse_gather <- function(meshcode, distinct = FALSE) {
  res <- purrr::map_chr(meshcode, function(x) {
    if (mesh_size(x) == units::as_units(0.5, "km")) {
      substr(x, 1, 8)
    } else if (mesh_size(x) %in% units::as_units(c(1, 5), "km")) {
      substr(x, 1, 6)
    } else if (mesh_size(x) == units::as_units(10, "km")) {
      substr(x, 1, 4)
    }
  }
  )
  if (rlang::is_true(distinct))
    res <- unique(res)
  return(res)
}
