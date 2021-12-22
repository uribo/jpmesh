#' @title Check include mesh areas
#' @description It roughly judges whether the given coordinates are within
#' the mesh area.
#' @inheritParams coords_to_mesh
#' @param ... other parameters
#' @examples
#' eval_jp_boundary(139.71471056, 35.70128943)
#' @aliases eval_jp_boundary
#' @export
eval_jp_boundary <- function(longitude = NULL, latitude = NULL, ...) {
  ifelse(
    ifelse(latitude >= 20.0 & latitude <= 46.0, TRUE, FALSE) &
      ifelse(longitude >= 120.0 & longitude <= 154.0, TRUE, FALSE),
    TRUE,
    FALSE
  )
}

mesh_to_poly <- function(lng_center, lat_center, lng_error, lat_error, ...) {
  sf::st_polygon(list(rbind(c(lng_center - lng_error,
                              lat_center - lat_error),
                            c(lng_center + lng_error,
                              lat_center - lat_error),
                            c(lng_center +  lng_error,
                              lat_center + lat_error),
                            c(lng_center - lng_error,
                              lat_center + lat_error),
                            c(lng_center - lng_error,
                              lat_center - lat_error)))) %>%
    sf::st_sfc(crs = 4326) %>%
    sf::st_as_text()
}

#' @title Identifier to mesh size
#' @description Returns a unit object of mesh size for the given number.
#' @inheritParams mesh_to_coords
#' @inheritParams meshcode_vector
#' @examples 
#' mesh_size("6740")
#' @export
mesh_size <- function(meshcode, .type = "standard") {
  if (is_meshcode(meshcode) == FALSE) {
    meshcode <- 
      meshcode(meshcode, .type)
  }
  mesh_size <- 
    as.character(vctrs::field(meshcode, "mesh_size"))
  res <- 
    purrr::map(
      mesh_size,
      ~ switch(.x,
               "80" = mesh_units[1],
               "10" = mesh_units[2],
               "5" = mesh_units[3],
               "1" = mesh_units[4],
               "0.5" = mesh_units[5],
               "0.25" = mesh_units[6],
               "0.125" = mesh_units[7],
               "0.1" = mesh_units[8])) %>% 
    purrr::reduce(c)
  if (rlang::is_null(res)) {
    res <- 
      units::as_units(NA_integer_, "km")
  }
  res
}

mesh_units <- 
  units::as_units(
    c(80.000, 10.000, 5.000, 1.000, 0.500, 0.250, 0.125, 0.100), 
    "km") # nolint

df_mesh_size_unit <-
  tibble::tibble(
    mesh_length = c(4L, 6L, 7L, 8L, 9L, 10L, 11L, 10L),
    mesh_size = mesh_units)

meshcode_80km_num <-
  c(3036,
    3622, 3623, 3624, 3631, 3641, 3653,
    3724, 3725, 3741,
    3823, 3824, 3831, 3841,
    3926, 3927, 3928, 3942,
    4027, 4028, 4040, 4042,
    4128, 4129, 4142,
    4229, 4230,
    4328, 4329,
    4429, 4440,
    4529, 4530, 4531, 4540,
    4629, 4630, 4631,
    4728, 4729, 4730, 4731, 4739, 4740,
    4828, 4829, 4830, 4831, 4839,
    4928, 4929, 4930, 4931, 4932, 4933, 4934, 4939,
    5029, 5030, 5031, 5032, 5033, 5034, 5035, 5036, 5038, 5039,
    5129, 5130, 5131, 5132, 5133, 5134, 5135, 5136, 5137, 5138, 5139,
    5229, 5231, 5232, 5233, 5234, 5235, 5236, 5237, 5238, 5239, 5240,
    5332, 5333, 5334, 5335, 5336, 5337, 5338, 5339, 5340,
    5432, 5433, 5435, 5436, 5437, 5438, 5439, 5440,
    5531, 5536, 5537, 5538, 5539, 5540, 5541,
    5636, 5637, 5638, 5639, 5640, 5641,
    5738, 5739, 5740, 5741,
    5839, 5840, 5841,
    5939, 5940, 5941, 5942,
    6039, 6040, 6041,
    6139, 6140, 6141,
    6239, 6240, 6241, 6243,
    6339, 6340, 6341, 6342, 6343,
    6439, 6440, 6441, 6442, 6443, 6444, 6445,
    6540, 6541, 6542, 6543, 6544, 6545, 6546,
    6641, 6642, 6643, 6644, 6645, 6646, 6647,
    6740, 6741, 6742, 6747, 6748,
    6840, 6841, 6842, 6847, 6848)

meshcode_set_80km <- 
  meshcode_vector(
    as.character(meshcode_80km_num), 
    size = rep(80, length(meshcode_80km_num)))

