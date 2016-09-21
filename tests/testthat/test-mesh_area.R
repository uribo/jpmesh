context("Meshcode area")

# harf mesh ---------------------------------------------------------------
test_that("harf mesh", {
  
  res <- mesh_area(523504221, order = "harf")
  
  expect_true(is.data.frame(res))
  expect_equal(names(res), c("lng1", "lat1", "lng2", "lat2"))
  expect_true(is.numeric(res$lng1))
  
  expect_equal(res$lng1, 135.5312, tolerance = .002)
  expect_equal(res$lat1, 34.6875, tolerance = .002)
  expect_equal(res$lng2, 135.525, tolerance = .002)
  expect_equal(res$lat2, 34.68333, tolerance = .002)
})
# quarter mesh ---------------------------------------------------------------
test_that("quarter mesh", {
  
  res <- mesh_area(5235042214, order = "quarter")
  
  expect_true(is.data.frame(res))
  expect_equal(names(res), c("lng1", "lat1", "lng2", "lat2"))
  expect_true(is.numeric(res$lng1))
  
  expect_equal(res$lng1, 135.5312, tolerance = .002)
  expect_equal(res$lat1, 34.6875, tolerance = .002)
  expect_equal(res$lng2, 135.5281, tolerance = .002)
  expect_equal(res$lat2, 34.68542, tolerance = .002)
})
# eight mesh ---------------------------------------------------------------
test_that("eight mesh", {
  
  res <- mesh_area(52350422142, order = "eight")
  
  expect_true(is.data.frame(res))
  expect_equal(names(res), c("lng1", "lat1", "lng2", "lat2"))
  expect_true(is.numeric(res$lng1))
  
  expect_equal(res$lng1, 135.5312, tolerance = .002)
  expect_equal(res$lat1, 34.68646, tolerance = .002)
  expect_equal(res$lng2, 135.5297, tolerance = .002)
  expect_equal(res$lat2, 34.68542, tolerance = .002)
})


