.PHONY: clean

clean:
	rm derived_data/*
	rm -f figures/*.png
  
derived_data/growth.csv derived_data/stormradius.csv:\
	derived_data/sg.since1988.csv\
	derived_data/sg_v2.csv\
 source_data/YIRCR12S_Growth.csv\
 source_data/YIRCR12S_StormRadius.csv\
 tidy_data.R
	Rscript tidy_data.R
	

figures/plot_linext.png\
 figures/plot_dens.png\
 figures/plot_calc.png: data_eda.R
	Rscript data_eda.R
	
assets/storms_frequency.png\
	assets/storms_frequency_category.png\
	assets/annualgrowth_compiled.png\
	assets/annualchange_compiled.png\
	assets/annualgrowth_since1988_compiled.png: data_eda.R
		Rscript data_eda.R


