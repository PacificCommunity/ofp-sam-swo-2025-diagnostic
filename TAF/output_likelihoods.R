# Extract likelihoods, write CSV output tables

# Before: model.rds (model)
# After:  likelihoods.csv (output)

library(TAF)
library(r4ss)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
likelihoods <- model$likelihoods_used

# Exclude zeros
likelihoods <- likelihoods[likelihoods$values != 0,]

# Add component column
likelihoods <- xtab2taf(likelihoods, "Component")

# Write table
write.taf(likelihoods, dir="output")
