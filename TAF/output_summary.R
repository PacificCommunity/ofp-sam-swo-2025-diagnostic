# Extract summary time series, write CSV output tables

# Before: model.rds (model)
# After:  summary.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
annual <- model$annual_time_series
derived <- model$derived_quants
dynamic <- model$Dynamic_Bzero[model$Dynamic_Bzero$Era == "TIME",]

# Extract annual time series
Year <- annual$year
Rec <- annual$recruits
Catch <- annual$dead_catch_B_an
TB <- annual$Bio_all_an
SB <- annual$SSB
Fmort <- annual$"F=Z-M"

# Extract reference point time series
SB_SBmsy <- SB / derived$Value[derived$Label == "SSB_MSY"]
SB_SBF0 <- SB / dynamic$SSB_nofishing
F_Fmsy <- Fmort / derived$Value[derived$Label == "annF_MSY"]

# Construct summary table
summary <- data.frame(Year, Rec, Catch, TB, SB, F=Fmort, SB_SBmsy, SB_SBF0,
                      F_Fmsy)

# Write table
write.taf(summary, dir="output")
