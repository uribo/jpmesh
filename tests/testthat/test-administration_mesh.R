context("administration_mesh")

test_that("multiplication works", {
  res <- administration_mesh(code = "35201", to_mesh_size = 1)
  vdiffr::expect_doppelganger(
    "administration-1kmmesh-city35201",
    plot(res, col = "white"))
  expect_equal(dim(res), c(805, 2))
  expect_named(res, c("meshcode", "geometry"))
  expect_s3_class(res, c("sf"))
  expect_s3_class(res, c("tbl_df"))
  res <- administration_mesh(code = "8", to_mesh_size = 80)
  vdiffr::expect_doppelganger(
    "administration-80kmmesh-pref08",
    plot(res, col = "white"))
  expect_equal(nrow(res), 5)
  expect_identical(
    administration_mesh(code = 8, to_mesh_size = 80),
    administration_mesh(code = "8", to_mesh_size = 80))
  expect_identical(
    administration_mesh(code = "08", to_mesh_size = 10),
    administration_mesh(code = "8", to_mesh_size = 10))
  res <- administration_mesh(code = "35", to_mesh_size = 10)
  vdiffr::expect_doppelganger(
    "administration-10kmmesh-pref35",
    plot(res, col = "white"))
  expect_equal(dim(res), c(108, 2))
  res <- administration_mesh(code = c("33", "34"), to_mesh_size = 10)
  vdiffr::expect_doppelganger(
    "administration-10kmmesh-pref33-34",
    plot(res, col = "white"))
  expect_equal(dim(res), c(204, 2))
  res <- administration_mesh(code = "08220", to_mesh_size = 1)
  vdiffr::expect_doppelganger(
    "administration-1kmmesh-city08220",
    plot(res, col = "white"))
  expect_equal(dim(res), c(331, 2))
  res <- administration_mesh(code = c("08220", "08221"), to_mesh_size = 1)
  vdiffr::expect_doppelganger(
    "administration-1kmmesh-city08220-08221",
    plot(res, col = "white"))
  expect_equal(dim(res), c(461, 2))
  expect_message(
    expect_equal(
      nrow(administration_mesh(code = c("35", "35201", "34202"),
                               to_mesh_size = 10)),
      120L),
    "The city and the prefecture including it was givend.\nWill return prefecture's meshes.")  # nolint
  expect_message(
    expect_equal(
      nrow(administration_mesh(code = c("34202", "34999"),
                               to_mesh_size = 10)),
      13L),
    "1 matching code were not found")
})

test_that("Failed patterns", {
  expect_error(administration_mesh(code = 123, to_mesh_size = 10))
})
