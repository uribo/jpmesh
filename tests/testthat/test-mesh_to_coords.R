context("Correct boundary")

test_that(
  "error case", {
    expect_error(
      suppressMessages(mesh_to_coords("aa")))
  }
)

# 80km mesh ----------------------------------------------------------------
test_that("Calculate correct value for mesh_code (80km)", {
  res <- 
    mesh_to_coords(5133)
  expect_true(is.data.frame(res))
  expect_equal(
    names(res),
    c("meshcode", "lng_center", "lat_center", "lng_error", "lat_error"))
  expect_equal(res$lat_center - res$lat_error, 34)
  expect_equal(res$lng_center - res$lng_error, 133)
})

# 10km mesh ----------------------------------------------------------------
test_that("Calculate correct value for mesh_code (10km)", {
  res <- 
    mesh_to_coords(513377)
  expect_that(res, is_a("data.frame"))
  expect_equal(
    names(res),
    c("meshcode", "lng_center", "lat_center", "lng_error", "lat_error"))
  expect_equal(res$lat_center - res$lat_error, 34.583333)
  expect_equal(res$lng_center - res$lng_error, 133.875)
  res_5km <- 
    mesh_to_coords(5133773)
  expect_equal(res_5km$lat_center - res_5km$lat_error, 34.625)
  expect_equal(res_5km$lng_center - res_5km$lng_error, 133.875)
  expect_equal(res_5km$lng_error,
               res$lng_error / 2,
               tolerance = 0.002)
})

# 1km mesh ----------------------------------------------------------------
test_that("Calculate correct value for mesh_code (1km)", {
  res <- 
    mesh_to_coords(51337783)
  expect_that(res, is_a("data.frame"))
  expect_equal(
    names(res),
    c("meshcode", "lng_center", "lat_center", "lng_error", "lat_error"))
  expect_equal(res$lat_center - res$lat_error, 34.65)
  expect_equal(res$lng_center - res$lng_error, 133.9125)
})

test_that("fine mesh", {
    res <- 
      mesh_to_coords(513377831)
    expect_s3_class(res, "tbl_df")
    expect_equal(res$lng_error, 0.00312, tolerance = 0.02)
    expect_lte(res$lng_error, 0.5)
    expect_equal(res$lat_error, 0.002083333, tolerance = 0.02)
    expect_lte(res$lat_error, 0.3333)
    res <- 
      mesh_to_coords(5133778312)
    expect_is(res$lat_error, "numeric")
    expect_equal(res$lng_error, 0.00312 / 2, tolerance = 0.02)
    expect_equal(res$lat_error, 0.002083333 / 2, tolerance = 0.02)
    res <- 
      mesh_to_coords(51337783123)
    expect_is(res$lng_error, "numeric")
    expect_equal(res$lng_error, 0.00312 / 4, tolerance = 0.02)
    expect_equal(res$lat_error, 0.002083333 / 4, tolerance = 0.02)
  }
)

# Misc. --------------------------------------------------
test_that("Combine other function", {
  res <- 
    coords_to_mesh(135.527193, 34.688732) %>%
    mesh_to_coords()
  expect_that(res, is_a("data.frame"))
  expect_equal(names(res),
               c("meshcode", "lng_center", "lat_center", "lng_error", "lat_error"))
  expect_equal(res$lat_center - res$lat_error, 34.68333, tolerance = .002)
  expect_equal(res$lng_center - res$lng_error, 135.525)
  expect_error(coords_to_mesh(135.527193, 34.688732, to_mesh_size = 123))
})

test_that("fine mesh", {
  res <-
    fine_separate("36233799") %>%
    tibble::enframe(name = NULL) %>%
    purrr::set_names(c("meshcode"))
  res <-
    mesh_to_coords(res$meshcode)
  expect_equal(
    res$meshcode,
    meshcode(c("362337991", "362337992", "362337993", "362337994")))
  expect_equal(
    res$lng_center,
    c(123.990625, 123.996875, 123.990625, 123.996875),
    tolerance = 0.002)
  expect_equal(
    res$lat_center,
    c(24.32708, 24.32708, 24.33125, 24.33125),
    tolerance = 0.002)
  expect_equivalent(
    res$lng_error[1], 0.003125)
})