#' @title Export meshcode vectors ranges 80km to 1km.
#' @description Unique 176 meshcodes.
#' The output code may contain values not found in the actual mesh code.
#' @param mesh_size Export mesh size from 80km to 1km.
#' @param .raw return as character.
#' @examples
#' meshcode_set(mesh_size = 80)
#' meshcode_set(mesh_size = 80, .raw = FALSE)
#' @return character or [meshcode][meshcode]
#' @export
meshcode_set <- 
  memoise::memoise(
    function(mesh_size = c(80, 10, 1), .raw = TRUE) {
      if (mesh_size == 80) {
        meshcode_80km <- 
          as.character(meshcode_80km_num)
      } else {
        meshcode_10km <- 
          as.character(meshcode_80km_num) %>% 
          purrr::map(
            ~ paste0(.x,
                     sprintf("%02s",
                             sort(paste0(rep(seq.int(0, 7), each = 8), seq.int(0, 7))))
            )) %>% 
          purrr::flatten_chr()
      }
      if (mesh_size == 1) {
        meshcode_1km <- 
          meshcode_10km %>% 
          purrr::map(
            ~ paste0(.x,
                     sprintf("%02d", seq.int(0, 99))
            )) %>% 
          purrr::flatten_chr()
      }
      if (.raw == TRUE) {
        if (mesh_size == 80) {
          meshcode_80km
        } else if (mesh_size == 10) {
          meshcode_10km
        } else if (mesh_size == 1) {
          meshcode_1km
        }
      } else {
        if (mesh_size == 80) {
          meshcode_set_80km
        } else if (mesh_size <= 10) {
          meshcode_set_10km <- 
            meshcode_set_80km %>% 
            fine_separate()
          if (mesh_size == 10) {
            meshcode_set_10km
          } else if (mesh_size == 1) {
            meshcode_set_10km %>% 
              fine_separate()
          }
        }
      }
    }
  )

#' @title Cutoff mesh of outside the area
#' @inheritParams mesh_to_coords
cut_off <- function(meshcode) {
  if (is_meshcode(meshcode) == TRUE) {
    meshcode <- 
      vctrs::field(meshcode, "mesh_code")
  }
  mesh_80km <- 
    meshcode %>% 
    substr(1, 4)
  res <- 
    meshcode[mesh_80km %in% meshcode_set(80, .raw = TRUE)]
  if (length(res) < length(meshcode)) {
    rlang::warn("Some neighborhood meshes are outside the area.")
  }
  sort(res)
}

validate_neighbor_mesh <- function(meshcode) {
  df_bbox <-
    find_neighbor_mesh(meshcode) %>%
    export_meshes()
  df_bbox <-
    df_bbox %>%
    sf::st_sf() %>%
    sf::st_union() %>%
    sf::st_bbox()
  tibble::tibble(
    xlim = as.numeric(df_bbox[3] - df_bbox[1]),
    ylim = as.numeric(df_bbox[4] - df_bbox[2]))
}

bind_meshpolys <- function(meshcode) {
  meshcode %>%
    fine_separate() %>%
    unique() %>%
    export_meshes(.keep_class = TRUE)
}

code_reform <- function(jis_code) {
  . <- NULL
  checked <-
    jis_code %>%
    purrr::map(nchar) %>%
    purrr::keep(~ .x %in% c(1, 2, 5)) %>%
    length()
  if (length(jis_code) != checked)
    rlang::abort("Input jis-code must to 2 or 5 digits.")
  jis_code %>%
    purrr::map(as.numeric) %>%
    purrr::map_if(.p = nchar(.) %in% c(1, 2), ~ sprintf("%02d", .x)) %>%
    purrr::map_if(.p = nchar(.) %in% c(4, 5), ~ sprintf("%05d", .x)) %>%
    purrr::flatten_chr()
}

mesh_length <- function(mesh_length) {
  if (length(unique(mesh_length)) == 1L) {
    switch(unique(mesh_length),
           "4" = mesh_units[1],
           "6" = mesh_units[2],
           "7" = mesh_units[3],
           "8" = mesh_units[4],
           "9" = mesh_units[5],
           "10" = mesh_units[6],
           "11" = mesh_units[7],
           "10" = mesh_units[8])
  } else {
    mesh_length %>% 
      purrr::map_dbl(
        ~ switch(.x,
                 "4" = mesh_units[1],
                 "6" = mesh_units[2],
                 "7" = mesh_units[3],
                 "8" = mesh_units[4],
                 "9" = mesh_units[5],
                 "10" = mesh_units[6],
                 "11" = mesh_units[7],
                 "10" = mesh_units[8])) 
  }
}
