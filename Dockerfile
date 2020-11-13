FROM rocker/geospatial:4.0.3@sha256:624acf6ad02b87166980e9aa61de61b9de9f51f09113a0a3943b88b532fc4499

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
  mkdir -p /home/rstudio/.local/share/renv/cache && \
  chown -R rstudio:rstudio /home/rstudio

RUN set -x && \
  install2.r --error --ncpus -1 --repos 'https://cran.microsoft.com/snapshot/2020-11-12/' \
    renv && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
