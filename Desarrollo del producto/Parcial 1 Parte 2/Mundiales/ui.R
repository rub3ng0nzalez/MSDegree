# Parte 2 del parcial 1

library(htmltools)
library(utils)
library(DT)
library(dplyr)
library(shinydashboard)
library(shiny)
# Define UI for application that draws a histogram

#b64 <- base64enc::dataURI(file="ARG.png", mime="www")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("General stats", tabName = "generalStats", icon = icon("globe-americas", lib = "font-awesome")),
        menuItem("Info per team", tabName = "infoXteam", icon = icon("flag", lib = "font-awesome") ),
        menuItem("Info per WorldCup", tabName = "infoXwc", icon = icon("flag", lib = "font-awesome") )
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "generalStats",
                h2("General statistics for the World cup"),
                #img(src=b64) ,
                #img(src="www/ARG.jpg"),
                imageOutput('prueba'),
                dataTableOutput('datosGenerales')
        ),
        
        tabItem(tabName = "infoXteam",
                h2("Statistics per national teams")
        )
    )
)

encabezado <- dashboardHeader(title = "World cup")

shinyUI(
    # Put them together into a dashboardPage
    dashboardPage(
        encabezado,
        sidebar,
        body,
        title = 'Copa mundial de futbol',
        skin = 'green'
    )
)
