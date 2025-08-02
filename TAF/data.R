# Prepare data, write CSV data tables

# Before: ss3.zip (boot)
# After:

library(TAF)
library(r4ss)

mkdir("data")

# Read model results
taf.unzip("boot/data/ss3.zip", exdir="boot/data/ss3")
model <- SS_output("boot/data/ss3")
annual <- model$annual_time_series
derived <- model$derived_quants
dynamic <- model$Dynamic_Bzero

# Extract Frecent/Fmsy
Ft <- setNames(annual$"F=Z-M", annual$year)
Frecent <- mean(annual$"F=Z-M"[annual$year %in% 2019:2022])
Fmsy <- derived$Value[derived$Label == "annF_MSY"]
Frecent_Fmsy <- mean(derived$Value[derived$Label %in% paste0("F_", 2019:2022)])
sigma_Frecent_Fmsy <- mean(derived$StdDev[derived$Label %in%
                                          paste0("F_", 2019:2022)])

# Extract SBrecent/SBmsy
SBt <- setNames(annual$SSB, annual$year)
SBrecent <- mean(derived$Value[derived$Label %in% paste0("SSB_", 2020:2023)])
SBmsy <- derived$Value[derived$Label == "SSB_MSY"]
SBrecent_SBmsy <- mean(derived$Value[derived$Label %in%
                                     paste0("Bratio_", 2020:2023)])
sigma_SBrecent_SBmsy <- mean(derived$StdDev[derived$Label %in%
                                            paste0("Bratio_", 2020:2023)])
