#################################################
# 
#################################################
# Load Employed Packages --------------------------------------------------
library(dplyr)
library(foreach)
library(jpmesh)

library(rvest)
base.url <- "http://www.stat.go.jp/data/mesh/"
x <- read_html(paste0(base.url, "m_itiran.htm"))
links <- x %>% html_nodes(xpath = '//*[@id="contents"]/ul/li/a') %>%
  html_attr("href")

foreach(i = 1:length(links)) %do% {
  download.file(paste0(base.url, links[i]),
                destfile = paste0("~/Dropbox/city_mesh/", gsub(".+/", "",  links[i])))
}

jpmesh.pref <- df.mesh.csv[1] %>% 
  group_by(file) %>% 
  do(res = jpmesh:::raw_pref_mesh(.$file)) %>% 
  tidyr::unnest() %>% 
  select(-piece, -hole) %>% 
  mutate(file = gsub(".+//city-mesh_", "", file) %>% 
           gsub(".csv", "", .) %>% 
           gsub("-.+", "", .)) %>% 
  rename(jiscode = file)

#都道府県ごとのrdsを作成
foreach(i = 1:length(unique(jpmesh.pref$jiscode))) %do% {
  jpmesh.pref %>% 
    filter(jiscode == sprintf("%02s", i)) %>%
    readr::write_rds(path = paste0("inst/extdata/pref_", sprintf("%02s", i), "_mesh.rds"), compress = "xz")
}


readr::read_rds(paste0("~/git/r_pkg/jpmesh/inst/extdata/pref_", sprintf("%02s", 2), "_mesh.rds")) %>% names()
# [1] "jiscode"   "long"      "lat"       "order"     "group"    
# [6] "id"        "city_code" "city_name"
