context("separate more fine mesh order")

# Test 1 -----------------------------------------------------------------
test_that("Separate more fine mesh order", {
  
  res <- fine_separate(52350400, "harf")
  
  expect_true(is.character(res))
  expect_length(res, 4)
  
  res <- fine_separate(52350400, "harf", collapse = ",")
  expect_length(res, 1)
})
