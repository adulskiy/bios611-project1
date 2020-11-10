library(tidyverse)

stormradius <- read_csv("source_data/YIRCR12S_StormRadius.csv");
growth <- read_csv("source_data/YIRCR12S_Growth.csv");
write_csv(stormradius, "derived_data/StormRadius.csv");
write_csv(growth, "derived_data/Growth.csv");

# Tidy (tidier) storm data.
storms_tidy <- stormradius %>%
  filter_all(any_vars(!is.na(.)))

# Average for each storm and add category (strength).
storms_mean_cat <- storms_tidy %>%
  group_by(TCid) %>%
  summarise_each(funs(mean = mean(., na.rm = TRUE))) %>% # average for each unique storm
  rename(Year = Year_mean) %>% 
  mutate(Category = ifelse(SeaLevelPressure_mean > 980, "1",
                           ifelse(SeaLevelPressure_mean %in% 965:979, "2",
                                  ifelse(SeaLevelPressure_mean %in% 945:964, "3",
                                         ifelse(SeaLevelPressure_mean %in% 920:944, "4",
                                                ifelse(SeaLevelPressure_mean < 920, "5", "0"))))))

# Now let's do a full join of the two datasets, storms_mean_cat and growth

sg <- storms_mean_cat %>%
  full_join(growth)

colnames(sg) <- tolower(colnames(sg))

write_csv(sg, "shinyproject/data/sg.csv")
