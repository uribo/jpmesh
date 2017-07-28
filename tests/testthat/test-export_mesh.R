context("meshcode export as geojson")

test_that("typeof", {
  expect_s3_class(export_mesh(53375084), c("sf", "tbl", "data.frame"))
  expect_type(export_mesh(53375084), "list")
})

test_that("usage", {
  expect_message(export_mesh(533750841), label = "meshcode length")
})
