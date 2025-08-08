# Extract results of interest, write CSV output tables

# Before: results.rds (model)
# After:  kobe.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
derived <- model$derived_quants
dynamic <- model$Dynamic_Bzero[model$Dynamic_Bzero$Era == "TIME",]

# Extract SB_SBmsy and F_Fmsy
SB_SBmsy <- derived$Value[grep("Bratio_[12]", derived$Label)]
SB_SBmsy <- c(SB_SBmsy[1], SB_SBmsy)  # similar in year 1 and year 2
F_Fmsy <- derived$Value[grep("F_[12]", derived$Label)]
Year <- as.integer(sub("F_", "", grepv("F_[12]", derived$Label)))

# Extract SB_SBF0
SB_SBF0 <- dynamic$SSB / dynamic$SSB_nofishing

# Construct kobe and majuro data frames
kobe <- data.frame(Year, SB_SBmsy, F_Fmsy)
majuro <- data.frame(Year, SB_SBF0, F_Fmsy)

# Write table
write.taf(kobe, dir="output")
write.taf(majuro, dir="output")
