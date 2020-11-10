.PHONY: clean
SHELL: /bin/bash

clean:
	rm -f derived_data/*.csv
	rm -f derived_data/*.R
	rm -f assets/*.png
	rm -f RMD-report.pdf

# Project 1
report.pdf:\
 RMD-report.Rmd\
 assets/storms_frequency.png\
 assets/storms_frequency_category.png\
 assets/annualgrowth_compiled.png\
 assets/annualchange_compiled.png\
 assets/annualgrowth_since1988_compiled.png
	R -e "rmarkdown::render('RMD-report.Rmd', output_format = 'pdf_document')"
	
derived_data/growth.csv derived_data/stormradius.csv:\
 source_data/YIRCR12S_Growth.csv\
 source_data/YIRCR12S_StormRadius.csv\
 tidy_data.R
	Rscript tidy_data.R

derived_data/storms_means.csv:\
 source_data/YIRCR12S_Growth.csv\
 source_data/YIRCR12S_StormRadius.csv\
 storms_frequency.R
	Rscript storms_frequency.R

assets/storms_frequency.png:\
 derived_data/StormRadius.csv\
 storms_frequency.R
	Rscript storms_frequency.R
	
assets/storms_frequency_category.png:\
 derived_data/StormRadius.csv\
 storms_frequency_category.R
	Rscript storms_frequency_category.R

assets/annualgrowth_compiled.png:\
 derived_data/StormRadius.csv\
 derived_data/Growth.csv\
 annualgrowth_compiled.R
	Rscript annualgrowth_compiled.R
		
assets/annualchange_compiled.png:\
 derived_data/StormRadius.csv\
 derived_data/Growth.csv\
 annualchange_compiled.R
	Rscript annualchange_compiled.R
		
assets/annualgrowth_since1988_compiled.png:\
 derived_data/StormRadius.csv\
 derived_data/Growth.csv\
 annualgrowth_since1988_compiled.R
	Rscript annualgrowth_since1988_compiled.R



# Project 2

.PHONY: shiny
shiny: shinyproject/data/sg.csv
	Rscript shinyproject/app.R ${PORT}
	
sg.csv: source_data/YIRCR12S_Growth.csv\
 source_data/YIRCR12S_StormRadius.csv\
 sg.R
	Rscript sg.R
