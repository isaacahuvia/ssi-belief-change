library(easypackages)
libraries("tidyverse", "qualtRics")

## Load data
# Project Personality (Activity 1)
pp_raw <- read_survey("S:\\Project Restore\\Data\\Upswing Part 2 Study - Activity 1_December 17, 2022_08.36.csv") %>%
  filter(StartDate >= as.Date("2022-05-17")) #Filter out pre-release test responses

# ABC (Activity 2)
abc_raw <- read_survey("S:\\Project Restore\\Data\\Upswing Part 2 Study - Activity 2_December 17, 2022_08.38.csv") %>%
  filter(StartDate >= as.Date("2022-05-17")) #Filter out pre-release test responses

# Goals (Activity 3)
goals_raw <- read_survey("S:\\Project Restore\\Data\\Upswing Part 2 Study - Activity 3_December 17, 2022_08.39.csv") %>%
  filter(StartDate >= as.Date("2022-05-17")) #Filter out pre-release test responses


## Clean data
# Save dataframes to a named list so we can iterate over them
df_list = list("Project Personality" = pp_raw,
               "The ABC Project" = abc_raw) #Do this with goals_raw too to catch duplicate IPs

map(.x = df_list,
    .f = ~ .x %>%
      select(IPAddress, StartDate, Finished,
             ipq_duration_pre = `Pre-IPQ_duration_141`,
             ipq_duration_post = `Post-IPQ_duration_141`)) %>%
  bind_rows(.id = "intervention") %>%
  drop_na(ipq_duration_pre, ipq_duration_post) %>%
  group_by(intervention) %>%
  summarize(n = n(),
            pre = mean(ipq_duration_pre),
            post = mean(ipq_duration_post),
            change = mean(ipq_duration_post - ipq_duration_pre))
