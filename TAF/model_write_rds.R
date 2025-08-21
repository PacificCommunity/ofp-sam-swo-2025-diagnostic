# Import results into r4ss, save rds file

# Before: CompReport.sso, covar.sso, Forecast-report.sso, Report.sso,
#         warning.sso, wtatage.ss_new (model)
# After:  model.rds (model)

library(r4ss)

model <- SS_output("model")
saveRDS(model, "model/model.rds")
