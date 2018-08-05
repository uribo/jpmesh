context("administration_mesh")

test_that("multiplication works", {
  res <- 
    administration_mesh(code = c(35201), type = "city")
  expect_equal(dim(res), c(805, 2))
  expect_named(res, c("meshcode", "geometry"))
  expect_s3_class(res, c("sf"))
  expect_s3_class(res, c("tbl_df"))

  res <- 
    administration_mesh(code = 8, type = "prefecture")
  expect_gt(nrow(res), 0)
  
  expect_identical(
    administration_mesh(code = 8, type = "prefecture"),
    administration_mesh(code = "8", type = "prefecture")
  )
  expect_identical(
    administration_mesh(code = "08", type = "prefecture"),
    administration_mesh(code = "8", type = "prefecture")
  )
    
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
  
  expect_message(
    expect_equal(
      nrow(administration_mesh(code = c("35", "35201", "34202"), type = "prefecture")),
      120L
    ),
    "The city and the prefecture including it was givend.\nWill return prefecture meshes."
  )
  expect_message(
    expect_equal(
      nrow(administration_mesh(code = c("34202", "34999"), type = "prefecture")),
      13
    ),
    "1 matching code were not found"
  )
})

test_that("Failed patterns", {
  
  expect_error(
    administration_mesh(code = 123)
  )
  expect_error(
    administration_mesh(code = c("08220", "08221"), type = "cities")
  )
  
})
