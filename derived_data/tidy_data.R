library(tidyverse)

growth <- read_csv("source_data/YIRCR12S_Growth.csv");
stormradius <- read_csv("source_data/YIRCR12S_StormRadius.csv" );

# Do something to clean stuff up.

write_csv(growth, "derived_data/Growth.csv");
write_csv(stormradius, "derived_data/StormRadius.csv")

str(growth)
head(growth)

# Stormradius - a bunch of empty (NaN) rows at the end, need to get rid of them
storms_tidy <- stormradius %>%
  filter_all(any_vars(!is.na(.)))

# Stormradius - multiple data points per storm
# Need to figure out how to handle this

# I'll first average all the data points for each storm, even though
#     this probably isn't the ideal way to handle the data

storms_means <- storms_tidy %>%
  group_by(TCid) %>%
  summarise_each(funs(mean = mean(., na.rm = TRUE)))

# but this still leaves us with multiple observations per year

storms_freq <- storms_means %>%
  count(Year_mean)

# Create additional column of storm strength (category) based on sea level pressure

storms_cat <- storms_tidy %>%
  mutate(Category = ifelse(SeaLevelPressure > 980, "1",
         ifelse(SeaLevelPressure %in% 965:979, "2",
                ifelse(SeaLevelPressure %in% 945:964, "3",
                       ifelse(SeaLevelPressure %in% 920:944, "4",
                              ifelse(SeaLevelPressure < 920, "5", "0"))))))
# Add category to storms_means
storms_mean_cat <- storms_means %>%
  mutate(Category = ifelse(SeaLevelPressure_mean > 980, "1",
                           ifelse(SeaLevelPressure_mean %in% 965:979, "2",
                                  ifelse(SeaLevelPressure_mean %in% 945:964, "3",
                                         ifelse(SeaLevelPressure_mean %in% 920:944, "4",
                                                ifelse(SeaLevelPressure_mean < 920, "5", "0"))))))

# Rename Year_mean to Year in storms_mean_cat
storms_v2 <- rename(storms_mean_cat, Year = Year_mean)

# Now let's do a full join of the two datasets, storms_mean_cat and growth

sg <- storms_v2 %>%
  full_join(growth)
str(sg)

# Make everything lowercase
colnames(sg) <- tolower(colnames(sg))

# Zoom into 1990-2014

sg.since1990 <- sg %>%
  filter(year > 1989)

# Zoom into 1970-2014 for growth data
growth.since1970 <- growth %>%
  filter(Year > 1969)

# Mutate to add linext_change, calc_change, and dens_change to joined data
sg_v2 <- sg %>%
  mutate(linext_change = linext - lag(linext)) %>%
  mutate(dens_change = density - lag(density)) %>%
  mutate(calc_change = calc - lag(calc))

# For 1988-2015
sg.since1988 <- sg_v2 %>%
  filter(year > 1987)


# So many data frames - what do they mean?

## original data: stormradius, growth
## storms_tidy.csv - removed hundreds of empty (NaN) rows at the end of the df
## storms_means - averaged data for each storm (based on TCid)
## storms_freq - just year and # of storms
## storms_cat - added category column to storms_tidy
## storms_mean_cat - added category column to storms_means
## storms_v2 - small rename for storms_mean_cat (shouldn't have bothered with this)
## sg - full join of storms_v2 (essentially storms_mean_cat) with growth (joined by year)
## sg_v2 - added columns for growth data of change from previous year (linext_change, dens_change, calc_change)

