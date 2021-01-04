context("data")

test_that("japan rectangle sf", {
  expect_s3_class(jpnrect, "sf")
  expect_s3_class(jpnrect, "tbl_df")
  expect_equal(dim(jpnrect), c(47, 4))
  expect_named(jpnrect, c("jis_code", "abb_name", "meshcode", "geometry"))
  expect_is(jpnrect$geometry, c("sfc_POLYGON", "sfc"))
  expect_is(jpnrect$meshcode, c("meshcode"))
  expect_doppelganger(
    "japan-rectangle",
    plot(sf::st_geometry(jpnrect), col = "white"))
})

test_that("city meshcode", {
  expect_equal(dim(df_city_mesh), c(461373L, 3L))
  expect_s3_class(df_city_mesh, "tbl_df")
  expect_named(df_city_mesh, 
               c("city_code", "city_name", "meshcode"))
  expect_is(df_city_mesh$meshcode[1], "character")
})
