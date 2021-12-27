context("convert to mesh code")

# Order 1 -----------------------------------------------------------------
test_that("from latitude and longitude to mesh 1", {
  res <- 
    coords_to_mesh(133, 34, to_mesh_size = 80.000)
  expect_true(is_meshcode(res))
  expect_equal(
    nchar(vctrs::field(res, "mesh_code")),
    4L)
  expect_equal(res, meshcode("5133"))
  expect_warning(coords_to_mesh(141.3468, 35.68949))
  expect_warning(coords_to_mesh(153.429390000, -28.0070630000))
  expect_warning(coords_to_mesh(103.844763000, 1.2819450000))
  expect_warning(coords_to_mesh(100.479448544, 7.0091360000))
})

# Order 2 -----------------------------------------------------------------
test_that("from latitude and longitude to mesh 2", {
  res <- 
    coords_to_mesh(133.875, 34.583333, to_mesh_size = 10.000)
  expect_true(is_meshcode(res))
  expect_equal(
    nchar(vctrs::field(res, "mesh_code")),
               6L)
  expect_equal(res, meshcode("513367"))
})

# Order 3 -----------------------------------------------------
test_that("from latitude and longitude to mesh 2", {
  res <- 
    coords_to_mesh(133.9125, 34.65, to_mesh_size = 1.000)
  expect_true(is_meshcode(res))
  expect_equal(
    nchar(vctrs::field(res, "mesh_code")),
    8L)
  expect_equal(res,
               meshcode(51337782))
  expect_equal(res, 
               coords_to_mesh(133.9125, 34.65))
})


# Irregular ---------------------------------------------------------------
test_that("Error", {
  res <-
    expect_warning(.coord2mesh(NA, NA, to_mesh_size = 1))
  expect_equal(res, NA_character_)
})


# Separete Mesh: harf -----------------------------------------
test_that("Separete to harf mesh", {
  res <- 
    coords_to_mesh(139.301255, 35.442788,
                   to_mesh_size = 5.0)
  expect_equal(res, 
               meshcode(5339121))
  res <- 
    coords_to_mesh(139.301255, 35.442788,
                   to_mesh_size = 0.500)
  expect_true(is_meshcode(res))
  expect_equal(
    nchar(vctrs::field(res, "mesh_code")),
    9L)
  expect_equal(res,
               meshcode("533912341"))
})

# Separete Mesh: quarter ---------------------------------------
test_that("Separete to quarter mesh", {
  res <- 
    coords_to_mesh(133.9125, 34.65, to_mesh_size = 0.250)
  expect_true(is_meshcode(res))
  expect_equal(
    nchar(vctrs::field(res, "mesh_code")),
    10L)
  expect_equal(res, 
               meshcode("5133778222"))
  res <- 
    coords_to_mesh(139.310654, 35.442893, to_mesh_size = 0.250)
  expect_equal(res, 
               meshcode("5339123422"))
  res <-
    coords_to_mesh(139.301706, 35.448767, to_mesh_size = 0.250)
  expect_equal(res, 
               meshcode("5339123433"))
  res <- 
    coords_to_mesh(139.311340, 35.449011, to_mesh_size = 0.250)
  expect_equal(res,
               meshcode("5339123444"))
})

test_that("125m", {
  res <- 
    coords_to_mesh(133.9125, 34.65, to_mesh_size = 0.125)
  expect_equal(
    nchar(vctrs::field(res, "mesh_code")), 
    11L)
  expect_equal(res, 
               meshcode("51337782222"))
})

test_that("100m", {
  res <- 
    coords_to_mesh(139.71475, 35.70078, to_mesh_size = 0.1)
  expect_is(res, "subdiv_meshcode")
  expect_equal(
    res,
    meshcode("5339454701", .type = "subdivision")
  )
})

# sfg object --------------------------------------------------------------
test_that("Input XY sfg", {
  skip_if_not_installed("sf")
  res <-
    coords_to_mesh(geometry = sf::st_point(c(139.71475, 35.70078)))
  expect_equal(res,
               meshcode("53394547"))
  res <-
    coords_to_mesh(geometry = sf::st_point(c(139.71475, 35.70078)),
                   to_mesh_size = 0.500)
  expect_equal(res, 
               meshcode("533945471"))
  res <-
    coords_to_mesh(geometry = sf::st_point(c(130.4412895, 30.2984335)))
  expect_equal(res, 
               coords_to_mesh(130.4412895, 30.2984335))
  expect_message(
    coords_to_mesh(130.4412895, 30.2984335,
                   geometry = sf::st_point(c(130.4412895, 30.2984335))),
    "only the geometry will be used")
  res <-
    administration_mesh(code = "08220", to_mesh_size = 1)
  suppressWarnings(res$geometry <- sf::st_centroid(res$geometry))
  res$meshcode_copy <-
    coords_to_mesh(to_mesh_size = 1.000, geometry = res$geometry)
  suppressWarnings(res$geometry <-
                     sf::st_centroid(res$geometry))
  res$check <- all.equal(res$meshcode, 
                         as.character(res$meshcode_copy))
  expect_equal(sum(res$check == FALSE), 0)
})

test_that("vectorize", {
  res <- 
    coords_to_mesh(
    longitude = c(140.1062, 139.7688),
    latitude = c(36.07917, 35.67917)
  )
  expect_length(res, 2L)
  expect_equal(res,
               meshcode(c("54400098", "53394611")))
  meshes <- c("51337793", "54387643")
  d <- 
    meshes %>%
    export_meshes()
  d$longitude <-
    purrr::pmap_dbl(d, ~ mesh_to_coords(..1)[[2]])
  d$latitude <-
    purrr::pmap_dbl(d, ~ mesh_to_coords(..1)[[3]])
  res <-
    coords_to_mesh(longitude = d$longitude,
                   latitude = d$latitude)
  expect_equal(res,
               coords_to_mesh(geometry = d$geometry))
  expect_equal(res,
               meshcode(meshes))
})
