FROM rocker/rstudio:latest
MAINTAINER "Shinya Uryu" <suika1127@gmail.com>

RUN apt-get update

RUN apt-get install -y \
  libudunits2-dev libssl-dev libxml2-dev libcurl4-openssl-dev

RUN apt-get install -y --no-install-recommends \
  libudunits2-dev \
  libgdal-dev \
  libcairo2-dev \
  qpdf

RUN install2.r --error \
  dplyr leaflet miniUI purrr sf tidyr

RUN install2.r --error \
  knitr covr roxygen2 \
  remotes \
  usethis shinyjs reprex DT 

RUN installGithub.r \
  "r-lib/roxygen2md" \
  "r-lib/testthat" \
  "r-lib/revdepcheck" \
  "r-lib/pkgdown" \
  "tidyverse/ggplot2" \
  "hadley/devtools"
