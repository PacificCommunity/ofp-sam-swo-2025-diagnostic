# SWO 2025 Diagnostic Model

Download SWO 2025 assessment report:

- **Stock assessment of swordfish in the southwest Pacific Ocean: 2025**\
  **[WCPFC-SC21-2025/SA-WP-05](https://meetings.wcpfc.int/node/26681)**

Download SWO 2025 diagnostic model:

- Clone the **[swo-2025-diagnostic](https://github.com/PacificCommunity/ofp-sam-swo-2025-diagnostic)** repository or download as **[main.zip](https://github.com/PacificCommunity/ofp-sam-swo-2025-diagnostic/archive/refs/heads/main.zip)** file

Download SWO 2025 grid results:

- Clone the **[swo-2025-grid](https://github.com/PacificCommunity/ofp-sam-swo-2025-grid)** repository or download as **[main.zip](https://github.com/PacificCommunity/ofp-sam-swo-2025-grid/archive/refs/heads/main.zip)** file

## Reference model

In SPC assessment jargon, the *diagnostic model* is the reference model that is the basis of several sections and figures in the stock assessment report.

The diagnostic model is also the entry point when configuring and running the grid of ensemble models that is the basis of scientific advice. When the grid includes specific factor levels (for steepness, likelihood weights, etc.) the diagnostic model has intermediate levels, while other grid members explore higher and lower levels.

Finally, the diagnostic model is also the starting point for the SWO 2029 stock assessment model development. One purpose of this repository is to give the stock assessor a good starting point that is organized and documented.

## Explore data, model settings, and results

The `ss3.zip` archive includes all the Stock Synthesis (SS3) input files, model settings, and output files. The `ss3_ffmsy.zip` archive includes a similar diagnostic model run, except it is configured to report the uncertainty about F/Fmsy instead of F.

The **TAF** folder extracts the data and results from SS3 format to CSV format that can be examined using Excel, R, or other statistical software. [TAF](https://cran.r-project.org/package=TAF) is a standard reproducible format for stock assessments that is practical for making the SS3 **[data](TAF/data)** and **[output](TAF/output)** tables available in a format that is easy to examine. The **[report](TAF/report)** folder contains formatted tables and example plots.

## Run the assessment model

The SWO 2025 model takes around 3 hours to run. Executables are provided for Windows and Linux.

### Run in TAF format

Anyone can run the assessment analysis in TAF format. First install TAF and r4ss if they are not already installed.

```
install.packages("TAF")
install_github("r4ss/r4ss")
```

The full assessment model can be run as a TAF analysis. Start R, make sure the TAF folder is the working directory, and then run:

```
library(TAF)
taf.boot()
source.taf("data.R")
source.taf("model_full.R")
source.taf("model_rds.R")
source.taf("output.R")
source.taf("report.R")
```

A shortcut script is provided, to run the TAF analysis in 1 minute rather than 3 hours:

```
library(TAF)
taf.boot()
source.taf("data.R")
source.taf("model.R")
source.taf("output.R")
source.taf("report.R")
```

The TAF shortcut analysis runs an all platforms: Windows, Linux, and macOS. It extracts the data and output from the SS3 files and makes them available as CSV files that can be examined and analyzed further.
