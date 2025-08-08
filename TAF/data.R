# Prepare data, write CSV data tables

# Before: ss3.zip (boot)
# After:

library(TAF)
library(r4ss)

mkdir("data")

# Read model results
taf.unzip("boot/data/ss3.zip", exdir="boot/data/ss3")
model <- if(file.exists("data/model.rds"))
           readRDS("data/model.rds") else SS_output("boot/data/ss3")
annual <- model$annual_time_series
derived <- model$derived_quants
dynamic <- model$Dynamic_Bzero[model$Dynamic_Bzero$Era == "TIME",]

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

# Correlation
# r4ss: derived_quants has 383 rows
# r4ss: CoVar has 104653 rows
# covar.sso: 104653 rows
# derived_posteriors.sso: 385 columns (including Iter and Objective_function)
# Reports.sso: Bratio_2023 2.15016 0.330943 and F_2022 0.316533 0.0920849
# ss_summary.sso: Bratio_2023 2.15016 0.330943 and F_2022 0.316533 0.0920849
# ss3.par: model has 74 parameters
# ss3.std: 457 rows of standard errors
# ss3.cor: 457 rows of correlations

# Estimate                B/Bmsy[2023]  F/Fmsy[2022]
# derived_quants          2.15016       0.316533
# derived_posteriors.sso  2.15016       0.316533
# ss_summary.sso          2.15016       0.316533
# ss3.std                 2.1462        0.31661
# ss3.cor                 2.1462        0.31661

# Standard error          B/Bmsy[2023]  F/Fmsy[2022]
# derived_quants          0.330943      0.0920849
# ss_summary.sso          0.330943      0.0920849
# ss3.std                 0.33094       0.092085
# ss3.cor                 0.33094       0.092085

# Location                B/Bmsy[2023]  F/Fmsy[2022]  Total
# derived_quants          363           291           383
# ss3.cor                 437           365           457

# Dependence              Correlation  Covariance
# CoVar                   -0.991381    -
# ss3.cor                 -0.9914

covar <- model$CoVar
covar[covar$label.i == "Bratio_2023" & covar$label.j == "F_2022",]

ss3.cor <- read.table("boot/data/ss3/ss3.cor", skip=1, fill=TRUE, header=TRUE)
rho <- as.matrix(ss3.cor[-(1:4)])
dimnames(rho) <- list(ss3.cor$name, ss3.cor$name)
rho[437, 365]

straight <- read.table("boot/data/ss3/covar.sso", skip=6, header=TRUE)
straight[straight$label.i == "Bratio_2023" & straight$label.j == "F_2022",]

################################################################################

# Save model results
saveRDS(model, "data/model.rds")

# Tabulate estimates, standard errors, and correlation
# Quantity        Est        SE          Cor
# SBrecent_SBmsy  2.21278    0.3418348   -0.991381
# Frecent_Fmsy    0.3185042  0.09285005  -0.991381
