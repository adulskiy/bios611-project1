library(tidyverse)

growth <- read_csv("source_data/YIRCR12S_Growth.csv");
stormradius <- read_csv("source_data/YIRCR12S_StormRadius.csv" );

# Do something to clean stuff up.

write_csv(growth, "derived_data/Growth.csv");
write_csv(stormradius, "derived_data/StormRadius.csv")

# Exploring growth dataset.
str(growth)
head(growth)

# Goal: plot linear extension, density, and calcification throughout years

plot_linext <- ggplot(data = growth,
       mapping = aes(x = Year, y = linext)) +
  geom_point() +
  geom_smooth()

plot_lins <- ggplot(data = growth,
                    mapping = aes(x = Year, y = density)) +
  geom_point() +
  geom_smooth()

plot_calc <- ggplot(data = growth,
                    mapping = aes(x = Year, y = calc)) +
  geom_point() +
  geom_smooth()

plot_linext
plot_lins
plot_calc

# Initial plots for stormradius.

head(stormradius)
str(stormradius)
