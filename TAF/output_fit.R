# Extract model fit to data, write CSV output tables

# Before: model.rds (model)
# After:  cpue.csv, length_comps.csv, weight_comps.csv (output)

library(TAF)
library(r4ss)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")

# Construct cpue table
cpue <- model$cpue[c("Fleet", "Fleet_name", "Area", "Yr", "Obs", "Exp", "SE")]
row.names(cpue) <- NULL

# Construct length.comps table
length.comps <- model$lendbase[c("Yr", "Month", "Fleet", "Area", "Bin", "Obs",
                                 "Exp", "Nsamp_adj")]
names(length.comps)[names(length.comps) == "Bin"] <- "Length"
row.names(length.comps) <- NULL

# Construct weight.comps table
weight.comps <- model$sizedbase[c("Yr", "Month", "Fleet", "Area", "Bin", "Obs",
                                  "Exp", "Nsamp_adj")]
names(weight.comps)[names(weight.comps) == "Bin"] <- "Weight"
row.names(weight.comps) <- NULL

# Write tables
write.taf(cpue, dir="output")
write.taf(length.comps, dir="output")
write.taf(weight.comps, dir="output")
