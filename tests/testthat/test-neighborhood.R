context("test-neighborhood.R")

test_that("return value", {
  res <-
    neighbor_mesh(53394501)
  expect_is(res, "character")
  expect_length(
    res,
    9L
  )
  res <-
    neighbor_mesh(53394501, contains = FALSE)
  expect_equal(
    res,
    c("53393590", "53393591", "53393592",
      "53394500", "53394502", "53394510",
      "53394511", "53394512")
  )
  expect_length(
    res,
    8L
  )
  expect_equal(
    neighbor_mesh(533945011),
    neighbor_mesh("533945011")
  )
  res <-
    neighbor_mesh(513474923, contains = TRUE)
  expect_equal(
    res,
    c("513474912", "513474914", "513474921",
      "513474922", "513474923", "513474924", 
      "523404012", "523404021", "523404022"))
})

test_that("success", {
  expect_equal(
    neighbor_mesh(533945011, contains = FALSE),
    c("533935904", "533935913", "533935914",
      "533945002", "533945004", "533945012",
      "533945013", "533945014"))
  expect_length(
    neighbor_mesh(654175821, contains = TRUE),
    9L
  )
  expect_length(
    neighbor_mesh(654175922, contains = TRUE),
    9L
  )
  expect_length(
    neighbor_mesh(654175922, contains = FALSE),
    8L
  )
  expect_equal(
    neighbor_mesh(362450794),
    c("362450791", "362450792", "362450793",
      "362450794", "362450891", "362450892",
      "362451701", "362451703", "362451801")
  )
})

test_that("failed", {
  expect_null(suppressMessages(neighbor_mesh(3725124021)))
  expect_message(
    neighbor_mesh(3725124021),
    "Too small meshsize. Enable 80km to 500m size."
  )
})

test_that("corners", {
  expect_is(
    neighbor_mesh(53390000),
    "character")
  expect_length(
    neighbor_mesh(53390100),
    9L)
  expect_equal(
    neighbor_mesh(53391000, contains = FALSE),
    c("53380799", "53381709", "53381719",
      "53390090", "53390091", "53391001",
      "53391010", "53391011"))
  res <-
    neighbor_mesh(53390109) %>%
    export_meshes()
  res$relate <-
    c(sf::st_relate(res$geometry, res$geometry[5], sparse = FALSE))
  expect_equal(
    res$relate,
    c("FF2F01212", "FF2F11212", "FF2F01212",
      "FF2F11212", "2FFF1FFF2", "FF2F01212",
      "FF2F11212", "FF2F11212", "FF2F01212"))
  skip_if_not_installed("lwgeom")
  expect_equivalent(
    neighbor_mesh(53390009) %>%
      export_meshes() %>%
      sf::st_union() %>%
      sf::st_area(),
    9455968,
    tolerance = 0.002
  )
  expect_length(
    neighbor_mesh(53391100),
    9L
  )
})
