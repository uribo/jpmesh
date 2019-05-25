context("Style")

test_that("Package Style", {
  skip_if_not_installed("lintr")
  if (requireNamespace("lintr", quietly = TRUE)) {
    lintr::expect_lint_free()
  }
})
