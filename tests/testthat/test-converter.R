test_that("scale up", {
  res <- 
    mesh_convert(meshcode = "52350432", to_mesh_size = 80)
  expect_equal(res, meshcode(5235))
  res <- 
    mesh_convert("36536166", to_mesh_size = 10)
  expect_equal(res,
               mesh_convert(res, to_mesh_size = 10))
  res <- 
    mesh_convert("52350432", to_mesh_size = 10)
  expect_equal(mesh_size(res), units::as_units(10, "km"))
  res_area <- 
    res %>%
    export_meshes() %>%
    sf::st_area()
  expect_equal(res_area,
               units::as_units(10000000, "m2"),
               tolerance = 0.906)
  meshcode <- "52350432"
  expect_identical(meshcode(meshcode),
                   mesh_convert(meshcode, 1))
})
test_that("scale down", {
  res <- 
    mesh_convert(meshcode = "53386166", to_mesh_size = 0.5)
  expect_equal(
    res,
    fine_separate("53386166"))
  expect_equal(
    res,
    mesh_convert("53386166"))
  res <- 
    mesh_convert("52350432", 0.250)
  expect_length(res, 16L)
  res <- 
    mesh_convert(meshcode = "52350432", 0.125)
  res_area <- 
    res %>%
    export_meshes() %>%
    sf::st_union() %>%
    sf::st_area()
  expect_length(res, 64L)
  expect_equal(res_area,
               units::as_units(100000, "m2"),
               tolerance = 0.906)
  meshcode <- "523504323"
  expect_equal(mesh_convert(meshcode, 0.250),
               meshcode(paste0(meshcode, seq_len(4))))
  meshcode <- "3641"
  expect_length(
    mesh_convert(meshcode, 10),
    64L)
  expect_length(
    mesh_convert(meshcode, 1),
    6400L)
  meshcode <- "523504321"
  expect_equal(
    mesh_convert(meshcode, 1),
    meshcode(substr(meshcode, 1, nchar(meshcode) - 1)))
  meshcode <- "5235043211"
  expect_equal(
    mesh_convert(meshcode, 0.5),
    meshcode(
      c(meshcode,
        paste0(substr(meshcode, 1, nchar(meshcode) - 1), seq.int(2, 4)))
    ))
  expect_length(
    mesh_convert(meshcode, 0.125),
    4L)
  res <-
    mesh_convert(64414315, 0.1)
  expect_length(
    res,
    100L
  )
  expect_s3_class(
    res,
    "subdiv_meshcode"
  )
})
