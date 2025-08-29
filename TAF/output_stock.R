# Extract F and stock by area, write CSV output tables

# Before: model.rds (model)
# After:  stock_area.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
timeseries <- model$timeseries[model$timeseries$Era == "TIME",]

# Calculate stock by area
stock.area <- timeseries[timeseries$Seas == 1,]
names(stock.area)[names(stock.area) == "Recruit_0"] <- "Rec"
names(stock.area)[names(stock.area) == "Bio_all"] <- "TB"
names(stock.area)[names(stock.area) == "SpawnBio"] <- "SB"
stock.area <- stock.area[c("Area", "Yr", "Rec", "TB", "SB")]
row.names(stock.area) <- NULL

# Write tables
write.taf(stock.area, dir="output")
