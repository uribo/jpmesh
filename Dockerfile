FROM rocker/geospatial:4.1.2@sha256:c7a7522e90a743b6efc38239fa52492c6aa9f868b14a82de22bb7f6ae10f8a58

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
  install2.r --error --ncpus -1 --repos 'https://cran.microsoft.com/snapshot/2022-01-06/' \
    renv && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
