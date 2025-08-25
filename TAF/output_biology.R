# Extract biology results, write CSV output tables

# Before: model.rds (model)
# After:  biology.csv (output)

library(TAF)
library(r4ss)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
endgrowth <- model$endgrowth

# Construct biology table
biology <- subset(endgrowth, Seas==1 & Settlement==1,
                  c("Sex", "Age_Beg", "M", "Len_Beg", "Wt_Beg", "Age_Mat"))
names(biology) <- sub("_Beg", "", names(biology))
names(biology) <- sub("Age_", "", names(biology))
biology[biology < 0] <- NA
row.names(biology) <- NULL

# Write table
write.taf(biology, dir="output")
