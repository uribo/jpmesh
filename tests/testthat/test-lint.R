context("Style")

test_that("Package Style", {
  skip_if_not_installed("lintr")
  skip_on_travis()
  skip_on_os("mac")
  if (requireNamespace("lintr", quietly = TRUE)) {
    lintr::expect_lint_free()
  }
})
