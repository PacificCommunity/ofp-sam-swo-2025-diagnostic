# Extract results of interest, write CSV output tables

# Before: results.rds (model)
# After:  kobe.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
derived <- model$derived_quants

# Extract SB_SBmsy and F_Fmsy
SB_SBmsy <- derived$Value[grep("Bratio_[12]", derived$Label)]
SB_SBmsy <- c(SB_SBmsy[1], SB_SBmsy)  # similar in year 1 and year 2
F_Fmsy <- derived$Value[grep("F_[12]", derived$Label)]
Year <- as.integer(sub("F_", "", grepv("F_[12]", derived$Label)))

# Construct kobe data frame
kobe <- data.frame(Year, SB_SBmsy, F_Fmsy)

# Write table
write.taf(kobe, dir="output")
