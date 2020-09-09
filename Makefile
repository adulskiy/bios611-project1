.PHONY: clean

clean:
	rm derived_data/*
	rm -f figures/*.png
  
derived_data/growth.csv derived_data/stormradius.csv:\
 source_data/YIRCR12S_Growth.csv\
 source_data/YIRCR12S_StormRadius.csv\
 tidy_data.R
	Rscript tidy_data.R

figures/plot_linext.png\
 figures/plot_dens.png\
 figures/plot_calc.png: data_eda.R
	Rscript data_eda.R

