# Extract fishing mortality at age, write CSV output tables

# Before: model.rds (model)
# After:  fatage.csv (output)

library(TAF)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
m.area <- model$M_by_area
z.area <- model$Z_by_area

# Select rows and columns
exclude <- c("Bio_Pattern", "BirthSeas", "Settlement", "Platoon", "Morph",
             "Time", "Beg/Mid", "Era")
m.area <- m.area[m.area$Era == "TIME" & m.area$BirthSeas == 1,]
m.area <- m.area[!names(m.area) %in% exclude]
z.area <- z.area[z.area$Era == "TIME" & z.area$BirthSeas == 1,]
z.area <- z.area[!names(z.area) %in% exclude]

# Average across seasons
m.area <- wide2long(m.area)
z.area <- wide2long(z.area)
m.area <- aggregate(Value~Area+Sex+Yr+Age, m.area, mean)
z.area <- aggregate(Value~Area+Sex+Yr+Age, z.area, mean)

# Calculate F
fatage <- z.area
fatage$Value <- z.area$Value - m.area$Value
names(fatage)[names(fatage) == "Value"] <- "F"

# Write table
write.taf(fatage, dir="output")
