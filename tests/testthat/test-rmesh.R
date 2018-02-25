context("rmesh")

test_that(
  "Generate random meshcode", {
    
    set.seed(71)
    res <- rmesh(1, mesh_size = "1km")
    expect_equal(res, "50304610")

})
