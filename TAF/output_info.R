# Extract results of interest, write CSV output tables

# Before: model.rds (model)
# After:  biology.csv, catch.csv, likelihoods.csv, movement.csv,
#         stats.csv (output)

library(TAF)
library(r4ss)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
catch <- model$catch
endgrowth <- model$endgrowth
likelihoods <- model$likelihoods_used
movement <- model$movement

# Biology
biology <- subset(endgrowth, Seas==1 & Settlement==1,
                  c("Sex", "Age_Beg", "M", "Len_Beg", "Wt_Beg", "Age_Mat"))
names(biology) <- sub("_Beg", "", names(biology))
names(biology) <- sub("Age_", "", names(biology))
biology[biology < 0] <- NA
row.names(biology) <- NULL

# Catch
catch <- catch[c("Fleet", "Fleet_Name", "Area", "Yr", "Seas", "dead_bio")]
catch <- catch[catch$Yr >= model$startyr,]
names(catch)[names(catch) == "dead_bio"] <- "Catch"
row.names(catch) <- NULL

# Likelihoods
likelihoods <- likelihoods[likelihoods$values != 0,]
likelihoods <- as.data.frame(t(likelihoods["values"]))

# Movement
movement <- subset(movement, Seas==1, c("Source_area", "Dest_area", "age0"))
names(movement) <- c("Source", "Dest", "Rate")
row.names(movement) <- NULL

# Stats
npar <- model$N_estimated_parameters
objfun <- likelihoods$TOTAL
gradient <- model$maximum_gradient_component
start <- sub("StartTime: ", "", model$StartTime)
runtime <- sub("\\.$", "", model$RunTime)
version <- sub(";.*", "", model$SS_version)
stats <- data.frame(npar, objfun, gradient, start, runtime, version)

# Write tables
write.taf(biology, dir="output")
write.taf(catch, dir="output")
write.taf(likelihoods, dir="output")
write.taf(movement, dir="output")
write.taf(stats, dir="output", quote=TRUE)
