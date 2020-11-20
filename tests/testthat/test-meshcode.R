test_that("success", {
  expect_equal(
    meshcode_vector(x = "6441", size = 80),
    meshcode(6441)
  )
  expect_equal(
    meshcode(6441),
    as_meshcode("6441")
  )
})
