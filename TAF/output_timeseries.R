# Extract F and stock by area, write CSV output tables

# Before: model.rds (model)
# After:  f_aggregated.csv, f_annual.csv, f_season.csv,
#         stock_by_area.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
exploitation <- model$exploitation
fatage <- model$fatage[model$fatage$Era == "TIME",]
timeseries <- model$timeseries[model$timeseries$Era == "TIME",]

# Calculate aggregated F by fleet
exploitation$Seas_dur <- NULL
exploitation$F_std <- NULL
exploitation$annual_F <- NULL
exploitation$annual_M <- NULL
f.aggregated <- wide2long(exploitation, names=c("Fleet", "F"))

# Calculate F by season
f.season <- fatage[fatage$Morph %in% c(1, 5),]
f.season$Morph <- NULL
f.season$Era <- NULL
f.season <- wide2long(f.season, names=c("Age", "F"))

# Calculate F by year
f.annual <- aggregate(F~Area+Fleet+Sex+Yr+Age, f.season, sum)

# Calculate stock by area
stock.by.area <- timeseries[timeseries$Seas == 1,]
names(stock.by.area)[names(stock.by.area) == "Recruit_0"] <- "Rec"
names(stock.by.area)[names(stock.by.area) == "Bio_all"] <- "TB"
names(stock.by.area)[names(stock.by.area) == "SpawnBio"] <- "SB"
stock.by.area <- stock.by.area[c("Area", "Yr", "Rec", "TB", "SB")]
row.names(stock.by.area) <- NULL

# Write tables
write.taf(f.aggregated, dir="output")
write.taf(f.annual, dir="output")
write.taf(f.season, dir="output")
write.taf(stock.by.area, dir="output")
