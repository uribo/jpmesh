test_that("success", {
  expect_equal(
    meshcode_vector(x = "6441", size = 80),
    meshcode(6441)
  )
  expect_equal(
    meshcode(6441),
    as_meshcode("6441")
  )
  res <-
    meshcode(c("5133", "513377"))
  expect_equal(
    mesh_size(res),
    units::set_units(c(80, 10), "km")
  )
})
