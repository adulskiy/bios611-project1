FROM rocker/verse
MAINTAINER Ana Dulskiy <adulskiy15@gmail.com>
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('patchwork')"
RUN R -e "install.packages('RColorBrewer')"
RUN apt-get update && apt install ne
-