context("internal")

test_that("multiplication works", {
  res <- 
    eval_jp_boundary(135.50800000, 35.70902590)
  expect_true(res)
  res <- 
    eval_jp_boundary(101.712359, 22.544763)
  expect_false(res)
  res <- 
    eval_jp_boundary(153.429390000, -28.0070630000)
  expect_false(res)
  res <- 
    data.frame(
    longitude = c(139.73199250, 139.69170000, 135.78500278, 120),
    latitude = c(35.70902590, 35.68950000, 34.99483056, 19.3))
  res$out <- 
    purrr::map2_lgl(res$longitude,
                             res$latitude, eval_jp_boundary)
  expect_equal(res$out, c(TRUE, TRUE, TRUE, FALSE))
})

test_that("Generate mesh code set", {
  res <- 
    meshcode_set(mesh_size = 80, .raw = FALSE)
  expect_length(res, 176L)
  expect_equal(res[1],
               meshcode("3036"))
  res <- 
    meshcode_set(mesh_size = 10, .raw = TRUE)
  expect_length(res, 64 * 176)
  res <- 
    meshcode_set(mesh_size = 1, .raw = TRUE)
  expect_length(res, 100 * 64 * 176)
})

test_that(
  "validate", {
    target <- 
      fine_separate(4028)
    target2 <- 
      vctrs::field(target, 
                   "mesh_code")[target %>%
               vctrs::field("mesh_code") %>% 
                        purrr::map_lgl(
                          is_corner
                        ) != TRUE]
    df_check <- 
      target2 %>%
      purrr::map(validate_neighbor_mesh) %>%
      purrr::map(round, digits = 2) %>% 
      purrr::reduce(rbind) %>% 
      unique()
    expect_gte(
      nrow(df_check),
      1L
    )
    target3 <- 
      vctrs::field(target, 
                   "mesh_code")[target %>%
                                  vctrs::field("mesh_code") %>% 
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
