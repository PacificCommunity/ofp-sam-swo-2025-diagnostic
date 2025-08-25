# Extract summary time series, write CSV output tables

# Before: model.rds (model)
# After:  summary.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")

# Calculate time series
timeseries <- model$timeseries
timeseries <- timeseries[timeseries$Era == "TIME",]
timeseries <- timeseries[timeseries$Seas == 1,]

timeseries$Era <- NULL
timeseries$Seas <- NULL
