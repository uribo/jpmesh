context("test-neighborhood.R")

test_that("return value", {
  res <-
    neighbor_mesh(53394501)
  expect_is(res, "character")
  
  expect_length(
    res,
    9L
  )
  res <-
    neighbor_mesh(53394501, contains = FALSE)
  expect_equal(
    res,
    c("53393590", "53393591", "53393592", 
      "53394500", "53394502", "53394510", 
      "53394511", "53394512")
  )
  expect_length(
    res,
    8L
  )
  
  expect_equal(
    neighbor_mesh(533945011),
    neighbor_mesh("533945011")  
  )
  
})

test_that("success", {
  
  expect_equal(
    neighbor_mesh(533945011, contains = FALSE),
    c("533935904", "533935913", "533935914",
      "533945002", "533945004", "533945012", 
      "533945013", "533945014"))
  
  expect_length(
    neighbor_mesh(654175821, contains = TRUE),
    9L
  )
  expect_length(
    neighbor_mesh(654175922, contains = TRUE),
    9L
  )
  expect_length(
    neighbor_mesh(654175922, contains = FALSE),
    8L
  )

})

test_that("failed", {
  
  expect_null(suppressMessages(neighbor_mesh(3725124021)))
  expect_message(
    neighbor_mesh(3725124021),
    "Too small meshsize. Enable 80km to 500m size."
  )
  
