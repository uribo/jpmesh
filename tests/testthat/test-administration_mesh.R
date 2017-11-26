context("administration_mesh")

test_that("multiplication works", {
  res <- administration_mesh(code = c(35201))
  expect_equal(dim(res), c(19, 6))
  expect_s3_class(res, c("sf"))
  
  res <- administration_mesh(code = c(35), type = "prefecture")
  expect_equal(dim(res), c(108, 6))
  
  res <- administration_mesh(code = c(33, 34), type = "prefecture")
  expect_equal(dim(res), c(204, 6))
  
})
