context("Style")

test_that("Package Style", {
  skip_if_not_installed("lintr")
  skip_on_travis()
  if (requireNamespace("lintr", quietly = TRUE)) {
    lintr::expect_lint_free()
  }
})
