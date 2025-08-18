# Run analysis, write model results

# After:  ss3 (boot/data)
# After:  CompReport.sso, covar.sso, Forecast-report.sso, Report.sso,
#         warning.sso, wtatage.ss_new (model)

library(TAF)

mkdir("model")

# Model results, based on args(SS_output)
cp("boot/data/ss3/Report.sso", "model")
cp("boot/data/ss3/CompReport.sso", "model")
cp("boot/data/ss3/covar.sso", "model")
cp("boot/data/ss3/Forecast-report.sso", "model")
cp("boot/data/ss3/wtatage.ss_new", "model")
cp("boot/data/ss3/warning.sso", "model")
