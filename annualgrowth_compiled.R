library(tidyverse)
library(patchwork)

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

# lowercase
colnames(sg) <- tolower(colnames(sg))

# Create plots for growth over time using geom_smooth()

dens <- ggplot(data = sg, aes(x = year, y = density)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "red") +
  labs(x = "Year", y = "Density (g/cm3/yr)")

calc <- ggplot(data = sg, aes(x = year, y = calc)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "navy") +
  labs(x = "Year", y = "Calcification (g/cm2/yr)")

linext <- ggplot(data = sg, aes(x = year, y = linext)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "orange") +
  labs(x = "Year", y = "Extension (cm/year)")

annualgrowth_compiled <- linext + calc + dens
ggsave("assets/annualgrowth_compiled.png", plot = annualgrowth_compiled)
