context("Utities function for packages")

test_that("is meshcode", {
  expect_true(
    is_meshcode(mesh = 5440))
  expect_true(
    is_meshcode(54401026))
  expect_true(
    is_meshcode(5440102612))
  expect_false(
    is_meshcode(45678))
  expect_true(
    is_meshcode(54401026))
  expect_message(
    is_meshcode(45678),
    "meshcode must be follow digits: 4, 6, 7, 8, 9, 10 and 11")
  expect_false(
    is_meshcode(456789123450))
  expect_false(
    is_meshcode("a123"))
  expect_message(
    is_meshcode("a123"),
    "meshcode must be numeric ranges 4 to 11 digits")
})

test_that("mesh size", {
  expect_equal(
    dim(df_mesh_size_unit),
    c(7, 2))
  expect_named(
    df_mesh_size_unit,
    c("mesh_length", "mesh_size"))
  expect_s3_class(
    mesh_units[1], "units")
  expect_equal(
    mesh_size(mesh = 5440),
    units::as_units(80, "km"))
  expect_equal(
    mesh_size(mesh = 544010),
    units::as_units(10, "km"))
  expect_equal(
    mesh_size(mesh = 11111),
    units::as_units(NA_integer_, "km"))
})
