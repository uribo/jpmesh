do_package_checks(error_on = "error")

get_stage("install") %>%
  add_code_step(install.packages("lwgeom", configure.args = "--without-liblwgeom"))

if (ci_on_travis()) {
  do_pkgdown()
}

