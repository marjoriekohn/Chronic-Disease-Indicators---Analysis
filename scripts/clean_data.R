################################################################################
# Author: Maggie Kohn
# Project: Chronic Disease Indicators Analysis
# Description: This script cleans the raw data.
################################################################################


################################################################################
# load libraries
################################################################################
library(readr)
library(tidyverse)
library(skimr)


################################################################################
# import raw data for cleaning
################################################################################
raw_cdi <- read_csv(file = "data/raw/chronic_disease_indicators.csv")



clean_cdi <- raw_cdi |>

  ##############################################################################
  # 1. removing rows that are not of interest to this analysis
  ##############################################################################
  filter(
  ############################################
  # 1.1 remove race/ethnicity stratified rows
  ############################################
  StratificationCategory1 != "Race/Ethnicity",
  ############################################
  # 1.2 remove virgin islands (majority missing)
  ############################################
  LocationAbbr != "VI",
  ############################################
  # 1.3 remove rows where year are a range
  ############################################
  YearStart == YearEnd
  ) |>

  ##############################################################################
  # 2. cleaning up values that are inconsistent or have encoding issues
  ##############################################################################
  mutate(
    ############################################################################
    # 2.1 clarify "per 100,000" as "cases per 100,000" to match the other units
    ############################################################################
    DataValueUnit = if_else(
      DataValueUnit == "per 100,000",         # if unit is "per 100,000"
      "cases per 100,000",                    # replace with "case per 100,000"
      DataValueUnit                           # otherwise, leave it as is
    ),
    ############################################################################
    # 2.2 fix encoding issue in Question column
    ############################################################################
    Question = str_replace_all(
      Question,                               # replace bad dash
      "â€“",
      "-"
    ),
    ############################################################################
    # 2.3 add column for year
    ############################################################################
    Year = YearStart
  ) |>

  ##############################################################################
  # 3. remove columns that are not needed for analysis
  ##############################################################################
  select(
    -where(is.logical),                       # logical variables are all empty
    -YearStart,                               # replaced by new Year column
    -YearEnd,                                 # replaced by new Year column
    -DataValueAlt                             # holds the same info as DataValue
  )

##############################################################################
# skim clean data
##############################################################################
skim(clean_cdi)

##############################################################################
# save cleaned dataset as csv
##############################################################################
write_csv(clean_cdi, "data/processed/clean_cdi.csv")
