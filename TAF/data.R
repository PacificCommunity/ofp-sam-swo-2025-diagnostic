# Prepare data, write CSV data tables

# Before: fisheries.txt, ss3.zip (boot/data)
# After:  cpue.csv, fisheries.csv, length_comps.csv, weight_comps.csv (data)

library(TAF)
library(r4ss)

mkdir("data")

# Read model results
taf.unzip("boot/data/ss3.zip", exdir="boot/data/ss3")
dat <- SS_readdat("boot/data/ss3/swo2025.dat", verbose=FALSE)

# CPUE
cpue <- dat$CPUE
cpue$month <- NULL

# Fisheries
fisheries <- read.table("boot/initial/data/fisheries.txt", header=TRUE)

# Length comps
length.comps <- comp2long(dat$lencomp)
length.comps <- length.comps[length.comps$sex == "f",]
length.comps$part <- NULL
length.comps$sex <- NULL

# Weight comps
weight.comps <- comp2long(dat$sizefreq_data_list[[1]], measure="weight")
weight.comps <- weight.comps[weight.comps$sex == "f",]
weight.comps$method <- NULL
weight.comps$part <- NULL
weight.comps$sex <- NULL

# Write CSV tables
write.taf(cpue, dir="data")
write.taf(fisheries, dir="data", quote=TRUE)
write.taf(length.comps, dir="data")
write.taf(weight.comps, dir="data")
