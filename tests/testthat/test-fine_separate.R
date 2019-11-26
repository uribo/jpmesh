context("separate more fine mesh order")

# Test 1 -----------------------------------------------------------------
test_that("Separate more fine mesh order", {
  res <- fine_separate(5235)
  expect_true(is.character(res))
  expect_length(res, 64)
  expect_equal(res[1], "523500")
  expect_equal(res[length(res)], "523577")
  vdiffr::expect_doppelganger(
    "fine-separate-80km",
    plot(export_meshes(res), col = "white"))
  res <- fine_separate(523504)
  expect_length(res, 100)
  expect_equal(res[1], "52350400")
  expect_equal(res[length(res)], "52350499")
  vdiffr::expect_doppelganger(
    "fine-separate-10km",
    plot(export_meshes(res), col = "white"))
  res <- fine_separate("36233799")
  expect_length(res, 4)
  expect_equal(res, paste0("36233799", seq_len(4)))
  vdiffr::expect_doppelganger(
    "fine-separate-1km",
    plot(export_meshes(res), col = "white"))
  expect_message(
    fine_separate("36233799123"),
    "A value greater than the supported mesh size was inputed."
  )
  expect_equal(
    suppressMessages(fine_separate("36233799123")),
    NA_character_
  )
})

test_that("Coarse multiple meshes to large size", {
  m <- c("493214294", "493214392", "493215203", "493215301")
  res <- coarse_gather(m)
  expect_is(
    res,
    "character")
  expect_length(
    res,
    4L)
  expect_equal(
    res,
    c("49321429", "49321439", "49321520", "49321530"))
  expect_equal(
    coarse_gather(m, distinct = TRUE),
    res)
  expect_equal(
    coarse_gather(res, distinct = TRUE),
    c("493214", "493215"))
  expect_equal(
    coarse_gather("5639331"),
    coarse_gather("56393322"))
  set.seed(123)
  res <- coarse_gather(rmesh(1, 10))
  if (getRversion() >= "3.6.0")
    expect_equal(res, "4728")
  else
    expect_equal(res, "4929")
})
