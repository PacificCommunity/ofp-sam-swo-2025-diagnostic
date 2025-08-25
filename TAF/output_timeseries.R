# Extract F and stock by area, write CSV output tables

# Before: model.rds (model)
# After:  f_annual.csv, f_season.csv, stock_by_area.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
timeseries <- model$timeseries[model$timeseries$Era == "TIME",]

# Calculate time series
stock.by.area <- timeseries[timeseries$Seas == 1,]
names(stock.by.area)[names(stock.by.area) == "Recruit_0"] <- "Rec"
names(stock.by.area)[names(stock.by.area) == "Bio_all"] <- "TB"
names(stock.by.area)[names(stock.by.area) == "SpawnBio"] <- "SB"
stock.by.area <- stock.by.area[c("Area", "Yr", "Rec", "TB", "SB")]
row.names(stock.by.area) <- NULL

# Calculate F by season
f.season <- timeseries
cols <- c("Area", "Yr", "Seas")
f.season <- f.season[c(cols, grepv("F:_", names(f.season)))]
names(f.season) <- sub("F:_", "", names(f.season))
rowlab <- apply(f.season[c("Area", "Yr", "Seas")], 1, paste, collapse = "|")
f.season <- f.season[!names(f.season) %in% cols]
row.names(f.season) <- rowlab
f.season <- xtab2long(f.season, c("AYS", "Age", "F"))
right <- f.season[c("Age", "F")]
left <- read.table(text=f.season$AYS, sep = "|", col.names=cols)
f.season <- cbind(left, right)

# Calculate F by year
f.annual <- aggregate(F~Area+Yr+Age, f.season, sum)
f.annual <- f.annual[order(f.annual$Area, f.annual$Age, f.annual$Yr),]
row.names(f.annual) <- NULL

# Write tables
write.taf(f.annual, dir="output")
write.taf(f.season, dir="output")
write.taf(stock.by.area, dir="output")
