context("find")

test_that("neighborhood meshes", {
  
  expect_error(
    neighbor_mesh("aaa"))

  set.seed(71)
  res <- neighbor_mesh(rmesh(1, mesh_size = "80km"))
  expect_is(
    res,
    "character"
  )
  
  expect_length(
    neighbor_mesh(56362655, contains = FALSE),
    8L)
  
  expect_identical(
    neighbor_mesh(533945011, contains = TRUE),
    find_neighbor_finemesh(533945011, contains = TRUE)
  )
    
  expect_warning(
    find_neighbor_mesh(6742),
    "Some neighborhood meshes are outside the area."
    )

  res <- suppressWarnings(find_neighbor_mesh(6742, contains = TRUE))
  expect_length(res, 7L)
  expect_equal(
    res, 
    c("6641", "6642", "6643", "6741", "6742", "6841", "6842"))
  
  res <- find_neighbor_mesh(674257)
  expect_length(
    res,
    6L
  )
  expect_equal(
    unique(substr(res, 1, 4)),
    "6742"
  )
  
  res <- find_neighbor_mesh(5337)
  expect_length(res, 9L)
  expect_equal(
    res, 
    c("5236", "5237", "5238", "5336", "5337", "5338", "5436", "5437", "5438"))
  
  res <- find_neighbor_mesh(533720)
  expect_equal(
    res, 
    c("533617", "533627", "533637", 
      "533710", "533711", "533720", 
      "533721", "533730", "533731"))
  
  res <- find_neighbor_mesh(53394501)
  expect_length(res, 9L)
  expect_is(res, "character")
  expect_equal(
    res, 
    c("53393590", "53393591", "53393592", "53394500", 
      "53394501", "53394502", "53394510", "53394511", "53394512"))
  
  res <- find_neighbor_finemesh(533945011, contains = FALSE)
  expect_length(res, 8L)
  res <- find_neighbor_finemesh(533945011, contains = TRUE)
  expect_length(res, 9L)

  # ref) #13
  res <- find_neighbor_mesh(37250395)
  expect_equal(
    res,
    c("37250384", "37250385", "37250386", 
      "37250394", "37250395", "37250396", 
      "37251304", "37251305", "37251306"))
  
  res <- suppressWarnings(find_neighbor_mesh(37250305, contains = FALSE))
  expect_equal(
    res,
    c("37250304", "37250306", "37250314",
      "37250315", "37250316"))
  
  res <- suppressWarnings(find_neighbor_mesh(37250300))
  expect_equal(
    res,
    c("37250209", "37250219", "37250300", 
      "37250301", "37250310", "37250311"))

  res <- find_neighbor_mesh("37250390")
  expect_equal(
    res,
    c("37250289", "37250299", "37250380", 
      "37250381", "37250390", "37250391",
      "37251209", "37251300", "37251301"))
  
})
