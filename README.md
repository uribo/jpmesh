
<!-- README.md is generated from README.Rmd. Please edit that file -->
jpmesh <img src="logo.png" align="right" width="80px" />
========================================================

[![Travis-CI Build Status](https://travis-ci.org/uribo/jpmesh.svg?branch=master)](https://travis-ci.org/uribo/jpmesh) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/jpmesh)](https://cran.r-project.org/package=jpmesh) [![codecov](https://codecov.io/gh/uribo/jpmesh/branch/master/graph/badge.svg)](https://codecov.io/gh/uribo/jpmesh)

*English version of README is [here](https://github.com/uribo/jpmesh/blob/master/README.en.md)*

Overview
--------

**`{jpmesh}`**パッケージは、日本国内で利用される「地域メッシュ（メッシュコード）」をRから容易に利用可能にするパッケージです。地域メッシュとは、日本国土を緯度・経度により方形の小地域区画に細分した際に与えられるコードです。地域メッシュはコードの精度に応じて範囲とする区画の面積が異なっており、統計調査などでは同一メッシュを採用することで広い面積の調査結果を地域メッシュ単位で取り扱えるようになります。

**`{jpmesh}`**は現在、標準地域メッシュである第1次メッシュから分割地域メッシュの4分の1地域メッシュすなわち80kmから250mまでのメッシュコードに対応し、メッシュコードと緯度経度座標との互換を行います。主な機能として、「緯度経度からの地域メッシュへの変換」、「地域メッシュからの緯度経度の取得」、「都道府県単位やleaflet上へのマッピング」があります。

Installation
------------

パッケージはGitHub経由でインストール可能です。

``` r
# the development version from GitHub:
install.packages("devtools")
devtools::install_github("uribo/jpmesh")
```

Usage
-----

``` r
library(jpmesh)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
```

### Convert mesh code to coordinate and vice versa

メッシュコードからメッシュ範囲特定のための緯度経度の取得

``` r
meshcode_to_latlon(5133)
#>   lat_center long_center lat_error long_error
#> 1   34.33333       133.5 0.3333333        0.5
meshcode_to_latlon(513377)
#>   lat_center long_center  lat_error long_error
#> 1     34.625    133.9375 0.04166667     0.0625
meshcode_to_latlon(51337783)
#>   lat_center long_center   lat_error long_error
#> 1   34.65417    133.9187 0.004166667    0.00625
```

緯度経度から、範囲内のメッシュコードを取得

``` r
latlong_to_meshcode(34, 133, order = 1)
#> [1] 5133
latlong_to_meshcode(34.583333, 133.875, order = 2)
#> [1] 513367
latlong_to_meshcode(34.65, 133.9125, order = 3)
#> [1] 51337782
```

### Detect fine mesh code

``` r
detect_mesh(52350422, lat = 34.684176, long = 135.526130)
#> [1] 523504221
detect_mesh(523504221, lat = 34.684028, long = 135.529506)
#> [1] 5235042212
```

### Utilies

1次メッシュを基礎とした単純化した日本地図の描画

``` r
data("jpnrect")

ggplot() +
  geom_map(data = jpnrect,
           map  = jpnrect,
           aes(x = long, y = lat, map_id = id),
           fill = "#FFFFFF", color = "black",
           size = 1) +
  coord_map() +
  ggthemes::theme_map() +
  geom_text(aes(x = longitude, y = latitude, label = abb_name), data = jpnrect, size = 3)
```

![](README-jpn_simple_map-1.png)

都道府県別のメッシュコードデータ

``` r
pref_mesh(33) %>% head() %>% knitr::kable()
```

| jiscode |      long|       lat|  order| group      |        id| city\_code | city\_name |
|:--------|---------:|---------:|------:|:-----------|---------:|:-----------|:-----------|
| 33      |  133.5250|  34.30000|      1| 51333452.1 |  51333452| 33205      | 笠岡市     |
| 33      |  133.5375|  34.30000|      2| 51333452.1 |  51333452| 33205      | 笠岡市     |
| 33      |  133.5375|  34.29167|      3| 51333452.1 |  51333452| 33205      | 笠岡市     |
| 33      |  133.5250|  34.29167|      4| 51333452.1 |  51333452| 33205      | 笠岡市     |
| 33      |  133.5250|  34.30000|      5| 51333452.1 |  51333452| 33205      | 笠岡市     |
| 33      |  133.5250|  34.30833|      1| 51333462.1 |  51333462| 33205      | 笠岡市     |

可視化の一例

``` r
# For leaflet
# pref_mesh(33) %>% mesh_rectangle(mesh_code = "id", view = TRUE)
```

``` r
df.map <- pref_mesh(33) %>% 
  mutate(mesh_area = purrr::map(id, meshcode_to_latlon)) %>% 
  tidyr::unnest() %>% 
  mutate(lng1 = long_center - long_error,
         lat1 = lat_center - lat_error,
         lng2 = long_center + long_error,
         lat2 = lat_center + lat_error)

ggplot() + 
  geom_map(data = df.map, 
           map = df.map,
           aes(x = long, y = lat, map_id = id), 
           fill = "white", color = "black") + 
  coord_map(projection = "mercator")
```

![](README-mesh_pref33_map-1.png)
