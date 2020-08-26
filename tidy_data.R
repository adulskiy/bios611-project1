library(tidyverse)

growth <- read_csv("source_data/YIRCR12S_Growth.csv");
stormradius <- read_csv("source_data/YIRCR12S_StormRadius.csv" );

# Do something to clean stuff up.

write_csv(growth, "derived_data/Growth.csv");
write_csv(stormradius, "derived_data/StormRadius.csv");



