# meshcode_to_latlong, latlong_to_meshcode
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

saveRDS(jpmesh.pref, file = "data/jpmesh.prefs.rds")

jpmesh.prefs.tidy <- readRDS("data/jpmesh.prefs.rds") %>% 
  tidyr::unnest() %>% 
  select(-piece, -hole) %>% 
  mutate(file = gsub(".+//city-mesh_", "", file) %>% 
           gsub(".csv", "", .) %>% 
           gsub("-.+", "", .)) %>% 
  rename(jiscode = file)

devtools::use_data(jpmesh.prefs.tidy, overwrite = TRUE)

# df.tmp <- jpmesh.prefs.tidy %>% dplyr::filter(jiscode == "33")
# ggplot() +
#   geom_map(data = df.tmp,
#            map = df.tmp,
#            aes(x = long, y = lat, map_id = id),
#            fill = "white", color = "black") +
#   coord_map(projection = "mercator")
