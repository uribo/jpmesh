context("find")

test_that("neighborhood meshes", {
  
  res <- find_neighbor_mesh(5337)
  expect_length(res, 9L)
  expect_equal(res, 
               c(5236, 5237, 5238, 5336, 5337, 5338, 5436, 5437, 5438))
  
  res <- find_neighbor_mesh(533720)
  expect_equal(res, 
               c(533617, 533627, 533637, 533710, 533711, 533720, 533721, 533730, 533731))
  
  res <- find_neighbor_mesh(533945011)
  expect_length(res, 9L)
  expect_is(res, "numeric")
  expect_equal(res, 
              c(533944904, 533944913, 533944914, 533945002, 533945004, 533945011, 533945012, 533945013, 533945014))
  
  res <- find_neighbor_mesh(533945011, contains = FALSE)
  expect_length(res, 8L)
})
