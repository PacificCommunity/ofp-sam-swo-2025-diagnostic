# Extract catch results, write CSV output tables

# Before: model.rds (model)
# After:  catch.csv (output)

library(TAF)
library(r4ss)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
catch <- model$catch

# Construct catch table
catch <-
  catch[c("Fleet", "Fleet_Name", "Area", "Yr", "Seas", "Time", "dead_bio")]
catch <- catch[catch$Yr >= model$startyr,]
names(catch)[names(catch) == "dead_bio"] <- "Catch"
row.names(catch) <- NULL

# Write table
write.taf(catch, dir="output")
