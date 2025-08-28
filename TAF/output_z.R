# Extract F and stock by area, write CSV output tables

# Before: model.rds (model)
# After:

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
m <- model$M_at_age
m.area <- model$M_by_area
z <- model$Z_at_age
z.area <- model$Z_by_area

# Calculate F
