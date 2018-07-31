context("administration_mesh")

test_that("multiplication works", {
  res <- administration_mesh(code = c(35201), type = "city")
  expect_equal(dim(res), c(805, 2))
  expect_named(res, c("meshcode", "geometry"))
  expect_s3_class(res, c("sf"))
  expect_s3_class(res, c("tbl_df"))
  
  res <- administration_mesh(code = c(35), type = "prefecture")
  expect_equal(dim(res), c(108, 2))
  
  res <- administration_mesh(code = c(33, 34), type = "prefecture")
  expect_equal(dim(res), c(204, 2))
  
  res <- 
    administration_mesh(code = "08220", type = "city")
  expect_equal(dim(res), c(331, 2))
  
  res <- 
    administration_mesh(code = c("08220", "08221"), type = "city")
  expect_equal(dim(res), c(461, 2))
})
