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

# Construct summary table
summary <- data.frame(Year, SB, F=Fmort, SB_SBmsy, SB_SBF0, F_Fmsy)

# Write table
write.taf(summary, dir="output")
