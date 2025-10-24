# ------------------------------------------------------------------------------
# HGEN 611 - Dataset Project
# Maggie Kohn
# ------------------------------------------------------------------------------
# this script imports and loads the dataset
# ------------------------------------------------------------------------------

# Install packages ----
# install.packages("tidyverse")
# install.packages("skimr")

# Load libraries ----
library(tidyverse)
library(skimr)

# Raw data source ----
# https://data.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators/hksd-2xuw/about_data

# Load raw data ----
chronic_disease_indicators <- read_csv("data/U.S._Chronic_Disease_Indicators_20251008.csv")
skim(chronic_disease_indicators)

