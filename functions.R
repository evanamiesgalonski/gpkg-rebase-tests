add_label_meta <- function(data) {
  if(!"auxiliary_storage_labeling_positionx" %in% names(data)) data$auxiliary_storage_labeling_positionx <- NA_real_
  if(!"auxiliary_storage_labeling_positiony" %in% names(data)) data$auxiliary_storage_labeling_positiony <- NA_real_
  if(!"auxiliary_storage_labeling_labelrotation" %in% names(data)) data$auxiliary_storage_labeling_labelrotation <- NA_real_
  data %<>% st_as_sf()
}
