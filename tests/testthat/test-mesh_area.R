context("Meshcode area")


test_that("behavior test", {
  expect_error(mesh_area(523504))
})

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

# Misc --------------------------------------------------------------------
test_that("eight mesh", {
  
  res <- c(5135749624, 5135749642, 5135749644) %>%
    purrr::map(mesh_area, order = "quarter") %>%
    purrr::map_df(~ .[c("lng1", "lat1", "lng2", "lat2")])
  res$mesh <- c(5135749624, 5135749642, 5135749644)
  
  expect_true(is.data.frame(res))
  expect_equal(names(res), c("lng1", "lat1", "lng2", "lat2", "mesh"))
  
  expect_equal(res$lng1[1], res$lng1[2], tolerance = .002)
  expect_equal(res$lng2[1], res$lng2[2], tolerance = .002)
  expect_equal(res$lat1[2], res$lat2[3], tolerance = .002)
  
})

test_that("mesh rectange", {
  # mesh_rectangle.R
  d <- mesh_rectangle(data.frame(mesh_code = 6041,
  lat_center = 40.3333333333,
  long_center = 141.5,
  lat_error =  0.33,
  long_error = 0.5), "mesh_code", view = FALSE)
  
  expect_equal(dim(d), c(1, 10))
  expect_named(d, c("rowname", "mesh_code", "lat_center", "long_center", "lat_error", "long_error", "lng1", "lat1", "lng2", "lat2"))
  expect_equal(d$lat_error[1], 0.333333333, torelance = 0.002)
  expect_equal(d$long_error[1], 0.5)
  
})
