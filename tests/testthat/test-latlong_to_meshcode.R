context("convert to mesh code")

# Order 1 -----------------------------------------------------------------
test_that("from latitude and longitude to mesh 1", {
  
  res <- latlong_to_meshcode(34, 133, order = 1)
  
  expect_true(is.numeric(res))
  expect_equal(4, nchar(res))
  expect_equal(res, 5133)
})

# Order 2 -----------------------------------------------------------------
test_that("from latitude and longitude to mesh 2", {
  
  res <- latlong_to_meshcode(34.583333, 133.875, order = 2)
  
  expect_true(is.numeric(res))
  expect_equal(6, nchar(res))
  expect_equal(res, 513367)
})

# Order 3 -----------------------------------------------------------------
test_that("from latitude and longitude to mesh 2", {
  
  res <- latlong_to_meshcode(34.65, 133.9125, order = 3)
  
  expect_true(is.numeric(res))
  expect_equal(8, nchar(res))
  expect_equal(res, 51337782)
})

# Separete Mesh: harf -----------------------------------------------------------------
test_that("Separete to harf mesh", {
  
  res <- latlong_to_sepate_mesh(35.442788, 139.301255, order = "harf")
  
  expect_true(is.numeric(res))
  expect_equal(9, nchar(res))
  expect_equal(res, 533912341)
})

# Separete Mesh: quarter -----------------------------------------------------------------
test_that("Separete to quarter mesh", {
  
  res <- latlong_to_sepate_mesh(35.442788, 139.301255, order = "quarter")
  
  expect_true(is.numeric(res))
  expect_equal(10, nchar(res))
  expect_equal(res, 5339123411)
  
  res <- latlong_to_sepate_mesh(35.442893, 139.310654, order = "quarter")
  expect_equal(res, 5339123422)
  
  res <- latlong_to_sepate_mesh(35.448767, 139.301706, order = "quarter")
  expect_equal(res, 5339123433)
  
  res <- latlong_to_sepate_mesh(35.449011, 139.311340, order = "quarter")
  expect_equal(res, 5339123444)
})
