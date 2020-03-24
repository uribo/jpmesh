FROM rocker/geospatial:3.6.2

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
  install2.r --error --skipinstalled --repos 'http://mran.revolutionanalytics.com/snapshot/2020-03-22' \
    leaflet \
    miniUI \
    knitr \
    covr \
    jpmesh \
    lwgeom \
    mapview \
    usethis \
    shinyjs \
    reprex \
    DT \
    lintr \
    vdiffr \
    caTools \
    magick && \
  installGithub.r \
    r-lib/revdepcheck \
    r-spatial/sf && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
