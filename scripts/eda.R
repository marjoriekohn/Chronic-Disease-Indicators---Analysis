################################################################################
# load libraries
################################################################################
library(readr)
library(tidyverse)
library(skimr)


################################################################################
# import clean data
################################################################################
clean_cdi <- read_csv(file = "data/processed/clean_cdi.csv")


################################################################################
# Visualize comparable questions
################################################################################
clean_cdi |>
  group_by(DataValueUnit, DataValueType) |>
  summarize(
    n_questions = n_distinct(Question),
    n_topics    = n_distinct(Topic),
    .groups     = "drop"
  ) |>
  mutate(
    DataValueType = fct_reorder(DataValueType, n_questions)
  )





################################################################################
# Which topics have the highest amount of missing data?
################################################################################
clean_cdi |>
  mutate(
    .by = Question,
    missing      = is.na(DataValue),
    prop_missing = mean(missing)
  ) |>
  #filter(prop_missing < 0.3) |>
  distinct(Topic, Question, Stratification1, prop_missing) |>
  filter(Topic == "Cardiovascular Disease") |>
  arrange(prop_missing) |>
  print(n = 60)


################################################################################
# count unique DataValueFootnote
################################################################################
remove_bad_strat_cols |>
  count(DataValueFootnote, name = "count", sort = TRUE) |>
  print(n = 500)


################################################################################
# which questions / stratifications have "data suppressed" in DataValueFootnote
################################################################################
remove_bad_strat_cols |>
  filter(str_detect(DataValueFootnote, "Data suppressed;")) |>
  distinct(Topic, Question, Stratification1) |>
  arrange(Topic, Question) |>
  print(n = 100)


################################################################################
# Which DataSource has the highest amount of missing data?
################################################################################
remove_bad_strat_cols |>
  mutate(
    .by = Question,
    missing      = is.na(DataValue),
    prop_missing = mean(missing)
  ) |>
  #filter(prop_missing < 0.3) |>
  arrange(Topic, desc(prop_missing)) |>
  distinct(DataSource, Topic) |>
  print(n = 60)





################################################################################
# Heatmap EDA
################################################################################
topic_to_view <- "Social Determinants of Health"

filtered_topics |>
  filter(Topic == topic_to_view) |>
  ggplot(aes(
    x    = LocationAbbr,
    y    = Question,
    fill = DataValue
  )) +
  geom_tile() +
  coord_equal() +
  labs(
    title = topic_to_view,
    x     = "State",
    y     = "Question",
    fill  = "Data Value"
  ) +
  theme_bw() +
  theme(
    axis.text.y = element_text(size = 6)  # questions are long
  )

filtered_topics |>
  filter(Topic == topic_to_view) |>
  ggplot(aes(LocationAbbr, DataValue)) +
  geom_col() +
  facet_wrap(~ Question, scales = "free_y") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



################################################################################
# keep questions that have at least 70% data completeness
################################################################################
filtered_topics <- clean_cdi |>
  mutate(
    .by = Question,
    missing      = is.na(DataValue),
    prop_missing = mean(missing)
  ) |>
  filter(prop_missing < 0.3)


################################################################################
# which disease and risk-factor questions use the same metric
################################################################################
diseases <- c(
  "Cancer",
  "Diabetes",
  "Cardiovascular Disease",
  "Chronic Obstructive Pulmonary Disease"
)

risk_factors <- c(
  "Alcohol",
  "Tobacco",
  "Nutrition, Physical Activity, and Weight Status",
  "Mental Health",
  "Social Determinants of Health"
)

measurement_overlap <- filtered_topics |>
  mutate(category = if_else(Topic %in% diseases, "Disease",
                    if_else(Topic %in% risk_factors, "Risk Factor", "Other"))) |>
  filter(category != "Other") |>
  distinct(category, DataValueUnit, DataValueType) |>
  count(DataValueUnit, DataValueType)


comparable_questions <- filtered_topics |>
  inner_join(
    measurement_overlap |> select(DataValueUnit, DataValueType),
    by = c("DataValueUnit", "DataValueType")
  )

################################################################################
# visualize distribution of missingness among comparable questions
################################################################################
comparable_questions |>
  distinct(Question, Topic, prop_missing) |>
  ggplot(aes(
    x = fct_reorder(Question, prop_missing),
    y = prop_missing,
    fill = Topic
  )) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Questions Missing Data Values",
    x = "Questions",
    y = "Proportion Missing"
  ) +
  theme_bw()

################################################################################
# which questions use cases per 100,000 and Age-adjusted Rate
################################################################################

clean_cdi |>
  filter(
    DataValueUnit == "%" &
    DataValueType == "Age-adjusted Prevalence"
  ) |>
  distinct(Question, Topic)



################################################################################
# potential plot
# No leisure-time physical activity among adults-Nutrition, Physical Activity, and Weight Status
# High cholesterol among adults who have been screened-Cardiovascular Disease
################################################################################
questions_of_interest <- c(
  "No leisure-time physical activity among adults",
  "High cholesterol among adults who have been screened"
)

plot_df <- comparable_questions |>
  filter(Question %in% questions_of_interest) |>
  select(
    Question,
    DataValue,
    LocationAbbr,
    Stratification1
  ) |>
  mutate(
    .by = c(LocationAbbr, Question),
    state_mean  = mean(DataValue, na.rm = TRUE)
  )

plot_df |>
  ggplot(aes(
    x     = fct_reorder(LocationAbbr, state_mean),
    y     = DataValue,
    color = Question,
    group = Question
  )) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(
    title = "Physical Inactivity vs High Cholesterol by State",
    x     = "State",
    y     = "Percent of Adults",
    color = "Measure"
  ) +
  theme_bw() +
  theme(
    legend.position = "top",
    axis.text.y = element_text(size = 7)
  )


################################################################################
# remove united states and territories, keep only states
# territories have so much missing data so I'm removing them for now
# removing US for now but might use it later to compare state values to
# national average, for now my focus is on state level data
################################################################################
locations_to_remove <- c(
  "United States",
  "Puerto Rico",
  "Guam",
  "Virgin Islands"
)

states_only <- clean_columns |>
  filter(!LocationDesc %in% locations_to_remove)

skim(states_only)





################################################################################
# Find Comparable Questions
################################################################################
clean_cdi |>
  group_by(DataValueUnit, DataValueType) |>
  select(Question, Topic)


################################################################################
# Topic/Question pairs that have the same DataValueUnit and DataValueType
################################################################################
clean_cdi |>
  distinct(Topic, Question, DataValueUnit, DataValueType) |>
  group_by(DataValueUnit, DataValueType) |>
  filter(n() > 1) |>
  arrange(DataValueUnit, DataValueType, Topic, Question) |>
  print(n = 200)

################################################################################
# look for same DataValueUnit and DataValueType based on keyword
################################################################################
clean_cdi |>
  filter(
    str_detect(Question, "mortality")
  ) |>
  count(DataValueUnit, DataValueType)
