context("internal")

test_that("multiplication works", {
  res <- eval_jp_boundary(135.50800000, 35.70902590)
  expect_true(res)
  res <- eval_jp_boundary(101.712359, 22.544763)
  expect_false(res)
  res <- eval_jp_boundary(153.429390000, -28.0070630000)
  expect_false(res)
  
  res <- data.frame(
    longitude = c(139.73199250, 139.69170000, 135.78500278),
    latitude = c(35.70902590, 35.68950000, 34.99483056)
  ) %>% mutate(out = purrr::pmap_lgl(., eval_jp_boundary))
  expect_equal(res$out, c(TRUE, TRUE, TRUE))
})

test_that("Generate mesh code set", {
  res <- meshcode_set(mesh_size = "80km")
  expect_length(res, 176L)
  expect_equal(res[1], "3036")
  
  # Include outbound meshes...
  # [TODO] exclude outbound meshes
  res <- meshcode_set(mesh_size = "10km")
  expect_length(res, 11264L)
})
