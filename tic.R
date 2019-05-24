do_package_checks(error_on = "error")

get_stage("install") %>%
  add_code_step(install.packages("lwgeom", configure.args = "--without-liblwgeom"))

if (Sys.getenv("id_rsa") != "") {
  
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())
  
  get_stage("deploy") %>%
    add_step(step_build_pkgdown(document = FALSE)) %>%
    add_step(step_push_deploy(path = "docs", branch = "gh-pages"))
}
