# Extract reference points, write CSV output tables

# Before: model.rds (model)
# After:  refpts.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
annual <- model$annual
derived <- model$derived_quants
dynamic <- model$Dynamic_Bzero

# Calculate reference points
Clatest <- annual$dead_catch_B_an[annual$year == 2023]
Flatest <- annual$"F=Z-M"[annual$year == 2022]
Fmsy <- derived$Value[derived$Label == "annF_MSY"]
Frecent <- mean(annual$"F=Z-M"[annual$year %in% 2019:2022])
MSY <- derived$Value[derived$Label == "Dead_Catch_MSY"]
SB0 <- derived$Value[derived$Label == "SSB_Virgin"]
SBF0 <- mean(dynamic$SSB_nofishing[dynamic$Yr %in% 2013:2022])
SBlatest <- derived$Value[derived$Label == "SSB_2023"]
SBmsy <- derived$Value[derived$Label == "SSB_MSY"]
SBrecent <- mean(derived$Value[derived$Label %in% paste0("SSB_", 2020:2023)])
TBlatest <- annual$Bio_all_an[annual$year == 2023]
TBrecent <- mean(annual$Bio_all_an[annual$year %in% 2020:2023])
Flatest_Fmsy <- Flatest / Fmsy
Frecent_Fmsy <- Frecent / Fmsy
SBlatest_SB0 <- SBlatest / SB0
SBlatest_SBF0 <- SBlatest / SBF0
SBlatest_SBmsy <- SBlatest / SBmsy
SBrecent_SB0 <- SBrecent / SB0
SBrecent_SBF0 <- SBrecent / SBF0
SBrecent_SBmsy <- SBrecent / SBmsy

# Construct reference point table
refpts <- data.frame(Clatest, Flatest, Fmsy, Frecent, MSY, SB0, SBF0, SBlatest,
                     SBmsy, SBrecent, TBlatest, TBrecent, Flatest_Fmsy,
                     Frecent_Fmsy, SBlatest_SB0, SBlatest_SBF0, SBlatest_SBmsy,
                     SBrecent_SB0, SBrecent_SBF0, SBrecent_SBmsy)

# Write table
write.taf(refpts, dir="output")
