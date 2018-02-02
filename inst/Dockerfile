FROM rocker/rstudio:latest
MAINTAINER "Shinya Uryu" <suika1127@gmail.com>

RUN apt-get update

RUN apt-get install -y \
  libudunits2-dev libssl-dev libxml2-dev libcurl4-openssl-dev

RUN apt-get install -y --no-install-recommends \
  libudunits2-dev \
  libgdal-dev

RUN install2.r --error \
  dplyr leaflet miniUI purrr sf tidyr
  
RUN install2.r --error \
  knitr covr testthat devtools roxygen2
