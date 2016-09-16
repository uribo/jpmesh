library(dplyr)
library(jpmesh)

df.mesh.csv <- list.files("data-raw/city_mesh/", full.names = TRUE) %>% data_frame(file = .)

jpmesh.pref <- df.mesh.csv %>% 
  group_by(file) %>% 
  do(res = pref_mesh(.$file)) %>% 
  tidyr::unnest() %>% 
  select(-piece, -hole) %>% 
  mutate(file = gsub(".+//city-mesh_", "", file) %>% 
           gsub(".csv", "", .) %>% 
           gsub("-.+", "", .)) %>% 
  rename(jiscode = file)

devtools::use_data(jpmesh.pref, overwrite = TRUE)
