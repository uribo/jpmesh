#################################################
# 47都道府県の地図を単純に表現したもの
#################################################

# Load Employed Packages --------------------------------------------------
library(dplyr)
library(foreach)
library(geojsonio)
library(tidyr)

# 各都道府県の位置を示す4点を含むデータセット
df.mesh4.rect <- data_frame(
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
  mutate(mesh_area = purrr::map(mesh4, jpmesh::meshcode_to_latlon)) %>%
  unnest() %>%
  mutate(mesh4 = jpmesh::latlong_to_meshcode(lat_center, long_center, order = 1)) %>%
  jpmesh::mesh_rectangle(mesh_code = "mesh4", view = FALSE)

df.mesh4.rect.out <- foreach(i = 1:nrow(df.mesh4.rect), .combine = rbind) %do% {
  data_frame(
    long  = c(df.mesh4.rect$lng1[i], df.mesh4.rect$lng1[i],
              df.mesh4.rect$lng2[i], df.mesh4.rect$lng2[i], df.mesh4.rect$lng1[i]),
    lat   = c(df.mesh4.rect$lat2[i], df.mesh4.rect$lat1[i],
              df.mesh4.rect$lat1[i], df.mesh4.rect$lat2[i], df.mesh4.rect$lat2[i]),
    group = rep(df.mesh4.rect$mesh_code[i], 5)
  )
}

df.mesh4.rect %<>%
  select(rowname, mesh_code, latitude = lat_center, longitude = long_center)
df.mesh4.rect$abb_name <- c("HKD", "AOM", "IWT", "MYG", "AKT", "YGT", "FKS", "IBR", "TCG", "GNM", "SIT", "CHB",
                            "TKY", "KNG", "NGT", "TYM", "ISK", "FKI", "YMN", "NGN", "GIF", "SZO", "AIC", "MIE",
                            "SIG", "KYT", "OSK", "HYG", "NAR", "WKY", "TTR", "SMN", "OKY", "HRS", "YGC", "TKS",
                            "KGW", "EHM", "KUC", "FKO", "SAG", "NGS", "KMM", "OIT", "MYZ", "KGS", "OKN")

df.mesh4.rect %>% readr::write_rds("inst/extdata/jpn_mesh4_pref_rect.rds")

df.mesh4.rect.out %>% dplyr::mutate(group = as.character(group)) %>%
  geojson_json(input    = .,
                          group    = "group",
                          lon      = "long",
                          lat      = "lat",
                          geometry = "polygon") %>%
  geojson_write(input = .,
                           file = "tmp.geojson",
                           group = "group",
                           geometry = "polygon")

jp_map <- geojson_read("tmp.geojson",
                                  method = "local",
                                  what = "sp") %>% fortify()

jpnrect <- jp_map %>% mutate(id = (as.numeric(id) + 1) %>% as.character()) %>%
  left_join(df.mesh4.rect, by = c("id" = "rowname"))

devtools::use_data(jpnrect, overwrite = TRUE)
rm("tmp.geojson")
