# Produce plots and tables for report

# Before: biology.csv, summary.csv (output)
# After:  biology.csv, summary.csv (report)

library(TAF)

mkdir("report")

# Read tables
biology <- read.taf("output/biology.csv")
stock.area <- read.taf("output/stock_area.csv")
summary <- read.taf("output/summary.csv")

# Plot stock by area
taf.png("stock_area")
plot(SB~Yr, stock.area, ylim=c(0,50e3), type="n", xlab="Year",
     ylab="Spawning biomass (t)", bty="n")
abline(h=seq(0, 50e3, 10e3), col="gray", lty=3)
box()
lines(SB~Yr, stock.area, subset=Area==1, lwd=3, col=5)
lines(SB~Yr, stock.area, subset=Area==2, lwd=3, col=6)
legend("bottomright", c("Area 1","Area 2"), lwd=3, col=c(5,6), bty="n",
       inset=0.04, y.intersp=1.25)
dev.off()

# Format tables
biology <- rnd(biology, c("M", "Len", "Wt", "Mat"), c(3, 1, 1, 3))
summary <- rnd(summary, c("Rec", "Catch", "TB", "SB"))
summary <- rnd(summary, c("F", "SB_SBmsy", "SB_SBF0", "F_Fmsy"), 2)

# Write tables
write.taf(biology, dir="report")
write.taf(summary, dir="report")
