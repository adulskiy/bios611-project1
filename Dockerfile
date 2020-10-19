FROM rocker/verse
MAINTAINER Ana Dulskiy <adulskiy15@gmail.com>
RUN R -e "install.packages('patchwork')"
RUN R -e "install.packages('RColorBrewer')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('MLmetrics')"

RUN apt update && apt install -y ne