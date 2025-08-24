# Extract biology results of interest, write CSV output tables

# Before: model.rds (model)
# After:  biology.csv (output)

library(TAF)
library(r4ss)
library(fishgrowth)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
endgrowth <- model$endgrowth
Growth_Parameters <- model$Growth_Parameters
Natural_Mortality <- model$Natural_Mortality
parameters <- model$parameters

# Prepare output data frame
Age <- 0:model$accuage

# Calculate length at age
L1f <- parameters$Value[parameters$Label == "L_at_Amin_Fem_GP_1"]
L2f <- parameters$Value[parameters$Label == "L_at_Amax_Fem_GP_1"]
kf <- parameters$Value[parameters$Label == "VonBert_K_Fem_GP_1"]
L1m <- L1f * exp(parameters$Value[parameters$Label == "L_at_Amin_Mal_GP_1"])
L2m <- L2f * exp(parameters$Value[parameters$Label == "L_at_Amax_Mal_GP_1"])
km <- kf * exp(parameters$Value[parameters$Label == "VonBert_K_Mal_GP_1"])
t1 <- Growth_Parameters$A1[1]
t2 <- Growth_Parameters$A2[1]
Lf <- vonbert_curve(Age, L1f, L2f, kf, t1, t2)
Lm <- vonbert_curve(Age, L1m, L2m, km, t1, t2)
# plot(Len_Beg~Real_Age, endgrowth)
# matlines(out[1], out[-1], col=c(2,4), lty=1, lwd=5)

# Calculate weight at age
af <- parameters$Value[parameters$Label == "Wtlen_1_Fem_GP_1"]
bf <- parameters$Value[parameters$Label == "Wtlen_2_Fem_GP_1"]
am <- parameters$Value[parameters$Label == "Wtlen_1_Mal_GP_1"]
bm <- parameters$Value[parameters$Label == "Wtlen_2_Mal_GP_1"]
Wf <- af * Lf^bf
Wm <- am * Lm^bm

# Calculate natural mortality
M <- subset(Natural_Mortality, Area==1 & BirthSeas==1 & Seas==1 & Era=="INIT")
Mf <- unname(unlist(M[M$Sex == 1, grepv("^[0-9]+$", names(M))]))
Mm <- unname(unlist(M[M$Sex == 2, grepv("^[0-9]+$", names(M))]))

# Construct table
biology <- data.frame(Age, Lf, Lm, Wf, Wm, Mf, Mm)

# Write table
write.taf(biology, dir="output")

################################################################################

nrow(Natural_Mortality <- model$Natural_Mortality)                              # 4800
nrow(Natural_Mortality <- Natural_Mortality[Natural_Mortality$Era == "TIME",])  # 4608
nrow(Natural_Mortality <- Natural_Mortality[Natural_Mortality$Area == 1,])      # 2304
nrow(Natural_Mortality <- Natural_Mortality[Natural_Mortality$BirthSeas == 1,]) #  576
nrow(Natural_Mortality <- Natural_Mortality[Natural_Mortality$Sex == 1,])       #  288
nrow(Natural_Mortality <- Natural_Mortality[Natural_Mortality$Seas == 1,])      #  72
x <- Natural_Mortality
row.names(x) <- NULL
ddim(x[1:14])
x[x$Yr == 2000,]
x[x$Yr == 2010,]
parameters$Value[parameters$Label == "NatM_Lorenzen_Fem_GP_1"]
