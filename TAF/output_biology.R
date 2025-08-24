# Extract biology results of interest, write CSV output tables

# Before: model.rds (model)
# After:  biology.csv (output)

library(TAF)
library(r4ss)
library(fishgrowth)

mkdir("output")

# Read model results
model <- readRDS("model/model.rds")
biology <- model$biology
endgrowth <- model$endgrowth
Growth_Parameters <- model$Growth_Parameters
Natural_Mortality <- model$Natural_Mortality
parameters <- model$parameters

# Prepare output data frame
out <- data.frame(Age=seq(0, 19, 0.25))

# Calculate length at age
L1f <- parameters$Value[parameters$Label == "L_at_Amin_Fem_GP_1"]
L2f <- parameters$Value[parameters$Label == "L_at_Amax_Fem_GP_1"]
kf <- parameters$Value[parameters$Label == "VonBert_K_Fem_GP_1"]
L1m <- L1f * exp(parameters$Value[parameters$Label == "L_at_Amin_Mal_GP_1"])
L2m <- L2f * exp(parameters$Value[parameters$Label == "L_at_Amax_Mal_GP_1"])
km <- kf * exp(parameters$Value[parameters$Label == "VonBert_K_Mal_GP_1"])
t1 <- Growth_Parameters$A1[1]
t2 <- Growth_Parameters$A2[1]
out$Lf <- vonbert_curve(out$Age, L1f, L2f, kf, t1, t2)
out$Lm <- vonbert_curve(out$Age, L1m, L2m, km, t1, t2)
# plot(Len_Beg~Real_Age, endgrowth)
# matlines(out[1], out[-1], col=c(2,4), lty=1, lwd=5)

# Calculate weight at age
af <- parameters$Value[parameters$Label == "Wtlen_1_Fem_GP_1"]
bf <- parameters$Value[parameters$Label == "Wtlen_2_Fem_GP_1"]
am <- parameters$Value[parameters$Label == "Wtlen_1_Mal_GP_1"]
bm <- parameters$Value[parameters$Label == "Wtlen_2_Mal_GP_1"]
out$Wf <- af * out$Lf^bf
out$Wm <- am * out$Lm^bm

# Write table
write.taf(out, "output/biology.csv")
