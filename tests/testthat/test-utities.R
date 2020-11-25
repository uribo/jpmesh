context("Utities function for packages")

test_that("meshcode sets", {
  expect_length(meshcode_set_80km, 176L)
  expect_s3_class(meshcode_set_80km, "meshcode")
})

test_that("is meshcode", {
  expect_true(
    is_meshcode(mesh = meshcode(5440)))
  expect_true(
    is_meshcode(meshcode(54401026)))
  expect_true(
    is_meshcode(meshcode(5440102612)))
  # expect_false(
  #   is_meshcode(meshcode(45678)))
  expect_true(
    is_meshcode(meshcode(54401026)))
  # expect_false(
  #   is_meshcode(meshcode(456789123450)))
  # expect_false(
  #   is_meshcode("a123"))
  # expect_message(
  #   is_meshcode("a123"),
  #   "meshcode must be numeric ranges 4 to 11 digits")
})

test_that("mesh size", {
  expect_equal(
    dim(df_mesh_size_unit),
    c(8, 2))
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
  # expect_equal(
  #   mesh_size(mesh = 11111),
  #   units::as_units(NA_integer_, "km"))
})
