#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(htmltools)
library(utils)
library(DT)
library(dplyr)
library(png)
library(shinydashboard)
library(shiny)

infoGeneral <- read.csv(file = 'Data/WorldCups.csv')

#----Creacion de tabla para datos generales
salidaGeneral <- infoGeneral

# salidaGeneral$Winner <- paste0('<img src="http://www.allcompetitions.com/Flags/',
#                                   salidaGeneral$Winner.Ab,
#                                 '.jpg"> ',
#                                 salidaGeneral$Winner,
#                                 ' </img>')

salidaGeneral$Winner <- paste0('<img src="',
                               salidaGeneral$Winner.Ab,
                               '.jpg" > ',
                               salidaGeneral$Winner,
                               ' </img>')


salidaGeneral$Second <- paste0('<img src="',
                               salidaGeneral$Second.Ab,
                               '.jpg"> ',
                               salidaGeneral$Second,
                               ' </img>')

salidaGeneral$Third <- paste0('<img src="',
                              salidaGeneral$Third.Ab,
                              '.jpg"> ',
                              salidaGeneral$Third,
                              ' </img>')

salidaGeneral$Fourth <- paste0('<img src="',
                               salidaGeneral$Fourth.Ab,
                               '.jpg"> ',
                               salidaGeneral$Fourth,
                               ' </img>')



salidaGeneral <- salidaGeneral %>% select(-c("Winner.Ab","Second.Ab","Third.Ab","Fourth.Ab"))
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # output$prueba <- renderImage({
    #     list(
    #         src = "www/ARG.jpg",
    #         alt = "Texto alterno"
    #     )
    # })
    
    output$totalGoles <- renderInfoBox({
        infoBox(
            "Total goles anotados", 
            formatC(sum(salidaGeneral$GoalsScored), format = "d", big.mark = "," ), 
            icon = icon("futbol"),
            color = "purple", 
            fill = TRUE
        )
    })
    
    output$totalJuegos <- renderInfoBox({
        infoBox(
            "Total juegos realizados", 
            formatC(sum(salidaGeneral$MatchesPlayed), format = "d", big.mark = "," ), 
            icon = icon("futbol"),
            color = "green", 
            fill = TRUE
        )
    })
    
    output$datosGenerales <- renderDataTable({
        
        salidaGeneral %>% datatable( escape = FALSE, options = list(searching = FALSE, ordering = TRUE, pageLength = 25))
    }) 
    
})