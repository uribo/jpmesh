context("Detect file scale mesh code")

# 500m --------------------------------------------------------------------
test_that("Scale down 1km to 500m mesh", {
  
  res <- detect_mesh(52350422, lat = 34.684176, long = 135.526130)
  expect_equal(res, 523504221)
  
  res <- detect_mesh(52350422, lat = 34.683724, long = 135.534380)
  expect_equal(res, 523504222)
  
  res <- detect_mesh(52350422, lat = 34.688391, long = 135.532413)
  expect_equal(res, 523504223)
  
  res <- detect_mesh(52350422, lat = 34.689465, long = 135.526214)
  expect_equal(res, 523504224)
})

# 250m --------------------------------------------------------------------
test_that("Scale down 500m to 250m mesh", {
  
  res <- detect_mesh(523504221, lat = 34.683608, long = 135.525591)
  expect_equal(res, 5235042211)
  
  res <- detect_mesh(523504221, lat = 34.684028, long = 135.529506)
  expect_equal(res, 5235042212)
  
  res <- detect_mesh(523504221, lat = 34.686828, long = 135.529629)
  expect_equal(res, 5235042213)
  
  res <- detect_mesh(523504221, lat = 34.686779, long = 135.526285)
  expect_equal(res, 5235042214)
})
