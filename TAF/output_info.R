# Extract likelihoods, write CSV output tables

# Before: model.rds (model)
# After:  likelihoods.csv, stats.csv (output)

library(TAF)
library(r4ss)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
likelihoods <- model$likelihoods_used

# Format likelihoods
likelihoods <- likelihoods[likelihoods$values != 0,]
likelihoods <- as.data.frame(t(likelihoods["values"]))

# Construct stats table
npar <- model$N_estimated_parameters
objfun <- likelihoods$TOTAL
gradient <- model$maximum_gradient_component
start <- sub("StartTime: ", "", model$StartTime)
runtime <- sub("\\.$", "", model$RunTime)
version <- sub(";.*", "", model$SS_version)
stats <- data.frame(npar, objfun, gradient, start, runtime, version)

# Write table
write.taf(likelihoods, dir="output")
write.taf(stats, dir="output", quote=TRUE)
