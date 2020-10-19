library(tidyverse)
library(RColorBrewer)

stormradius <- read_csv("source_data/YIRCR12S_StormRadius.csv");
write_csv(stormradius, "derived_data/storm_radius.csv")

# Tidy (tidier) data.
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

# Plot histogram of storm frequency with categories legend.
storms_fc <- ggplot(data = storms_mean_cat,
                    mapping = aes(x = Year, fill = Category)) +
  geom_histogram(binwidth = 1, color = "black", alpha = 0.7, size = 0.2) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 7)) +
  labs(x = "Year", y = "Number of storms") +
  scale_fill_brewer(palette = "Reds")

ggsave("assets/storms_frequency_category.png", plot = storms_fc)