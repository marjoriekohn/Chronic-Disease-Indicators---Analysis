# ------------------------------------------------------------------------------
# HGEN 611 - Dataset Project
# Maggie Kohn
# ------------------------------------------------------------------------------
# this script cleans the dataset by removing empty and repetitive columns. For example, between Location and LocationAbbr columns we kept the abbreviated column.
# ------------------------------------------------------------------------------

# Install packages ----
# install.packages("tidyverse")
# install.packages("skimr")

# Load libraries ----
library(tidyverse)
library(skimr)

clean_cdi <- chronic_disease_indicators |>
  filter(is.na(DataValueFootnote),
         YearStart == YearEnd) |>
  select(YearStart,
         LocationAbbr,
         Topic,
         Question,
         DataValueUnit,
         DataValueType,
         DataValue,
         Stratification1,
         StratificationCategory1,
         -where(is.logical)
         )

skim(clean_cdi)



