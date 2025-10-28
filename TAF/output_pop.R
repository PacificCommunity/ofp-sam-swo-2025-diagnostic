# Extract population results, write CSV output tables

# Before: model.rds (model)
# After:  biomass.csv, f_age.csv, f_area.csv, natage.csv, summary.csv,
#         timeseries_area.csv, (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
annual <- model$annual_time_series[model$annual_time_series$Era == "TIME",]
batage <- model$batage[model$batage$Era == "TIME",]
derived <- model$derived_quants
dynamic <- model$Dynamic_Bzero[model$Dynamic_Bzero$Era == "TIME",]
m.age <- model$M_at_age
m.area <- model$M_by_area[model$M_by_area$Era == "TIME",]
natage <- model$natage[model$natage$Era == "TIME",]
timeseries <- model$timeseries[model$timeseries$Era == "TIME",]
z.age <- model$Z_at_age
z.area <- model$Z_by_area[model$Z_by_area$Era == "TIME",]

# Biomass
biomass <- batage[batage$Seas == 1,]
biomass <- biomass[biomass$"Beg/Mid" == "B",]
biomass <- biomass[biomass$BirthSeas == 1,]
biomass <- biomass[c("Area", "Sex", "Yr", grepv("[0-9]", names(biomass)))]
biomass <- wide2long(biomass, names=c("Age", "B"))

# F at age
m.age$Bio_Pattern <- NULL
z.age$Bio_Pattern <- NULL
m.age <- wide2long(m.age)
z.age <- wide2long(z.age)
m.age <- m.age[!is.na(m.age$Value),]
z.age <- z.age[!is.na(z.age$Value),]
f.age <- z.age
f.age$Value <- z.age$Value - m.age$Value
names(f.age)[names(f.age) == "Value"] <- "F"

# F by area
exclude <- c("Bio_Pattern", "BirthSeas", "Settlement", "Platoon", "Morph",
             "Time", "Beg/Mid", "Era")
m.area <- m.area[m.area$BirthSeas == 1,]
m.area <- m.area[!names(m.area) %in% exclude]
z.area <- z.area[z.area$BirthSeas == 1,]
z.area <- z.area[!names(z.area) %in% exclude]
m.area <- wide2long(m.area)
z.area <- wide2long(z.area)
m.area <- aggregate(Value~Area+Sex+Yr+Age, m.area, mean)
z.area <- aggregate(Value~Area+Sex+Yr+Age, z.area, mean)
f.area <- z.area
f.area$Value <- z.area$Value - m.area$Value
names(f.area)[names(f.area) == "Value"] <- "F"

# N at age
natage <- natage[natage$Seas == 1,]
natage <- natage[natage$"Beg/Mid" == "B",]
natage <- natage[natage$BirthSeas == 1,]
natage <- natage[c("Area", "Sex", "Yr", grepv("[0-9]", names(natage)))]
natage <- wide2long(natage, names=c("Age", "N"))

# Time series by area
timeseries.area <- timeseries[timeseries$Seas == 1,]
names(timeseries.area)[names(timeseries.area) == "Recruit_0"] <- "Rec"
names(timeseries.area)[names(timeseries.area) == "Bio_all"] <- "TB"
names(timeseries.area)[names(timeseries.area) == "SpawnBio"] <- "SB"
timeseries.area <- timeseries.area[c("Area", "Yr", "Rec", "TB", "SB")]

# Summary
Year <- annual$year
Rec <- annual$recruits
Catch <- annual$dead_catch_B_an
TB <- annual$Bio_all_an
SB <- annual$SSB
Fmort <- annual$"F=Z-M"
SB_SBmsy <- SB / derived$Value[derived$Label == "SSB_MSY"]
SB_SBF0 <- SB / dynamic$SSB_nofishing
F_Fmsy <- Fmort / derived$Value[derived$Label == "annF_MSY"]
summary <- data.frame(Year, Rec, Catch, TB, SB, F=Fmort, SB_SBmsy, SB_SBF0,
                      F_Fmsy)

# Write tables
write.taf(biomass, dir="output")
write.taf(f.age, dir="output")
write.taf(f.area, dir="output")
write.taf(natage, dir="output")
write.taf(timeseries.area, dir="output")
write.taf(summary, dir="output")
