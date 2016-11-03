#################################################
# 
#################################################
# Load Employed Packages --------------------------------------------------
library(dplyr)
library(foreach)
library(jpmesh)

df.mesh.csv <- list.files("data-raw/city_mesh", full.names = TRUE) %>% data_frame(file = .)

jpmesh.pref <- df.mesh.csv %>% 
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
    readr::write_rds(path = paste0("inst/extdata/pref_", sprintf("%02s", i), "_mesh.rds"))
}
