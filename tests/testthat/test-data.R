context("data")

test_that("japan rectange sf", {
  expect_s3_class(jpnrect, c("sf", "tbl", "data.frame"))
  expect_equal(dim(jpnrect), c(47, 4))
  expect_named(jpnrect, c("jis_code", "abb_name", "mesh_code", "geometry"))
  expect_is(jpnrect$geometry, c("sfc_POLYGON", "sfc"))
})

# test_that("japan prefecture mesh", {
#   expect_s3_class(prefecture_mesh, c("tbl", "data.frame"))
#   expect_equal(dim(prefecture_mesh), c(316, 3))
#   expect_named(prefecture_mesh, c("pref", "mesh", "name"))
#   expect_is(prefecture_mesh$mesh, "character")
# })

test_that("", {
  expect_equal(dim(df_city_mesh), c(899507, 3))
  expect_named(df_city_mesh, c("city_code", "city_name", "meshcode"))
})
