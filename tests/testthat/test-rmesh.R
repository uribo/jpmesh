context("rmesh")

test_that(
  "Generate random meshcode", {
    res <- 
      rmesh(1, mesh_size = 1.000)
    expect_is(res, "meshcode")
    expect_equal(mesh_size(res),
                 units::set_units(1, "km"))
    expect_error(rmesh(1, mesh_size = 0.5))
})
