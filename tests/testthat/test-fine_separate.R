context("separate more fine mesh order")

# Test 1 -----------------------------------------------------------------
test_that("Separate more fine mesh order", {
  res <- 
    fine_separate(5235)
  expect_true(is_meshcode(res))
  expect_length(res, 64)
  expect_equal(res[1], 
               meshcode("523500"))
  expect_equal(res[length(res)],
               meshcode("523577"))
  expect_doppelganger(
    "fine-separate-80km",
    plot(sf::st_geometry(export_meshes(res)), col = "white"))
  res <- 
    fine_separate(523504)
  expect_length(res, 100)
  expect_equal(res[1], 
               meshcode("52350400"))
  expect_equal(res[length(res)], 
               meshcode("52350499"))
  expect_doppelganger(
    "fine-separate-10km",
    plot(sf::st_geometry(export_meshes(res)), col = "white"))
  res <- 
    fine_separate("36233799")
  expect_length(res, 4)
  expect_equal(res, 
               meshcode(paste0("36233799", seq_len(4))))
  expect_doppelganger(
    "fine-separate-1km",
    plot(sf::st_geometry(export_meshes(res)), col = "white"))
  res <- 
    fine_separate("64414315", .type = "subdivision")
  expect_length(
    res,
    100L
  )
  expect_s3_class(
    res,
    "subdiv_meshcode"
  )
  expect_equal(
    as.character(res),
    paste0(64414315,
           sprintf("%02d", seq.int(0, 99)))
  )
})

test_that("Coarse multiple meshes to large size", {
  m <- 
    c("493214294", "493214392", "493215203", "493215301")
  res <- 
    coarse_gather(m)
  expect_is(
    res,
    "meshcode")
  expect_length(
    res,
    4L)
  expect_equal(
    res,
    meshcode(c("49321429", "49321439", "49321520", "49321530")))
  expect_equal(
    coarse_gather(m, distinct = TRUE),
    res)
  expect_equal(
    coarse_gather(res, distinct = TRUE),
    meshcode(c("493214", "493215")))
  expect_equal(
    coarse_gather("5639331"),
    coarse_gather("56393322"))
  res <- 
    coarse_gather("664746")
  expect_equal(res, 
               meshcode("6647"))
})
