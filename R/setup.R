# Load packages
suppressPackageStartupMessages({
  library(tidyverse)
  library(skimr)
  library("GGally")
})

# Set global options for consistency and readability
options(
  repos = c(CRAN = "https://cloud.r-project.org"),  # stable CRAN mirror
  width = 100,                                      # cleaner printing
  scipen = 999,                                     # avoid scientific notation
  dplyr.summarise.inform = FALSE,
  stringsAsFactors = FALSE
)

# Print a friendly start up message
cat("✅ Session setup complete\n")
