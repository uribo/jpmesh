context("meshcode export as geojson")

test_that("typeof", {
  expect_is(export_mesh(53375084), "geo_json")
  expect_type(export_mesh(53375084), "character")
})

test_that("usage", {
  expect_message(export_mesh(533750841), label = "meshcode length")
})
