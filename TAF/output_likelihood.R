# Extract likelihood, write CSV output tables

# Before: model.rds (model)
# After:  likelihood.csv (output)

library(TAF)
library(r4ss)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
likelihood <- model$likelihoods_used

# Exclude zeros
likelihood <- likelihood[likelihood$values != 0,]

# Add component column
likelihood <- xtab2taf(likelihood, "Component")

# Write table
write.taf(likelihood, dir="output")
