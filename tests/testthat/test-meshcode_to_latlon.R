context("Correct boundary")

# 80km mesh ----------------------------------------------------------------
test_that("Calculate correct value for mesh_code (80km)", {
  
  res <- meshcode_to_latlon(5133)
  
  expect_true(is.data.frame(res))
  expect_equal(names(res), c("lat_center", "long_center", "lat_error", "long_error"))
  
  expect_equal(res$lat_center - res$lat_error, 34)
  expect_equal(res$long_center - res$long_error, 133)
})

# 10km mesh ----------------------------------------------------------------
test_that("Calculate correct value for mesh_code (10km)", {
  
  res <- meshcode_to_latlon(513377)
  
  expect_that(res, is_a("data.frame"))
  expect_equal(names(res), c("lat_center", "long_center", "lat_error", "long_error"))
  
  expect_equal(res$lat_center - res$lat_error, 34.583333)
  expect_equal(res$long_center - res$long_error, 133.875)
})

# 1km mesh ----------------------------------------------------------------
test_that("Calculate correct value for mesh_code (1km)", {
  
  res <- meshcode_to_latlon(51337783)
  
  expect_that(res, is_a("data.frame"))
  expect_equal(names(res), c("lat_center", "long_center", "lat_error", "long_error"))
  
  expect_equal(res$lat_center - res$lat_error, 34.65)
  expect_equal(res$long_center - res$long_error, 133.9125)
})

# Misc. --------------------------------------------------
test_that("Combine other function", {
  res <- latlong_to_meshcode(34.688732, 135.527193) %>% 
    meshcode_to_latlon()
  
  expect_that(res, is_a("data.frame"))
  expect_equal(names(res), c("lat_center", "long_center", "lat_error", "long_error"))
  
  expect_equal(res$lat_center - res$lat_error, 34.68333, tolerance = .002)
  expect_equal(res$long_center - res$long_error, 135.525)

})
