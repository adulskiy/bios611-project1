library(tidyverse)
summary(growth)
head(growth)

ggplot(data = growth,
       mapping = aes(x = Year, y = linext)) +
  geom_point() +
  geom_smooth()

ggplot(data = growth,
       mapping = aes(x = Year, y = density)) +
  geom_point() +
  geom_smooth()

stormradius
stormradius1990 <- stormradius %>% filter(Year == 1990);
growth1990 <- growth %>% filter(Year == 1990);

stormsperyear <- stormradius %>%
                  group_by(Year) %>%
                  tally()

# plot with year on x axis, linext on y axis left, number of storms on y axis right)
stormradius

view(stormsperyear)
# remove NaN
stormsperyear.tidy <- stormsperyear[-c(26), ]

# plot stormsperyear
ggplot(data = stormsperyear.tidy,
       mapping = aes(x = Year, y = n)) +
  geom_col(alpha = 0.5)

# combine the two
ggplot(data = growth,
       mapping = aes(x = Year, y = linext)) +
  geom_point() +
  geom_smooth()
