context("data")

test_that("japan prefecture mesh", {
  expect_s3_class(prefecture_mesh, c("tbl", "data.frame"))
  expect_equal(dim(prefecture_mesh), c(240, 2))
  expect_named(prefecture_mesh, c("pref", "mesh"))
  expect_is(prefecture_mesh$mesh, "character")
})
