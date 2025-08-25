# Extract numbers at age, write CSV output tables

# Before: model.rds (model)
# After:  natage.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
natage <- model$natage[model$natage$Era == "TIME",]

# Calculate numbers at age
natage <- natage[natage$Seas == 1,]
natage <- natage[natage$"Beg/Mid" == "B",]
natage <- natage[natage$BirthSeas == 1,]
natage$Era <- NULL
natage$"Beg/Mid" <- NULL
natage$Time <- NULL
natage$Bio_Pattern <- NULL
natage$Platoon <- NULL
natage$BirthSeas <- NULL
natage$Settlement <- NULL
natage$Seas <- NULL
natage$Morph <- NULL
