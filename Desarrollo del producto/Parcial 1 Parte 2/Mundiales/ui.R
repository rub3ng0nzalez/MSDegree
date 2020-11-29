# Parte 2 del parcial 1

library(htmltools)
library(utils)
library(DT)
library(dplyr)
library(shinydashboard)
library(shiny)
# Define UI for application that draws a histogram


sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("General stats", tabName = "generalStats", icon = icon("globe-americas", lib = "font-awesome")),
        menuItem("Info per team", tabName = "infoXteam", icon = icon("flag", lib = "font-awesome") ),
        menuItem("Info per WorldCup", tabName = "infoXwc", icon = icon("trophy", lib = "font-awesome") ),
        menuItem("About", tabName = "about", icon = icon("user-graduate", lib = "font-awesome") )
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "generalStats",
                h2("Estadisticas generales de la copa del mundo"),
                h4(""),
                fluidRow(
                    # A static infoBox
                    infoBox("Sin mundial", 
                            "En los años 1942 y 1946 no se jugo mundial debido a la segunda guerra mundial", 
                            icon = icon("fighter-jet", lib = "font-awesome"), fill = TRUE),
                    infoBoxOutput("totalGoles"),
                    infoBoxOutput("totalJuegos")
                ),
                #imageOutput('prueba'),
                dataTableOutput('datosGenerales')
        ),
        
        tabItem(tabName = "infoXteam",
                h2("Statistics per national teams")
        ),
        tabItem(tabName = "infoXwc",
                h2("Statistics per World cup")
        ),
        tabItem(tabName = "about",
                h2("Parcial 1 - Fase 2"),
                h4(" "),
                h4('Ruben Gonzalez - 20003314'),
                h4('Vidal Baez - 20002076'),
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
