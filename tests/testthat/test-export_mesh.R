context("meshcode export as geojson")

test_that("typeof", {
  expect_s3_class(export_mesh(53375084), c("sfc_POLYGON"))
  expect_type(export_mesh(53375084), "list")
})
