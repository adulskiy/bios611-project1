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

# Mutate to add linext_change, calc_change, and dens_change to joined data
sg_v2 <- sg %>%
  mutate(linext_change = linext - lag(linext)) %>%
  mutate(dens_change = density - lag(density)) %>%
  mutate(calc_change = calc - lag(calc))


# Plot change/year in growth for linext, calc, and dens over time
linext_change <- ggplot(data = sg_v2, 
                        aes(x = year, y = linext_change, fill = linext_change > 0)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Change in linear extension (cm/year)") +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none")


calc_change <- ggplot(data = sg_v2, 
                      aes(x = year, y = calc_change, fill = calc_change > 0)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Change in calcification (g/cm2/year)") +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none")

dens_change <- ggplot(data = sg_v2, 
                      aes(x = year, y = dens_change, fill = dens_change > 0)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Change in density (g/cm3/year)") +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none")

annualchange_compiled <- linext_change + calc_change + dens_change
ggsave("assets/annualchange_compiled.png", plot = annualchange_compiled)