FROM rocker/geospatial:3.6.0

RUN set -x && \
  apt-get update && \
    : "options" && \
  apt-get install -y --no-install-recommends \
    libcairo2-dev && \
    : "For install magick" && \
  apt-get install -y --no-install-recommends \
    libmagick++-dev \
    qpdf && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ARG GITHUB_PAT

RUN set -x && \
  echo "GITHUB_PAT=$GITHUB_PAT" >> /usr/local/lib/R/etc/Renviron

RUN set -x && \
  install2.r --error \
    leaflet \
    miniUI && \
  : "For develop and infrastructure" && \
  install2.r --error \
    knitr \
    covr \
    devtools \
    jpmesh \
    mapview \
    roxygen2 \
    usethis \
    shinyjs \
    reprex \
    DT \
    lintr && \
  : "to knitr R Markdown documents" && \
  install2.r --error \
    caTools && \
  : "create favivon.ico by pkgdown::build_site()" && \
  install2.r --error \
    magick && \
  installGithub.r \
    "r-lib/devtools" \
    "r-lib/roxygen2md" \
    "r-lib/testthat" \
    "r-lib/revdepcheck" \
    "r-lib/pkgdown" \
    "r-lib/pkgload" \ 
    "r-spatial/lwgeom" \
    "klutometis/roxygen" && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
