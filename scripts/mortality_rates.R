# ------------------------------------------------------------------------------
# HGEN 611 - Dataset Project
# Maggie Kohn
# ------------------------------------------------------------------------------
# this script wrangles the cleaned dataset to analyze the mortality rate of chronic diseases by location, race, and sex
# ------------------------------------------------------------------------------

# Install packages ----
# install.packages("tidyverse")
# install.packages("skimr")

# Load libraries ----
library(tidyverse)
library(skimr)

# Cardiovascular Mortality Rate
cardio_mortality <- clean_cdi |>
  filter(Topic == "Cardiovascular Disease",
         str_detect(Question, regex("mortality", ignore_case = TRUE))
  ) |>
  separate(Question,
           sep = "mortality",
           into = c("cause", "group_effected")
  ) |>
  select(-group_effected)

cardio_mortality
skim(cardio_mortality)
