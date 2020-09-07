library(tidyverse)

growth <- read_csv("source_data/YIRCR12S_Growth.csv");
stormradius <- read_csv("source_data/YIRCR12S_StormRadius.csv" );

# Do something to clean stuff up.

write_csv(growth, "derived_data/Growth.csv");
write_csv(stormradius, "derived_data/StormRadius.csv")

str(growth)
head(growth)

# Stormradius - multiple data points per storm
# Need to figure out how to handle this
# Also need to convert m to km

