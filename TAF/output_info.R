# Extract results of interest, write CSV output tables

# Before: model.rds (model)
# After:  biology.csv, catch.csv, likelihoods.csv, movement.csv,
#         selectivity.csv, stats.csv (output)

library(TAF)
library(r4ss)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
catch <- model$catch
endgrowth <- model$endgrowth
likelihoods <- model$likelihoods_used
movement <- model$movement
sizeselex <- model$sizeselex

# Biology
biology <- subset(endgrowth, Seas==1 & Settlement==1,
                  c("Sex", "Age_Beg", "M", "Len_Beg", "Wt_Beg", "Mat_F_Natage"))
names(biology) <- sub("_Beg", "", names(biology))
names(biology) <- sub("_F_Natage", "", names(biology))
row.names(biology) <- NULL

# Catch
catch <- catch[c("Fleet", "Fleet_Name", "Area", "Yr", "Seas", "dead_bio")]
catch <- catch[catch$Yr >= model$startyr,]
names(catch)[names(catch) == "dead_bio"] <- "Catch"
row.names(catch) <- NULL

# Likelihoods
likelihoods <- likelihoods[likelihoods$values != 0,]
likelihoods <- data.frame(t(likelihoods["values"]), row.names=NULL)

# Movement
movement <- movement[movement$Seas==1, c("Source_area", "Dest_area", "age0")]
names(movement) <- c("Source", "Dest", "Rate")
row.names(movement) <- NULL

# Selectivity
selectivity <- sizeselex[sizeselex$Factor == "Lsel",]
selectivity <- selectivity[selectivity$Sex == 1,]
selectivity <- selectivity[selectivity$Yr == model$endyr,]
exclude <- c("Factor", "Yr", "Sex", "Label")
selectivity <- selectivity[!names(selectivity) %in% exclude]
selectivity <- taf2long(selectivity, names=c("Fleet", "Length", "Sel"))

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
write.taf(selectivity, dir="output")
