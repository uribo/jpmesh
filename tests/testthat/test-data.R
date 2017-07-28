context("data")

test_that("japan rectange sf", {
  expect_s3_class(jpnrect, c("sf", "tbl", "data.frame"))
  expect_equal(dim(jpnrect), c(47, 4))
  expect_named(jpnrect, c("jis_code", "abb_name", "mesh_code", "geometry"))
  expect_is(jpnrect$geometry, c("sfc_POLYGON", "sfc"))
})

test_that("japan prefecture mesh", {
  expect_s3_class(prefecture_mesh, c("tbl", "data.frame"))
  expect_equal(dim(prefecture_mesh), c(240, 2))
  expect_named(prefecture_mesh, c("pref", "mesh"))
  expect_is(prefecture_mesh$mesh, "character")
})
