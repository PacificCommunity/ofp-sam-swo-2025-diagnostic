# Run analysis, write model results

# Before: ss3, ss3.exe (boot/software/3.30.23.1),
#         forecast.ss, starter.ss, swo2025.ctl, swo2025.dat (boot/data/ss3)
# After:

library(TAF)

mkdir("model")

# Get model executable
exefile <- if(os.linux()) "ss3" else "ss3.exe"
cp(file.path("boot/software/ss3", exefile), "model")

# Get model input files
cp("boot/data/ss3/starter.ss", "model")
cp("boot/data/ss3/forecast.ss", "model")
cp("boot/data/ss3/swo2025.ctl", "model")
cp("boot/data/ss3/swo2025.dat", "model")

# Run model
setwd("model")
system("./ss3 -cbs 2000000000 -gbs 5000000000 -maxfn 200")
setwd("..")
