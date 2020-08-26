.PHONY: clean

clean:
		rm derived_data/*
  
derived_data/growth.csv derived_data/stormradius.csv:\
	source_data/YIRCR12S_Growth.csv\
	source_data/YIRCR12S_StormRadius.csv\
	tidy_data.R
		Rscript tidy_data.R
