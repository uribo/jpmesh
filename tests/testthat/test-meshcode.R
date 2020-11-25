test_that("success", {
  expect_equal(
    meshcode_vector(x = "6441", size = 80),
    meshcode(6441)
  )
  expect_s3_class(
    meshcode(6442),
    "meshcode"
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
  expect_s3_class(
    meshcode(6441431552, .type = "subdivision"),
    "subdiv_meshcode"
  )
  expect_true(
    is_meshcode(
      meshcode_vector("6441535242", size = 0.1, .type = "subdivision")
    )
  )
})
