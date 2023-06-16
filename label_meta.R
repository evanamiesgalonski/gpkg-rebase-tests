source("header.R")
library(datapasta)

# proccess to rebase symbology label metadata by hard coding info into script
dir <- file.path(spatial_dir, "gpkg")

loc <- st_read(file.path(dir, "loc.gpkg"), quiet = TRUE)

# user must provide list of keys to preserve pk for each dataset
key <- c("loc" = "id")

# get relevant col names related to metadata
# should use lookup table that exists in package
meta_cols <- c(
  unname(key),
  "auxiliary_storage_labeling_positionx",
  "auxiliary_storage_labeling_positiony",
  "auxiliary_storage_labeling_labelrotation"
  )

# for new each data set we construct a label meta data tribble with na values for each column
# then we can make changes to the file and rebase by reading in modified file
# and re-constructing the metadata tribble and overwriting

# extend the code below to work with a named list, use the names of the objects as list element names
# then wrap tribble_construct in a paste that assigns each object to the og data
# name in symbology.R ie; loc_meta.

# rebase_meta <- function
# this will be a function that will overwrite the symbology.R
# completely based on the new changes made to the files, filling in with templated
# metadata for new data sets.

# apply_meta <- function
# the data sets in sybology.R then get joined to the data in the workup folder
# the data can then be exported

# note: we need a sbf_load_gpkg function in order to batch read in all files
# that are being used in a Qgis project

# the work flow goes:
# 1 - work up data
# 2 - apply meta
# 3 - copy data and modify in qgis (do we actually need to copy though? think about it)

# the next steps are repeated indefinitely
# 4 - load gpkgs
# 5 rebase_meta
# 6 apply_meta
# modify in QGIS


meta <- loc %>%
  as.tibble() %>%
  select(all_of(meta_cols)) %>%
  datapasta::tribble_construct()

# write to symblogy file
write_lines(meta, "symbology.r")


# works ok, may need to have a step that converts names when applying symbology
# the actual default colnames are too long for it to be reasonably human readable.