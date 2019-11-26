context("convert to mesh code")

# Order 1 -----------------------------------------------------------------
test_that("from latitude and longitude to mesh 1", {
  res <- coords_to_mesh(133, 34, mesh_size = 80.000)
  expect_true(is.character(res))
  expect_equal(4, nchar(res))
  expect_equal(res, "5133")
  expect_warning(coords_to_mesh(141.3468, 35.68949))
  expect_warning(coords_to_mesh(153.429390000, -28.0070630000))
  expect_warning(coords_to_mesh(103.844763000, 1.2819450000))
  expect_warning(coords_to_mesh(100.479448544, 7.0091360000))
})

# Order 2 -----------------------------------------------------------------
test_that("from latitude and longitude to mesh 2", {
  res <- coords_to_mesh(133.875, 34.583333, mesh_size = 10.000)
  expect_true(is.character(res))
  expect_equal(6, nchar(res))
  expect_equal(res, "513367")
})

# Order 3 -----------------------------------------------------
test_that("from latitude and longitude to mesh 2", {
  res <- coords_to_mesh(133.9125, 34.65, mesh_size = 1.000)
  expect_true(is.character(res))
  expect_equal(8, nchar(res))
  expect_equal(res, "51337782")
  expect_equal(res, coords_to_mesh(133.9125, 34.65))
})

# Separete Mesh: harf -----------------------------------------
test_that("Separete to harf mesh", {
  res <- coords_to_mesh(139.301255, 35.442788,
                        mesh_size = 5.0)
  expect_equal(res, "5339121")
  res <- coords_to_mesh(139.301255, 35.442788,
                        mesh_size = 0.500)
  expect_true(is.character(res))
  expect_equal(9, nchar(res))
  expect_equal(res, "533912341")
})

# Separete Mesh: quarter ---------------------------------------
test_that("Separete to quarter mesh", {
  res <- coords_to_mesh(133.9125, 34.65, mesh_size = 0.250)
  expect_true(is.character(res))
  expect_equal(10, nchar(res))
  expect_equal(res, "5133778222")
  res <- coords_to_mesh(139.310654, 35.442893, mesh_size = 0.250)
  expect_equal(res, "5339123422")
  res <- coords_to_mesh(139.301706, 35.448767, mesh_size = 0.250)
  expect_equal(res, "5339123433")
  res <- coords_to_mesh(139.311340, 35.449011, mesh_size = 0.250)
  expect_equal(res, "5339123444")
})

test_that("125m", {
  res <- coords_to_mesh(133.9125, 34.65, mesh_size = 0.125)
  expect_equal(nchar(res), 11L)
  expect_equal(res, "51337782222")
})

# sfg object --------------------------------------------------------------
test_that("Input XY sfg", {
  skip_if_not_installed("sf")
  res <-
    coords_to_mesh(geometry = sf::st_point(c(139.71475, 35.70078)))
  expect_equal(res, "53394547")
  res <-
    coords_to_mesh(geometry = sf::st_point(c(139.71475, 35.70078)),
                   mesh_size = 0.500)
  expect_equal(res, "533945471")
  res <-
    coords_to_mesh(geometry = sf::st_point(c(130.4412895, 30.2984335)))
  expect_equal(res, coords_to_mesh(130.4412895, 30.2984335))
  expect_message(
    coords_to_mesh(130.4412895, 30.2984335,
                   geometry = sf::st_point(c(130.4412895, 30.2984335))),
    "only the geometry will be used")
  res <-
    administration_mesh(code = "08220", to_mesh_size = 1)
  suppressWarnings(res$geometry <- sf::st_centroid(res$geometry))
  res$meshcode_copy <-
    res %>%
    purrr::pmap_chr(., ~ coords_to_mesh(mesh_size = 1.000, geometry = ..2))
  suppressWarnings(res$geometry <-
                     sf::st_centroid(res$geometry))
  res$check <- all.equal(res$meshcode, res$meshcode_copy)
  expect_equal(sum(res$check == FALSE), 0)
})

test_that("vectorize", {
  res <- coords_to_mesh(
    longitude = c(140.1062, 139.7688),
    latitude = c(36.07917, 35.67917)
  )
  expect_length(res, 2L)
  expect_equal(res,
               c("54400098", "53394611"))
  meshes <- c("51337793", "54387643")
  d <- meshes %>%
    export_meshes()
  d$longitude <-
    purrr::pmap_dbl(d, ~ mesh_to_coords(..1)[[1]])
  d$latitude <-
    purrr::pmap_dbl(d, ~ mesh_to_coords(..1)[[2]])
  res <-
    coords_to_mesh(longitude = d$longitude,
                   latitude = d$latitude)
  expect_equal(res,
               coords_to_mesh(geometry = d$geometry))
  expect_equal(res,
               meshes)
})
