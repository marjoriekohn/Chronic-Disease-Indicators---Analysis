# ─────────────────────────────────────────────────────────────────────────────
# HGEN 611 – Dataset Project
# Author: Maggie Kohn
# Date: 2025-10-31
# Description: Inspection and exploration of the raw CDI dataset.
# ─────────────────────────────────────────────────────────────────────────────

# 1. Setup ---------------------------------------------------------------------
source("R/setup.R")

# 2. Structure and Completeness  -----------------------------------------------
skimr::skim(raw_cdi)
colSums(is.na(raw_cdi))   # all logical variables are empty

# 3. Remove Rows / Columns with Missing Data -----------------------------------
removed_na <- raw_cdi |>
  filter(is.na(DataValueFootnote)) |>
  select(where(~!all(is.na(.))))

# 4. Longitudinal vs Cross-Sectional -------------------------------------------

# Longitudinal: spans multiple years
cdi_longitudinal <- removed_na %>%
  filter(YearStart != YearEnd)

# Cross-sectional: single-year data
cdi_cross_sectional <- removed_na %>%
  filter(YearStart == YearEnd)

# 6. Distribution of DataValue -------------------------------------------------
cdi_cross_sectional %>%
  ggplot(aes(x = DataValue)) +
  geom_histogram(bins = 30) +
  scale_x_log10() +
  facet_grid(StratificationCategoryID1~Topic, scales = "free")

# 7. Correlograms --------------------------------------------------------------
cdi_cross_sectional %>%
  dplyr::select(StratificationCategoryID1,
                DataValue
                ) %>%
  ggpairs(ggplot2::aes(color = StratificationCategoryID1,
                       alpha = .5
                       )
          ) +
  theme_bw()

# 6.  -------------------------------------------------

