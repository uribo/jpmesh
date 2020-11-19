####################################
# 総務省 統計局
# 市区町村別メッシュ・コード一覧
# 平成27年10月1日現在の各市区町村の区域に該当する基準地域メッシュ・コードの一覧
# Last modified: 2020-11-19
####################################
# File Download -----------------------------------------------------------
# https://github.com/uribo/jpmesh/blob/c91d9325319de6d48e959315581384293606ff62/data-raw/download_mesh_csv.R
pkgload::load_all()
library(purrr)
library(readr)

if (dir.exists("data-raw/city_mesh/") == FALSE) {
  dir.create("data-raw/city_mesh")
  library(rvest)
  base_url <- 
    "http://www.stat.go.jp/data/mesh/"
  x <- 
    read_html(paste0(base_url, "m_itiran.htm"))
  links <- 
    x %>% 
    html_nodes(css = "#section > article:nth-child(2) > ul:nth-child(7) > li > a") %>% 
    html_attr("href")
  seq.int(length(links)) %>% 
    walk(~ download.file(paste0(base_url, links[.x]),
                        destfile = paste0("data-raw/city_mesh/city_mesh_", 
                                          gsub(".+/", "",  links[.x]))))
}
x <- 
  list.files("data-raw/city_mesh/", full.names = TRUE)
df_city_mesh <- 
  c(
    seq.int(4, 33),
    seq.int(35, 49)
  ) %>% 
  map_df(~ read_csv(x[.x],
                    locale = locale(encoding = "cp932"),
                    col_types = list(col_character(), col_character(), col_character())) %>% 
           purrr::set_names(c("city_code", "city_name", "meshcode")))

df_city_mesh_b <- 
  c(seq.int(1, 3),
  34) %>% 
  map_df(~ read_csv(x[.x],
                    locale = locale(encoding = "cp932"),
                    col_types = list(col_character(), col_character(), col_character(), col_character())) %>% 
           purrr::set_names(c("city_code", "city_name", "meshcode", "note")))
df_city_mesh_b$note <- NULL

df_city_mesh <- 
  rbind(df_city_mesh,
      df_city_mesh_b) %>% 
  # dplyr::mutate(meshcode = meshcode(meshcode, size = 1)) %>% 
  dplyr::arrange(city_code)

usethis::use_data(df_city_mesh,
                   overwrite = TRUE,
                   internal = TRUE)
