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
#' @return [meshcode][meshcode]
#' @export
fine_separate <- function(meshcode = NULL, ...) {
  .x <- .y <- NULL
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <-
      meshcode(meshcode)
  }
  purrr::map2(
      vctrs::field(meshcode, "mesh_code"),
      vctrs::field(meshcode, "mesh_size"),
      function(meshcode = .x, mesh_size = .y) {
        if (mesh_size == 80) {
            meshcode_vector(paste0(meshcode,
                                     rep(seq.int(0, 7), each = 8),
                                     rep(seq.int(0, 7), times = 8)),
                              size = rep(10, 64))
          } else if (mesh_size == 10) {
            meshcode_vector(
                paste0(meshcode,
                       rep(seq.int(0, 9), each = 10),
                       rep(seq.int(0, 9), times = 10)),
                size = rep(1, 100)
              )
          } else if (mesh_size >= 0.1 & mesh_size <= 1) {
            meshcode_vector(
                paste0(meshcode, seq_len(4)),
                size = rep(as.numeric(mesh_units)[which(as.numeric(mesh_units) %in% mesh_size) + 1],
                           4))
          } else {
            rlang::inform("A value greater than the supported mesh size was inputed.") # nolint
            NA_character_
          }
        }
    ) %>% 
    purrr::reduce(c)
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
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <-
      meshcode(meshcode)
  }
  res <-
    purrr::map(seq_len(length(meshcode)),
               function(x) {
                 if (vctrs::field(meshcode[x], "mesh_size") == 0.5) {
                   substr(vctrs::field(meshcode[x], "mesh_code"), 1, 8)
                 } else if (vctrs::field(meshcode[x], "mesh_size") %in% c(1, 5)) {
                   substr(vctrs::field(meshcode[x], "mesh_code"), 1, 6)
                 } else if (vctrs::field(meshcode[x], "mesh_size") == 10) {
                   substr(vctrs::field(meshcode[x], "mesh_code"), 1, 4)
                 }})
  if (rlang::is_true(distinct)) {
    res <- 
      unique(res)
  }
  meshcode(res)
}
