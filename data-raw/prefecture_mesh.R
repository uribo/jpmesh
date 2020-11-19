#########################################
# 47都道府県がどのメッシュに該当するか
#########################################
pkgload::load_all()
library(sf)
library(dplyr)
library(purrr)
library(tidyr)
library(testthat)

df_jp80km_mesh <- 
  tibble(
  meshcode = meshcode_set(mesh_size = 80, .raw = FALSE))

expect_equal(nrow(df_jp80km_mesh), 176L)

####################################
# 1/200,000 scale
####################################
df_1_200000_zumei <- 
  tribble(
    ~meshcode_80km, ~name, ~name_roman, ~type,
    6840, "稚内", "wakkanai", FALSE,
    6841, "稚内", "wakkanai", TRUE,
    6842, "稚内", "wakkanai", FALSE,
    6847, "蕊取", "shibetoro", FALSE,  
    6848, "蕊取", "shibetoro", TRUE,
    6740, "天塩", "teshio", FALSE,
    6741, "天塩", "teshio", TRUE,
    6742, "枝幸", "esashi", TRUE,
    6748, "別飛", "bettobu", TRUE,
    6747, "紗那", "shana", TRUE,
    6641, "羽幌", "haboro", TRUE,
    6642, "名寄", "nayoro", TRUE,
    6643, "紋別", "mombetsu", TRUE,
    6644, "網走", "abashiri", TRUE,
    6645, "知床岬", "shiretokomisaki", TRUE,
    6646, "安渡移矢岬", "atoiyamisaki", TRUE,
    6647, "得茂別湖", "urumombekko", TRUE,
    6540, "岩内", "iwanai", FALSE,
    6541, "留萌", "rumoi", TRUE,
    6542, "旭川", "asahikawa", TRUE,
    6543, "北見", "kitami", TRUE,
    6544, "斜里", "shari", TRUE,
    6545, "標津", "shibetsu", TRUE,
    6546, "色丹島", "shikotanto", TRUE,
    6439, "久遠", "kudo", FALSE,
    6440, "岩内", "iwanai", TRUE,
    6441, "札幌", "sapporo", TRUE,
    6442, "夕張岳", "yobaridake", TRUE,
    6443, "帯広", "obihiro", TRUE,
    6444, "釧路", "kushiro", TRUE,
    6445, "根室", "nemuro", TRUE,
    6339, "久遠", "kudo", TRUE,
    6340, "室蘭", "muroran", TRUE,
    6341, "苫小牧", "tomakomai", TRUE,
    6342, "浦河", "urakawa", TRUE,
    6343, "広尾", "hiro", TRUE,
    6239, "渡島大島", "oshimaoshima", TRUE,
    6240, "函館", "hakodate", TRUE,
    6241, "尻屋崎", "shiriyazaki", TRUE,
    6243, "広尾", "hiro", FALSE,
    6139, "青森", "aomori", FALSE,
    6140, "青森", "aomori", TRUE,
    6141, "野辺地", "noheji", TRUE,
    6039, "深浦", "fukaura", TRUE,
    6040, "弘前", "hirosaki", TRUE,
    6041, "八戸", "hachinohe", TRUE,
    5939, "男鹿", "oga", TRUE,
    5940, "秋田", "akita", TRUE,
    5941, "盛岡", "morioka", TRUE,
    5942, "盛岡", "morioka", FALSE,
    5839, "酒田", "sakata", TRUE,
    5840, "新庄", "shinjo", TRUE,
    5841, "一関", "ichinoseki", TRUE,
    5738, "相川", "aikawa", TRUE,
    5739, "村上", "murakami", TRUE,
    5740, "仙台", "sendai", TRUE,
    5741, "石巻", "ishinomaki", TRUE,
    5636, "輪島", "wajima", TRUE,
    5637, "輪島", "wajima", FALSE,
    5638, "長岡", "nagaoka", TRUE,
    5639, "新潟", "niigata", TRUE,
    5640, "福島", "fukushima", TRUE,
    5641, "福島", "fukushima", FALSE,
    5531, "西郷", "saigo", FALSE,
    5536, "七尾", "nanao", TRUE,
    5537, "富山", "toyama", TRUE,
    5538, "高田", "takada", TRUE,
    5539, "日光", "nikko", TRUE,
    5540, "白河", "shirakawa", TRUE,
    5541, "白河", "shirakawa", FALSE,
    5432, "西郷", "saigo", FALSE,
    5433, "西郷", "saigo", TRUE,
    5435, "金沢", "kanazawa", FALSE,
    5436, "金沢", "kanazawa", TRUE,
    5437, "高山", "takayama", TRUE,
    5438, "長野", "nagano", TRUE,
    5439, "宇都宮", "utsunomiya", TRUE,
    5440, "水戸", "mito", TRUE,
    5332, "大社", "taisha", TRUE,
    5333, "松江", "matsue", TRUE,
    5334, "鳥取", "tottori", TRUE,
    5335, "宮津", "miyazu", TRUE,
    5336, "岐阜", "gifu", TRUE,
    5337, "飯田", "iida", TRUE,
    5338, "甲府", "kofu", TRUE,
    5339, "東京", "tokyo", TRUE,
    5340, "千葉", "chiba", TRUE,
    5229, "厳原", "izuhara", FALSE,
    5231, "見島", "mishima", TRUE,
    5232, "浜田", "hamada", TRUE,
    5233, "高梁", "takahashi", TRUE,
    5234, "姫路", "himeji", TRUE,
    5235, "京都及大阪", "kyotoyobiosaka", TRUE,
    5236, "名古屋", "nagoya", TRUE,
    5237, "豊橋", "toyohashi", TRUE,
    5238, "静岡", "shizoka", TRUE,
    5239, "横須賀", "yokosuka", TRUE,
    5240, "大多喜", "otaki", TRUE,
    5129, "厳原", "izuhara", TRUE,
    5130, "小串", "kogushi", TRUE,
    5131, "山口", "yamaguchi", TRUE,
    5132, "広島", "hiroshima", TRUE, 
    5133, "岡山及丸亀", "okayamaoyobimarugame", TRUE,
    5134, "徳島", "tokushima", TRUE,
    5135, "和歌山", "wakayama", TRUE,
    5136, "伊勢", "ise", TRUE,
    5137, "伊良湖岬", "iragomisaki", TRUE,
    5138, "御前崎", "omaezaki", TRUE,
    5139, "三宅島", "miyakejima", TRUE,
    5029, "唐津", "karatsu", TRUE,
    5030, "福岡", "fukoka", TRUE,
    5031, "中津", "nakatsu", TRUE,
    5032, "松山", "matsuyama", TRUE,
    5033, "高知", "kochi", TRUE,
    5034, "剣山", "tsurugisan", TRUE,
    5035, "田辺", "tanabe", TRUE,
    5036, "木本", "kinomoto", TRUE,
    5038, "御蔵島", "mikurajima", FALSE,
    5039, "御蔵島", "mikurajima", TRUE,
    4928, "福江", "fukue", TRUE,
    4929, "長崎", "nagasaki", TRUE,
    4930, "熊本", "kumamoto", TRUE,
    4931, "大分", "oita", TRUE,
    4932, "宇和島", "uwajima", TRUE,
    4933, "窪川", "kubokawa", TRUE, 
    4934, "剣山", "tsurugisan", FALSE,
    4939, "八丈島", "hachijojima", TRUE,
    4828, "富江", "tomie", TRUE,
    4829, "野母崎", "nomozaki", TRUE, 
    4830, "八代", "yatsushiro", TRUE,
    4831, "延岡", "nobeoka", TRUE,
    4839, "八丈島", "hachijojima", FALSE,
    4728, "富江", "tomie", FALSE,
    4729, "甑島", "koshikijima", TRUE,
    4730, "鹿児島", "kagoshima", TRUE,
    4731, "宮崎", "miyazaki", TRUE,
    4739, "八丈島", "hachijojima", FALSE,
    4740, "八丈島", "hachijojima", FALSE,
    4629, "黒島", "kuroshima", TRUE,
    4630, "開聞岳", "kaimondake", TRUE,
    4631, "開聞岳", "kaimondake", FALSE,
    4529, "中之島", "nakanoshima", FALSE,
    4530, "屋久島", "yakushima", TRUE,
    4531, "屋久島", "yakushima", FALSE,
    4540, "八丈島", "hachijojima", FALSE,
    4429, "中之島", "nakanoshima", TRUE,
    4440, "八丈島", "hachijojima", FALSE,
    4328, "宝島", "takarajima", FALSE,
    4329, "宝島", "takarajima", TRUE,
    4229, "奄美大島", "amamioshima", TRUE,
    4230, "奄美大島", "amamioshima", FALSE,
    4128, "徳之島", "tokunoshima", TRUE, 
    4129, "徳之島", "tokunoshima", FALSE,
    4142, "小笠原諸島", "ogasawarashoto", FALSE,
    4027, "与論島", "yoronjima", TRUE,
    4028, "徳之島", "tokunoshima", FALSE,
    4040, "小笠原諸島", "ogasawarashoto", FALSE,
    4042, "小笠原諸島", "ogasawarashoto", TRUE,
    3926, "久米島", "kumejima", TRUE,
    3927, "那覇", "naha", TRUE,
    3928, "那覇", "naha", FALSE,
    3942, "小笠原諸島", "ogasawarashoto", FALSE, ##?
    3823, "魚釣島", "otsurijima", TRUE,
    3824, "魚釣島", "otsurijima", FALSE,
    3831, "那覇", "naha", FALSE,
    3841, "小笠原諸島", "ogasawarashoto", FALSE,
    3724, "宮古島", "miyakojima", FALSE,
    3725, "宮古島", "miyakojima", TRUE,
    3741, "小笠原諸島", "ogasawarashoto", FALSE,
    3622, "石垣島", "ishigakijima", FALSE,
    3623, "石垣島", "ishigakijima", FALSE,
    3624, "石垣島", "ishigakijima", TRUE,
    3631, "那覇", "naha", FALSE,
    3641, "小笠原諸島", "ogasawarashoto", FALSE,
    3653, "小笠原諸島", "ogasawarashoto", FALSE,
    3036, "小笠原諸島", "ogasawarashoto", FALSE
) %>% 
  mutate(meshcode_80km = meshcode(meshcode_80km_num))
expect_equal(dim(df_1_200000_zumei), c(176, 4))

jpmesh_bind <- 
  df_jp80km_mesh %>%
  meshcode_sf(meshcode)

# expect_equal(dim(jpmesh_bind), c(176, 5))

sf_jpmesh <- 
  jpmesh_bind %>%
  left_join(df_1_200000_zumei,
            by = c("meshcode" = "meshcode_80km")) %>% 
  select(meshcode, name, name_roman, type, geometry) %>% 
  mutate(name = stringi::stri_conv(name, to = "UTF8"))
expect_s3_class(sf_jpmesh, c("sf"))
expect_s3_class(sf_jpmesh, c("tbl_df"))
expect_equal(dim(sf_jpmesh), c(sf_jpmesh$meshcode %>% n_distinct(), 5))
expect_named(sf_jpmesh,
             c("meshcode", "name", "name_roman",
               "type", "geometry"))

# library(leaflet)
# leaflet(data = sf_jpmesh) %>% addTiles() %>% addPolygons(label = ~as.character(meshcode),
#                                          labelOptions = labelOptions(noHide = TRUE, textsize = "24px"))
# plot(sf_jpmesh["meshcode"])

# For use a dataset
usethis::use_data(sf_jpmesh, overwrite = TRUE)
