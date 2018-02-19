context("Utities function for packages")

test_that("mesh size", {
  
  expect_equal(
    dim(df_mesh_size_unit),
    c(6, 2)
  )
  expect_named(
    df_mesh_size_unit,
    c("mesh_length", "mesh_size")
  )
  
  expect_s3_class(
    df_mesh_size_unit$mesh_size[1], 
    "units")
  
  expect_equal(
    mesh_size(mesh = 4567),
    units::set_units(80, "km")
  )
  
  expect_equal(
    mesh_size(mesh = 456781),
    units::set_units(10, "km")
  )
  
  
})
