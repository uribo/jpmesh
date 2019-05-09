context("rmesh")

test_that(
  "Generate random meshcode", {
    
    set.seed(71)
    res <- rmesh(1, mesh_size = "1km")
    
    if (getRversion() >= "3.6.0")
      expect_equal(res, "64394175")
    else 
      expect_equal(res, "50304610")
})
