FROM rocker/geospatial:4.0.0

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
  install2.r --error --ncpus -1 --repos 'http://mran.revolutionanalytics.com/snapshot/2020-05-30' \
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
    r-lib/revdepcheck \
    r-spatial/sf && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
