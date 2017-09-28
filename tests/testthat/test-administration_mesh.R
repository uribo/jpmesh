context("administration_mesh")

test_that("multiplication works", {
  res <- administration_mesh(code = c(35201))
  expect_equal(dim(res), c(1608, 4))
  expect_s3_class(res, c("sf"))
  
  res <- administration_mesh(code = c(35), type = "prefecture")
  expect_equal(dim(res), c(14657, 4))
  expect_length(unique(res$city_code), 19)
  
  res <- administration_mesh(code = c(33, 34), type = "prefecture")
  expect_equal(dim(res), c(36862, 4))
  expect_length(unique(substr(unique(res$city_code), 1, 2)), 2)
  
})
