
library(shiny)
library(dplyr)
library(RMySQL)
library(DT)
library(leaflet)
library(rgdal)
library(RColorBrewer)
library(shinydashboard)
library(Shinythemes)
library(dashboardthemes)
library(lubridate)


shinyServer(function(input, output) {
  
  con <- dbConnect(MySQL(),user = 'usrmapa', password = 'prueba123', host ='db', port = 3306, dbname ='Mapamundi')
  infoTotal <- dbGetQuery(con,'select count(*) from casos_covid')
  
  output$Texto <- renderText(paste0('cantidad lineas asdfasdf',infoTotal))
  
  
  # output$datos <-renderDataTable({
  #   
  #   infoTotal %>% datatable(escape = FALSE, options = list(searching = FALSE))
  # })

})
