context("meshcode export as geojson")

test_that("typeof", {
  expect_s3_class(export_mesh(53375084), c("sfc_POLYGON"))
  expect_type(export_mesh(53375084), "list")
  
  expect_equal(
    sf::st_crs(export_mesh(sample(meshcode_set("80km"), 1)))$epsg,
    4326
  )
})
