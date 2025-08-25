# Extract estimated selectivities, write CSV output tables

# Before: model.rds (model)
# After:  selectivitiy.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")

# Calculate selectivity
selectivity <- model$sizeselex
selectivity <- selectivity[selectivity$Factor == "Lsel",]
selectivity <- selectivity[selectivity$Sex == 1,]
selectivity <- selectivity[selectivity$Yr == model$endyr,]
selectivity$Factor <- NULL
selectivity$Yr <- NULL
selectivity$Sex <- NULL
selectivity$Label <- NULL
selectivity <- taf2long(selectivity, names=c("Fleet", "Length", "Sel"))

# Write table
write.taf(selectivity, dir="output")
