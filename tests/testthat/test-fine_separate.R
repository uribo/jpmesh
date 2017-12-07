context("separate more fine mesh order")

# Test 1 -----------------------------------------------------------------
test_that("Separate more fine mesh order", {
  
  res <- fine_separate(5235)
  expect_true(is.character(res))
  expect_length(res, 64)
  expect_equal(res[1], "523500")
  expect_equal(res[length(res)], "523577")
  
  res <- fine_separate(523504)
  expect_length(res, 100)
  expect_equal(res[1], "52350400")
  expect_equal(res[length(res)], "52350499")
  
  res <- fine_separate("36233799")
  expect_length(res, 4)
  expect_equal(res, paste0("36233799", 1:4))
})
