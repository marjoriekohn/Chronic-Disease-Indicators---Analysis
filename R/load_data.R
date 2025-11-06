# ─────────────────────────────────────────────────────────────────────────────
# HGEN 611 – Dataset Project
# Author: Maggie Kohn
# Date: 2025-10-31
# Description: Imports and summarizes raw Chronic Disease Indicators data
# ─────────────────────────────────────────────────────────────────────────────

# 1. Setup ---------------------------------------------------------------------
source("R/setup.R")

# 2. Data ----------------------------------------------------------------------
raw_cdi <- read_csv(file = "data/raw/U.S._Chronic_Disease_Indicators_20251008.csv")

# 3. Overview ------------------------------------------------------------------
skim(raw_cdi)
