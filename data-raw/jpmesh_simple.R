#################################################
# 47都道府県の地図を単純に表現したもの
#################################################

# Load Employed Packages --------------------------------------------------
library(dplyr)
# library(purrrlyr)
# library(geojsonio)
library(tidyr)
library(testthat)
library(sf)

# 各都道府県の位置を示す4点を含むデータセット
df.mesh4.rect <- tibble::data_frame(
  mesh4 = c(
  # 1 - 6
  6041, # 北海道
  5840, # 青森
  5740, # 岩手
  5640, # 宮城
  5739, # 秋田
  5639, # 山形
  5540, # 福島
  5539, # 栃木
  5438, # 群馬
  5440, # 茨城
  5439, # 埼玉
  5340, # 千葉
  5339, # 東京都
  5239, # 神奈川県
  # 15 - 20
  5538,  # 新潟県
  5437, # 富山県
  5436, # 石川県
  5336, # 福井県
  5338, # 山梨
  5337, # 長野県
  # 21 - 25
  5236, # 岐阜県
  5238, # 静岡
  5237, # 愛知県
  5136, # 三重県
  5235, # 滋賀県
  # 26 - 30
  5335, # 京都
  5234, # 大阪
  5334, # 兵庫
  5135, # 奈良
  5035, # 和歌山
  # 31 - 35
  5333, # 島根
  5332, # 鳥取
  5233, # 岡山
  5232, # 広島
  5231, # 山口
  # # 36 - 39
  4933, # 徳島
  5033, # 香川
  5032, # 愛媛県
  4932, # 高知
  # # 40 - 47
  5130, # 福岡
  5129, # 佐賀
  5128, # 長崎
  5029, # 熊本
  5030, # 大分
  4930, # 宮崎
  4929, # 鹿児島
  4727 # 沖縄県
)) %>%
  dplyr::mutate(mesh_area = purrr::map(mesh4, jpmesh::meshcode_to_latlon)) %>%
  tidyr::unnest() %>%
  dplyr::mutate(mesh4 = jpmesh::latlong_to_meshcode(lat_center, long_center, order = 1)) %>%
  jpmesh:::mesh_rectangle(code = "mesh4", view = FALSE)
expect_equal(dim(df.mesh4.rect), c(47, 10))
expect_named(df.mesh4.rect, c("rowname", "mesh_code", 
                              "lat_center", "long_center",
                              "lat_error", "long_error",
                              "lng1", "lat1", "lng2", "lat2"))

jp_map <- df.mesh4.rect %>%
  purrrlyr::by_row(mk_poly) %>%
  use_series(.out) %>%
  st_sfc() %>% 
  as_data_frame()

# df.mesh4.rect %<>% 
#   purrrlyr::by_row(ttt, .collate = "rows") %>% 
#   dplyr::distinct(rowname)
# 
# df.mesh4.rect %>% 
#   filter(rowname == "1") %>% 
#   mutate(ppp = paste0("POLYGON((", lng1, lng1, ", "))
# 
#   purrrlyr::slice_rows("rowname") %>% 
#   purrrlyr::by_row(
#     ~ sf::st_polygon(list(matrix(c(.[1, ]$lng1, .[1, ]$lat2,
#                                    .[1, ]$lng2, .[1, ]$lat2,
#                                    .[1, ]$lng2, .[1, ]$lat1,
#                                    .[1, ]$lng1, .[1, ]$lat1,
#                                    .[1, ]$lng1, .[1, ]$lat2),
#                                  ncol = 2, 
#                                  byrow = TRUE)), "XY"),
#     .collate = "list", # listでないとだめ
#     .to = "poly"
#   )
#   # dplyr::select(rowname, mesh_code, latitude = lat_center, longitude = long_center)
# expect_equal(dim(df.mesh4.rect), c(235, 15))
# 
# d <- df.mesh4.rect %>% select(mesh_code, poly) %>% unique()
# d$poly[[18]] %>% plot()
# d$poly[[19]] %>% plot(add = TRUE)
# d$poly[[20]] %>% plot(add = TRUE)
# 
# d$poly[[1]] %>% class()
# sf::st_as_sfc(g) %>% class()
# 
# d %>% 
#   rowwise() %>% 
#   mutate(poly = sf::st_as_sfc(poly))

jp_map$abb_name <- c("HKD", "AOM", "IWT", "MYG", "AKT", "YGT", "FKS", "IBR", "TCG", "GNM", "SIT", "CHB",
                            "TKY", "KNG", "NGT", "TYM", "ISK", "FKI", "YMN", "NGN", "GIF", "SZO", "AIC", "MIE",
                            "SIG", "KYT", "OSK", "HYG", "NAR", "WKY", "TTR", "SMN", "OKY", "HRS", "YGC", "TKS",
                            "KGW", "EHM", "KUC", "FKO", "SAG", "NGS", "KMM", "OIT", "MYZ", "KGS", "OKN")

# df.mesh4.rect.out %>% dplyr::mutate(group = as.character(group)) %>%
#   geojson_json(input    = .,
#                           group    = "group",
#                           lon      = "long",
#                           lat      = "lat",
#                           geometry = "polygon") %>%
#   geojson_write(input = .,
#                            file = "tmp.geojson",
#                            group = "group",
#                            geometry = "polygon")
# 
# jp_map <- geojson_read("tmp.geojson",
#                                   method = "local",
#                                   what = "sp") %>% fortify()
# 
# jpnrect <- jp_map %>% mutate(id = (as.numeric(id) + 1) %>% as.character()) %>%
#   left_join(df.mesh4.rect, by = c("id" = "rowname"))

jpnrect <- jp_map %>% bind_cols(df.mesh4.rect) %>% 
  select(jis_code = rowname, abb_name, mesh_code, geometry) %>% 
  mutate(jis_code = as.numeric(jis_code) %>% sprintf("%02d", .)) %>% 
  st_as_sf()
expect_s3_class(jpnrect, c("sf", "tbl", "data.frame"))
expect_equal(dim(jpnrect), c(47, 4))
expect_named(jpnrect, c("jis_code", "abb_name", "mesh_code", "geometry"))

devtools::use_data(jpnrect, overwrite = TRUE)
# rm("tmp.geojson")
# long     lat order  hole piece id group mesh_code      latitude 
# longitude abb_name
