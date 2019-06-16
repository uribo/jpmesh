context("meshcode export as geojson")

test_that("typeof", {
  expect_s3_class(export_mesh(53375084), c("sfc_POLYGON"))
  expect_type(export_mesh(53375084), "list")
  expect_equal(sf::st_crs(export_mesh(sample(meshcode_set(80), 1)))$epsg, 4326) # nolint
})

test_that("Convert include meshcode dataframe to sf", {
  d <- data.frame(id = seq.int(4),
              meshcode = rmesh(4),
              stringsAsFactors = FALSE)
  res <- meshcode_sf(d, meshcode)
  expect_s3_class(res, "sf")
  expect_named(res, c("id", "meshcode", "geometry"))
})
