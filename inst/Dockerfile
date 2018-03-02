FROM rocker/rstudio:3.4.3
MAINTAINER "Shinya Uryu" <suika1127@gmail.com>

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libudunits2-dev libssl-dev libxml2-dev libcurl4-openssl-dev \
  ### options
  libudunits2-dev \
  libgdal-dev \
  libcairo2-dev \
  # For install magick
  libmagick++-dev \
  qpdf \
  && rm -rf /var/lib/apt/lists/*

RUN install2.r --error \
  leaflet miniUI purrr sf tidyr dplyr

##### For develop and infrastructure ######
RUN install2.r --error \
  knitr covr roxygen2 \
  remotes \
  usethis shinyjs \
  reprex DT \
  lintr \
  # to knitr R Markdown documents
  caTools \
  # create favivon.ico by pkgdown::build_site()
  magick

RUN installGithub.r \
  "r-lib/roxygen2md" \
  "r-lib/testthat" \
  "r-lib/revdepcheck" \
  "r-lib/pkgdown" \
  "tidyverse/ggplot2" \
  "hadley/devtools"
