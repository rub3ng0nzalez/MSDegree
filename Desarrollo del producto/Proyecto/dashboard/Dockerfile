FROM rocker/shiny:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends libmysqlclient-dev

RUN R -e "install.packages(c('RMySQL','dplyr','DT','leaflet','RColorBrewer','shinydashboard','shinythemes','lubridate'))"