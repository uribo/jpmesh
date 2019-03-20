context("rmesh")

test_that(
  "Generate random meshcode", {
    
    set.seed(71)
    res <- rmesh(1, mesh_size = "1km")
    
    skip_if(grepl("development", version$status))
    expect_equal(res, "50304610")
    
    skip_if(!grepl("development", version$status))
    expect_equal(res, "64394175")

})
