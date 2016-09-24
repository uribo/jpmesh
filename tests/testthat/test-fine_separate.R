context("separate more fine mesh order")

# Test 1 -----------------------------------------------------------------
test_that("Separate more fine mesh order", {
  
  res <- fine_separate(52350400, "harf")
  
  expect_true(is.character(res))
  expect_equal(4, length(res))
})
