library(TAF)
library(gdata, w=F)
library(r4ss)
library(fishgrowth)

model <- readRDS("model/model.rds")

biology <- model$biology; row.names(biology) <- NULL
endgrowth <- model$endgrowth
Growth_Parameters <- model$Growth_Parameters
natage <- model$natage[model$natage$Era == "TIME",]
natage <- natage[natage$"Beg/Mid" == "B",]
natage <- natage[natage$Sex == 1,]
natage <- natage[natage$Area == 1,]
row.names(natage) <- NULL
Natural_Mortality <- model$Natural_Mortality; row.names(Natural_Mortality) <- NULL
parameters <- model$parameters

x <- natage

x <- parameters[c("Label", "Value", "Phase")]
row.names(x) <- NULL
LL1f <- x$Value[x$Label == "L_at_Amin_Fem_GP_1"]
LL2f <- x$Value[x$Label == "L_at_Amax_Fem_GP_1"]

L_at_Amin_Fem_GP_1 <- parameters$Value[parameters$Label == "L_at_Amin_Fem_GP_1"]
L_at_Amax_Fem_GP_1 <- parameters$Value[parameters$Label == "L_at_Amax_Fem_GP_1"]
VonBert_K_Fem_GP_1 <- parameters$Value[parameters$Label == "VonBert_K_Fem_GP_1"]

L_at_Amin_Mal_GP_1 <- parameters$Value[parameters$Label == "L_at_Amin_Mal_GP_1"]
L_at_Amax_Mal_GP_1 <- parameters$Value[parameters$Label == "L_at_Amax_Mal_GP_1"]

L1f <- parameters$Value[parameters$Label == "L_at_Amin_Fem_GP_1"]
L2f <- parameters$Value[parameters$Label == "L_at_Amax_Fem_GP_1"]
kf <- parameters$Value[parameters$Label == "VonBert_K_Fem_GP_1"]

L1m <- L1f * exp(parameters$Value[parameters$Label == "L_at_Amin_Mal_GP_1"])
L2m <- L2f * exp(parameters$Value[parameters$Label == "L_at_Amax_Mal_GP_1"])
km <- kf * exp(parameters$Value[parameters$Label == "VonBert_K_Mal_GP_1"])
kkm <- parameters$Value[parameters$Label == "VonBert_K_Mal_GP_1"]

# L1 <- L_at_Amin_Fem_GP_1
# L2 <- L_at_Amax_Fem_GP_1
# k <- VonBert_K_Fem_GP_1
t1 <- Growth_Parameters$A1[1]
t2 <- Growth_Parameters$A2[1]

t <- seq(0, 19, 0.25)

Lf <- vonbert_curve(t, L1f, L2f, kf, t1, t2)

################################################################################

y <- endgrowth
y <- y[y$Sex == 1,]
y$Bio_Pattern <- NULL
y$Platoon <- NULL
row.names(y) <- NULL

z <- y$Len_Mid
z[z > 54 & z < 55]

a1 <- y$int_Age
a2 <- y$Real_Age
a3 <- y$Age_Beg
a4 <- y$Age_Mid

len1 <- y$Len_Beg
len2 <- y$Len_Mid

hat1 <- vonbert_curve(a1, L1f, L2f, kf, t1, t2)
hat2 <- vonbert_curve(a2, L1f, L2f, kf, t1, t2)
hat3 <- vonbert_curve(a3, L1f, L2f, kf, t1, t2)
hat4 <- vonbert_curve(a4, L1f, L2f, kf, t1, t2)

par(mfrow=c(2,4))
plot(hat1, len1)
plot(hat2, len1)
plot(hat3, len1)
plot(hat4, len1)
plot(hat1, len2)
plot(hat2, len2)
plot(hat3, len2)
plot(hat4, len2)

z <- y[c("Seas", "Morph", "Sex", "Settlement", "int_Age", "Real_Age", "Age_Beg", "Age_Mid", "Len_Beg")]

par(mfrow=c(2,2))

plot(Len_Beg~Age_Mid, z)
points(z$Age_Beg, vonbert_curve(z$Age_Beg, L1f, L2f, kf, t1, t2), pch=16, col=2)

plot(Len_Beg~Age_Beg, z)
points(z$Age_Beg, vonbert_curve(z$Age_Beg, L1f, L2f, kf, t1, t2), pch=16, col=2)

plot(Len_Beg~Real_Age, z)
points(z$Real_Age, vonbert_curve(z$Real_Age, L1f, L2f, kf, t1, t2), pch=16, col=2)

plot(Len_Beg~int_Age, z)
points(z$int_Age, vonbert_curve(z$int_Age, L1f, L2f, kf, t1, t2), pch=16, col=2)

################################################################################

z <- y[c("Seas", "Morph", "Sex", "Settlement", "Real_Age", "Len_Beg")]

plot(Len_Beg~Real_Age, endgrowth)
points(z$Real_Age, vonbert_curve(z$Real_Age, L1f, L2f, kf, t1, t2), pch=16, col=2)
points(z$Real_Age, vonbert_curve(z$Real_Age, L1m, L2m, km, t1, t2), pch=16, col=3)

