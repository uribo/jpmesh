# Construction ------------------------------------------------------------
#' Vector of meshcode
#' 
#' @param x input meshcode value
#' @param size input meshcode size. Default set to `NULL`. The decision is 
#' automatically made based on the `meshsize`.
#' @param ... path to another function
#' @rdname meshcode
#' @export
meshcode_vector <- function(x = character(), size = double()) {
  vctrs::vec_assert(x, character())
  vctrs::vec_assert(size, double())
  x <- 
    x %>% 
    purrr::map_chr(
      function(x) {
        if (
          grepl(
            paste0(
              "^(",
              paste(meshcode_80km_num, 
                    collapse = "|"),
              ")"
            ), x)) {
          x
        } else {
          rlang::abort("A meshcode out of range is given") 
        }})
  check_correct_meshsize(x, size)
  vctrs::new_rcrd(
    list(mesh_code = x, mesh_size = size), 
    class = "meshcode")
}

#' @rdname meshcode
#' @export
meshcode <- function(x, size = NULL) {
  mesh_length <- .x <- NULL
  if (is.null(size)) {
    size <- 
      units::drop_units(mesh_length(as.character(nchar(x))))
  }
  meshcode_vector(as.character(x), rep(size, length(x)))
}

#' @rdname meshcode
#' @export
as_meshcode <- function(x, ...) {
  size <-
    units::drop_units(mesh_length(as.character(nchar(x))))
  meshcode_vector(x, size = size)
}

#' @export
as.character.meshcode <- function(x, ...) {
  vctrs::field(x, "mesh_code")
}

input_mesh_check <- function(x, y) {
  mesh_length <- NULL
  res <- 
    nrow(subset(df_mesh_size_unit, subset = mesh_length == nchar(x) & as.numeric(mesh_size) == y))
  if (res > 0) {
    TRUE
  } else {
    FALSE
  }
}

check_correct_meshsize <- function(x, size) {
  .x <- .y <- NULL
  res <- 
    sum(purrr::map2_lgl(
      x,
      size,
      ~ input_mesh_check(.x, .y)), 
      na.rm = TRUE)
  if (res != length(x))
    rlang::abort("There is a mismatch in the length and size of the meshcord.")
}

# Output ------------------------------------------------------------------
#' @rdname meshcode
#' @export
format.meshcode <- function(x, ...) {
  x_valid <- which(!is.na(x))
  mesh <- vctrs::field(x, "mesh_code")[x_valid]
  res <-
    format(as.character(mesh), justify = "right")
  res
}
