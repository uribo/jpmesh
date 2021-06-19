FROM rocker/geospatial:4.1.0@sha256:2d66c3ee0decea0d3c191ee3962deacabc7889118447c9e03f5a828b93dc8a0f

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
  install2.r --error --ncpus -1 --repos 'https://cran.microsoft.com/snapshot/2021-06-18/' \
    renv && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
