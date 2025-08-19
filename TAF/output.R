# Extract results of interest, write CSV output tables

# Before: model.rds (model)
# After:  kobe.csv, majuro.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
annual <- model$annual_time_series
derived <- model$derived_quants
dynamic <- model$Dynamic_Bzero[model$Dynamic_Bzero$Era == "TIME",]

# Extract SB_SBmsy and F_Fmsy
Year <- annual$year
SB <- annual$SSB
SBmsy <- derived$Value[derived$Label == "SSB_MSY"]
SB_SBmsy <- SB / SBmsy
Fmort <- annual$"F=Z-M"
Fmsy <- derived$Value[derived$Label == "annF_MSY"]
F_Fmsy <- Fmort / Fmsy

# Extract SB_SBF0
SB_SBF0 <- dynamic$SSB / dynamic$SSB_nofishing

# Construct kobe and majuro data frames
summary <- data.frame(Year, SB, F=Fmort, SB_SBmsy, F_Fmsy, SB_SBF0)
kobe <- data.frame(Year, SB_SBmsy, F_Fmsy)
majuro <- data.frame(Year, SB_SBF0, F_Fmsy)

# Write table
write.taf(kobe, dir="output")
write.taf(majuro, dir="output")

################################################################################

catch <- model$catch
catch <- catch[catch$Yr >= 1952,]




catch$NCS <- substring(catch$Fleet_Name, nchar(catch$Fleet_Name))
catch$NCS <- ordered(catch$NCS, levels=c("N", "C", "S"))
catch.ncs <- aggregate(dead_bio~Yr+NCS, catch, sum)
names(catch.ncs) <- c("Year", "NCS", "Catch")
catch.ncs.xtab <- xtab2taf(xtabs(Catch~Year+NCS, catch.ncs))
areaplot(Catch~Year+NCS, catch.ncs, legend=TRUE,
         args.legend=list(x="topleft", legend=c("North" ,"Central", "South")))



north <- aggregate(dead_bio~Yr, catch, sum, subset=grepl("N$", Fleet_Name))
names(north) <- c("Year", "North")
total <- aggregate(dead_bio~Yr, catch, sum)
names(total) <- c("Year", "Total")
tab <- merge(total, north)
tab$Nprop <- tab$North / tab$Total

library(areaplot)
areaplot(tab[c("Year", "North", "")])
write.taf(tab, "output/swo_catch_north.csv")
