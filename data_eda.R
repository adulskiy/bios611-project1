library(tidyverse)
library(RColorBrewer)
library(patchwork)

growth <- read_csv("source_data/YIRCR12S_Growth.csv");
stormradius <- read_csv("source_data/YIRCR12S_StormRadius.csv");

write_csv(growth, "derived_data/Growth.csv");
write_csv(stormradius, "derived_data/StormRadius.csv")

# Check for missing values
sapply(sg, function(x) sum(is.na(x)))
# There are quite a few. At this point I'm not really sure what to do with this
#     in my analysis, but it's something to be aware of.

# Histogram of storms/year
storms_hist <- ggplot(data = storms_means,
       mapping = aes(x = Year_mean)) +
  geom_histogram(binwidth = 1, fill = "white", color = "#00AFBB", alpha = 0.4) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 7)) +
  labs(x = "Year", y = "Number of storms")

ggsave("assets/storms_frequency.png", plot = storms_hist)

# Add storm categories to histogram
# Created new df (tibble) that includes categories ("storms_mean_cat")

storms_hc <- ggplot(data = storms_mean_cat,
       mapping = aes(x = Year_mean, fill = Category)) +
  geom_histogram(binwidth = 1, color = "black", alpha = 0.7, size = 0.2) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 7)) +
  labs(x = "Year", y = "Number of storms") +
  scale_fill_brewer(palette = "Reds")

ggsave("assets/storms_frequency_category.png", plot = storms_hc)


# The code below makes a scatter plot of storms over time with coloration by category

storms_fc <- ggplot(data = storms_mean_cat,
       mapping = aes(x = Year_mean, y = Distance_mean, color = Category)) +
  geom_point(size = 2.5) +
  scale_colour_brewer(palette = "Reds") +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 7))


# Next, let's see if there are any trends for coral growth
dens <- ggplot(data = sg, aes(x = year, y = density)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "red") +
  labs(x = "Year", y = "Density (g/cm3/yr)")

dens

calc <- ggplot(data = sg, aes(x = year, y = calc)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "navy") +
  labs(x = "Year", y = "Calcification (g/cm2/yr)")
calc

linext <- ggplot(data = sg, aes(x = year, y = linext)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "orange") +
  labs(x = "Year", y = "Extension (cm/year)")
linext

annualgrowth_compiled <- linext + calc + dens
ggsave("assets/annualgrowth_compiled.png", plot = annualgrowth_compiled)



# Zoom into 1990-2014

sg.since1990 <- sg %>%
  filter(year > 1989)

dens2 <- ggplot(data = sg.since1988, aes(x = year, y = density)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "red") +
  labs(x = "Year", y = "Density (g/cm3/yr)")
dens2

calc2 <- ggplot(data = sg.since1988, aes(x = year, y = calc)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "navy") +
  labs(x = "Year", y = "Calcification (g/cm2/yr)")
calc2

linext2 <- ggplot(data = sg.since1988, aes(x = year, y = linext)) +
  geom_point(alpha = 0.5) +
  geom_smooth(col = "orange") +
  labs(x = "Year", y = "Extension (cm/year)")
linext2

annualgrowth_since1990_compiled <- linext2 + calc2 + dens2

ggsave("assets/annualgrowth_since1990_compiled.png", plot = annualgrowth_since1990_compiled)

# with geom_line() instead of geom_smooth()
dens3 <- ggplot(data = sg.since1988, aes(x = year, y = density)) +
  geom_point(alpha = 0.5) +
  geom_line(col = "red") +
  labs(x = "Year", y = "Density (g/cm3/yr)")
dens3

calc3 <- ggplot(data = sg.since1988, aes(x = year, y = calc)) +
  geom_point(alpha = 0.5) +
  geom_line(col = "navy") +
  labs(x = "Year", y = "Calcification (g/cm2/yr)")
calc3

linext3 <- ggplot(data = sg.since1988, aes(x = year, y = linext)) +
  geom_point(alpha = 0.5) +
  geom_line(col = "orange") +
  labs(x = "Year", y = "Extension (cm/year)")
linext3

linext3 + calc3 + dens3


# Now to look at growth and storm data together.

# Might be interesting to plot change in coral cover/year
# Created new df that includes this (sg_v2)
    

linext_change1988 <- ggplot(data = sg.since1988, 
       aes(x = year, y = linext_change, fill = linext_change > 0)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Change in linear extension (cm/year)") +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none")

calc_change1988 <- ggplot(data = sg.since1988, 
                          aes(x = year, y = calc_change, fill = calc_change > 0)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Change in calcification (g/cm2/year)") +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none")

dens_change1988 <- ggplot(data = sg.since1988, 
                          aes(x = year, y = dens_change, fill = dens_change > 0)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Change in density (g/cm3/year)") +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none")

linext_change1988 + calc_change1988 + dens_change1988

# Zoom back out, need to do the same join + change mutation as I did for the 1990 data

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



# Misc.
# The following code is an (unsuccessful) attempt to make a map of storm data
library(ggmap)

# Filter data to only include latitude, longitude, and storm strength
storms_map <- storms_mean_cat %>%
  select(Year_mean, Latitude_mean, Longitude_mean, Category)


map <- get_googlemap(center = c(26.563, -81.94), zoom = 6)
ggmap(map)

?get_googlemap()
# ok that didn't work idk how to do this

