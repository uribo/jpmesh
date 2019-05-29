context("internal")

test_that("Internal data", {
  expect_s3_class(df_city_mesh, "tbl")
  expect_equal(dim(df_city_mesh), c(899507, 3))
  expect_named(df_city_mesh, c("city_code", "city_name", "meshcode"))
  expect_is(df_city_mesh$meshcode[1], "character")
})

test_that("multiplication works", {
  res <- eval_jp_boundary(135.50800000, 35.70902590)
  expect_true(res)
  res <- eval_jp_boundary(101.712359, 22.544763)
  expect_false(res)
  res <- eval_jp_boundary(153.429390000, -28.0070630000)
  expect_false(res)
  res <- data.frame(
    longitude = c(139.73199250, 139.69170000, 135.78500278, 120),
    latitude = c(35.70902590, 35.68950000, 34.99483056, 19.3))
  res$out <- purrr::map2_lgl(res$longitude,
                             res$latitude, eval_jp_boundary)
  expect_equal(res$out, c(TRUE, TRUE, TRUE, FALSE))
})

test_that("Generate mesh code set", {
  res <- meshcode_set(mesh_size = 80)
  expect_length(res, 176L)
  expect_equal(res[1], "3036")
  # Include outbound meshes...
  # [TODO] exclude outbound meshes
  res <- meshcode_set(mesh_size = 10)
  expect_length(res, 11264L)
  res <- meshcode_set(mesh_size = 1)
  expect_length(res, 1126400L)
})

test_that(
  "validate", {
    target <- 4028 %>%
      fine_separate()
    target2 <- target[target %>%
                        purrr::map_lgl(
                          is_corner
                        ) != TRUE]
    df_check <- target2 %>%
      purrr::map(validate_neighbor_mesh) %>%
      purrr::reduce(rbind) %>%
      unique()
    expect_equal(
      nrow(df_check),
      1L
    )
    target3 <- target[target %>%
                        purrr::map_lgl(
                          is_corner
                        ) == TRUE]
    expect_length(
      target3,
      4 * 7)
  })

test_that(
  "corner", {
    expect_true(
      is_corner(36247799)
    )
    expect_false(
      is_corner(36247788)
    )
    expect_error(
      is_corner(3624),
      "enable 10km or 1km mesh"
    )
})
