#### rebase gpkg ####
# the idea is to add label positioning meta data to gpkgs as proper data columns
# these can then be read in again to R and joined to the original data.
# this allows the user to re-export data without losing work done in QGIS.
# stores copies of modified gpkgs in another folder (gpkg_rebase) so that the 
# user doesnt accidentally overwrite data in the main workup folder and lose changes.

# need a package for some basic functions, workflow will be designed so a user 
# can run the same code whether its an initial workup or a rebase

# note 1: could also be part of a larger package that creats QLM files for storage
# of more complex meta data that connot be stored as columns:
# (layer symbology, rendering, grouping, etc)

# note 2: could also add a component that dputs the modifications after read in
# that then gets sourced to reproduce the objects. this way there would be a
# hard coded version of the meta data that's backed up (github) and we aren't
# relying on some data sitting in a folder on dropbox.

#### basic example of process: ####

source("header.R")

# function 1 - save_rebase - make copy of all files in gpkg folder (empty on first workup)
sbf_set_main(spatial_dir)

dir <- sbf_get_main()
gpkg_dir <- file.path(dir, "gpkg")
rebase_dir <- file.path(dir, "gpkg_rebase")

files <- list.files(gpkg_dir, full.names = TRUE, recursive = TRUE)
if(!dir.exists(rebase_dir)) dir.create(rebase_dir)
file.copy(files, rebase_dir, overwrite = TRUE)

# note: spatial exports will now require a list of primary keys for all datas 
# so that meta data added in QGIS can be joined to the original data.
keys <- c("loc" = "id")

# original raw data workup occurs here
loc <- tibble(
  id = 1, X = 505571, Y = 5496619
) %>%
  ps_coords_to_sfc(crs = 26911)

# function 2 - rebase (step 1) - reads and cleans modified files (returns nothing if rebase dir empty)
# would be good to have function sbf_load_gpkgs, and maybe even sbf_load_gpkg_rebase for this
rebase_files <- list.files(rebase_dir, full.names = TRUE, recursive = TRUE, pattern = ".gpkg$")

if(length(rebase_files)) {
 
  x_name <- "loc"
  meta_cols <- c( # should add call out line and feature rotation cols
    "auxiliary_storage_labeling_positionx",
    "auxiliary_storage_labeling_positiony",
    "auxiliary_storage_labeling_labelrotation"
  )
  key <- keys[x_name] %>% unname()
  cols <- c(key, meta_cols)
  
  loc_rebased <- st_read(rebase_files[1], quiet = TRUE) %>%
    as_tibble() %>%
    select(all_of(cols))
  
  # note: dput reproduction would occur here
  
  # function - rebase (step 2) - matches rebased to og files based on name,
  # then joins rebased data based on provided key
  
  loc %<>% left_join(loc_rebased %>% as_tibble, by = key)  
  
}

# add meta columns only if not added by rebase (first workup)
loc %<>% add_label_meta()

# must clean up rebase files so they dont get saved in original workup folder
rm(list = ls()[str_detect(ls(), "rebased")])
sbf_save_gpkgs()

# QGIS Notes:
# must use each datas 'key' for label storage when starting to move labels

# works best to highjack QGIS default column names for label positioning:
# eg. "auxiliary_storage_labeling_positionx" as this way you dont have to manually
# set the position storage columns
