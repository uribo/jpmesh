FROM rocker/geospatial:4.0.3@sha256:bda9e2ecfeabd1c506fdb49842c5735f0fd77fa1b8c3530b8ddbbbc6b6106692

RUN set -x && \
  apt-get update && \
    : "options" && \
  apt-get install -y --no-install-recommends \
    libcairo2-dev && \
    : "For install magick" && \
  apt-get install -y --no-install-recommends \
    libmagick++-dev \
    qpdf && \
  apt-get install -y \
    r-cran-covr \
    r-cran-lwgeom \
    r-cran-roxygen2 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ARG GITHUB_PAT

RUN set -x && \
  echo "GITHUB_PAT=$GITHUB_PAT" >> /usr/local/lib/R/etc/Renviron

RUN set -x && \
  install2.r --error --ncpus -1 --repos 'https://cran.microsoft.com/snapshot/2020-11-11/' \
    leaflet \
    miniUI \
    knitr \
    jpmesh \
    mapview \
    usethis \
    shinyjs \
    reprex \
    lintr \
    magick \
    roxygen2 \
    vdiffr && \
  installGithub.r \
    r-lib/revdepcheck && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
