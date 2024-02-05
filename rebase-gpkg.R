source("header.R")
source("gpkg-rebase-functions.R")
# 1 - read worked up  spatial data

sbf_set_sub("gpkg_spatial")
sbf_load_datas()

keys <- sbf_load_object("keys")
crs <- 26911

sbf_set_main(spatial_dir)
sbf_reset_sub()

# 2 - save any gpkgs that have not yet been exported
gpkg_dir <- file.path(spatial_dir, "gpkg")
save_new_gpkgs(gpkg_dir, keys)

# 3 - read meta data, supply empty meta data cols for new data.
gpkg_files <- list.files(gpkg_dir, pattern = ".gpkg$", full.names = TRUE)
gpkg_names <- basename(gpkg_files) %>% str_replace(".gpkg$", "")
meta_list <- read_meta(gpkg_files, keys)

# 4 - serialize - write meta data to R file (overwrites contents)
serialize_meta(meta_list)

# 5 - rebase - read meta data construct and overwrite local meta data
# this way we rely on hard coded meta data in case everything else gets lost.
rebase_meta()

sbf_save_gpkgs()