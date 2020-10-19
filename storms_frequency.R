library(tidyverse)

StormRadius <- read_csv("source_data/YIRCR12S_StormRadius.csv");
write_csv(StormRadius, "derived_data/storm_radius.csv")


# Tidy (tidier) data.
storms_tidy <- StormRadius %>%
  filter_all(any_vars(!is.na(.)))
write_csv(storms_tidy, "derived_data/storms_tidy")


# Average for each storm.
storms_means <- storms_tidy %>%
  group_by(TCid) %>%
  summarise_each(funs(mean = mean(., na.rm = TRUE)))

write_csv(storms_means, "derived_data/storms_means.csv")

# Histogram of storms/year
storms_hist <- ggplot(data = storms_means,
                      mapping = aes(x = Year_mean)) +
  geom_histogram(binwidth = 1, fill = "white", color = "#00AFBB", alpha = 0.4) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 7)) +
  labs(x = "Year", y = "Number of storms")

ggsave("assets/storms_frequency.png", plot = storms_hist)
