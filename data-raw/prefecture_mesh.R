#########################################
# 47都道府県がどのメッシュに該当するか
#########################################
devtools::load_all(".")
library(sf)
library(tidyverse) # dplyr, purrr, tidyr
library(jpndistrict)
library(testthat)

code_1_20 <- c(3036,
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

jpmesh.bind <- c(code_1_20) %>%
  purrr::map(jpmesh::meshcode_to_latlon) %>%
  purrr::map_df(jpmesh:::bundle_mesh_vars) %>%
  mutate(meshcode = jpmesh::latlong_to_meshcode(lat = lat_center, long = long_center, order = 1) %>% as.character())
expect_equal(dim(jpmesh.bind), c(176, 9))

sf.jpmesh <- jpmesh.bind %>%
  purrrlyr::by_row(mk_poly) %>%
  use_series(.out) %>%
  st_sfc()
expect_s3_class(sf.jpmesh, c("sfc_POLYGON", "sfc"))

# plot(spdf_jpn_pref(1)["city_name"])
# plot(sf.jpmesh %>% st_set_crs(4326), add = TRUE)

sf.jpmesh2 <- sf.jpmesh %>%
  as("Spatial") %>%
  st_as_sf() %>%
  mutate(meshcode = jpmesh.bind$meshcode)
expect_s3_class(sf.jpmesh2, c("sf", "data.frame"))
expect_named(sf.jpmesh2, c("meshcode", "geometry"))

filter_mesh_df <- sf.jpmesh2[tibble::tibble(
  res_contains = st_contains(sf.jpmesh %>% st_set_crs(4326), # 41
                             jpndistrict::spdf_jpn_pref(1) %>% st_transform(4326))
) %>%
  mutate(id = row_number()) %>%
  tidyr::unnest() %>%
  use_series(id) %>% unique(), ]

export_pref_all_mesh <- function(code = 1) {
  sf.jpmesh2[tibble::tibble(
    res_contains = st_contains(sf.jpmesh %>% st_set_crs(4326),
                               jpndistrict::spdf_jpn_pref(code = sprintf("%02d", code)) %>% st_transform(4326))
  ) %>%
    mutate(id = row_number()) %>%
    tidyr::unnest() %>%
    use_series(id) %>% unique(), ] %>% 
    use_series(meshcode) %>% unique()
}

# export_pref_all_mesh(1)
# export_pref_all_mesh(2)

prefecture_mesh <- tibble::tibble(
  pref = sprintf("%02d", 1:47),
  mesh = 1:47 %>% 
    purrr::map(export_pref_all_mesh)
) %>% tidyr::unnest()
expect_s3_class(prefecture_mesh, c("tbl", "data.frame"))
expect_equal(dim(prefecture_mesh), c(240, 2))
expect_named(prefecture_mesh, c("pref", "mesh"))

devtools::use_data(prefecture_mesh, overwrite = TRUE)

