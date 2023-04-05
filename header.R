library(poispkgs)

stopifnot(packageVersion("poispkgs") >= "0.0.1.9017")

dtt_set_default_tz("Etc/GMT+8")

theme_set(theme_Poisson())

options(sbf.ask = FALSE)

sbf_set_main("output")
sbf_reset_sub()

rm(list = ls())
graphics.off()

source("functions.R")

project <- basename(getwd())

dir <- paste0("~/Poisson/Data/", sub("-\\d\\d$", "", project))

spatial_dir <- file.path(sub("/Data/", "/Spatial/", dir))
