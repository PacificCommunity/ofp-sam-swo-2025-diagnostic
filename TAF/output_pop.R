# Extract population results, write CSV output tables

# Before: model.rds (model)
# After:  fatage.csv, natage.csv, stock_area.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
m.area <- model$M_by_area
natage <- model$natage[model$natage$Era == "TIME",]
timeseries <- model$timeseries[model$timeseries$Era == "TIME",]
z.area <- model$Z_by_area

# F at age
exclude <- c("Bio_Pattern", "BirthSeas", "Settlement", "Platoon", "Morph",
             "Time", "Beg/Mid", "Era")
m.area <- m.area[m.area$Era == "TIME" & m.area$BirthSeas == 1,]
m.area <- m.area[!names(m.area) %in% exclude]
z.area <- z.area[z.area$Era == "TIME" & z.area$BirthSeas == 1,]
z.area <- z.area[!names(z.area) %in% exclude]
m.area <- wide2long(m.area)
z.area <- wide2long(z.area)
m.area <- aggregate(Value~Area+Sex+Yr+Age, m.area, mean)
z.area <- aggregate(Value~Area+Sex+Yr+Age, z.area, mean)
fatage <- z.area
fatage$Value <- z.area$Value - m.area$Value
names(fatage)[names(fatage) == "Value"] <- "F"

# N at age
natage <- natage[natage$Seas == 1,]
natage <- natage[natage$"Beg/Mid" == "B",]
natage <- natage[natage$BirthSeas == 1,]
natage <- natage[c("Area", "Sex", "Yr", grepv("[0-9]", names(natage)))]
natage <- wide2long(natage, names=c("Age", "N"))

# Stock by area
stock.area <- timeseries[timeseries$Seas == 1,]
names(stock.area)[names(stock.area) == "Recruit_0"] <- "Rec"
names(stock.area)[names(stock.area) == "Bio_all"] <- "TB"
names(stock.area)[names(stock.area) == "SpawnBio"] <- "SB"
stock.area <- stock.area[c("Area", "Yr", "Rec", "TB", "SB")]
row.names(stock.area) <- NULL

# Write tables
write.taf(fatage, dir="output")
write.taf(natage, dir="output")
write.taf(stock.area, dir="output")
