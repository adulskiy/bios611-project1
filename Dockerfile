FROM rocker/verse
MAINTAINER Ana Dulskiy <adulskiy15@gmail.com>
RUN R -e "install.packages('patchwork')"
RUN R -e "install.packages('RColorBrewer')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('MLmetrics')"
RUN R -e "install.packages('factoextra')"
RUN R -e "install.packages('shiny')"


RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy pandas sklearn plotnine matplotlib pandasql bokeh
RUN pip3 install geopandas descartes shapely
RUN pip3 install nbconvert

RUN apt update && apt install -y ne