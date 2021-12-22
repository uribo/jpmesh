context("meshcode export as geojson")

test_that("typeof", {
  res <- 
    export_mesh(53375084)
  expect_s3_class(res, c("sfc_POLYGON"))
  expect_type(res, "list")
  expect_doppelganger(
    "export-mesh-1km",
    plot(res, col = "white"))
  expect_equal(sf::st_crs(
    export_mesh(sample(meshcode_set(80), 1)))$epsg, 
               4326) # nolint
  res <- 
    export_meshes(c(51324305, 51381043),
                  .keep_class = TRUE)
  expect_is(res$meshcode, "meshcode")
})

test_that("Convert include meshcode dataframe to sf", {
  d <- 
    data.frame(id = seq.int(4),
              meshcode = rmesh(4),
              stringsAsFactors = FALSE)
  res <- 
    meshcode_sf(d, meshcode)
  expect_s3_class(res, "sf")
  expect_named(res, c("id", "meshcode", "geometry"))
})

test_that("Create mesh grid", {
  res <-
    st_mesh_grid(513404944, to_mesh_size = 0.5)
  expect_s3_class(res, "sfc")
  expect_length(res, 4L)
  expect_error(st_mesh_grid(543352, to_mesh_size = 0.5))
})
