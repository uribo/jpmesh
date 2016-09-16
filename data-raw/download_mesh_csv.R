library(rvest)
base.url <- "http://www.stat.go.jp/data/mesh/"
x <- read_html(paste0(base.url, "m_itiran.htm"))
links <- x %>% html_nodes(xpath = '//*[@id="contents"]/ul/li/a') %>%
  html_attr("href")

library(foreach)
foreach(i = 1:length(links)) %do% {
  download.file(paste0(base.url, links[i]),
                destfile = paste0("data-raw/city_mesh/", gsub(".+/", "",  links[i])))
}


