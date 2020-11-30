#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(htmltools)
library(modeest)
library(utils)
library(DT)
library(dplyr)
library(png)
library(shinydashboard)
library(shiny)

infoGeneral <- read.csv(file = 'Data/WorldCups.csv')
infoMatches <- read.csv(file = 'Data/WorldCupMatches.csv')

#----Creacion de tabla para matches
salidaMatches <- infoMatches


#----Creacion de tabla para datos generales
salidaGeneral <- infoGeneral

salidaGeneral$Country <- paste0('<img src="',
                               salidaGeneral$Country.Ab,
                               '.jpg" > ',
                               salidaGeneral$Country,
                               ' </img>')

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


salidaGeneral$Attendance <- salidaGeneral$Attendance %>% formatC(format = "d", big.mark = "," )

masCampeon <- mfv(infoGeneral$Winner)
masFrecuencia <- count(infoGeneral %>% filter(infoGeneral$Winner == masCampeon))

maxAttendance <- max(infoGeneral$Attendance)
mundialMaxAttendance <- infoGeneral %>% filter(infoGeneral$Attendance == maxAttendance)

capturaTorneo <- NULL


salidaGeneral <- salidaGeneral %>% select(-c("Country.Ab","Winner.Ab","Second.Ab","Third.Ab","Fourth.Ab"))

infoElegido<-NULL
infoElegidoMatches <-NULL

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # output$prueba <- renderImage({
    #     list(
    #         src = "www/ARG.jpg",
    #         alt = "Texto alterno"
    #     )
    # })
    
    

    
    #------------------------INI: Estadisticas por copa mundial ------------------------------------
    updateSelectInput(session = session,
                      inputId = 'eligeMundial',
                      choices = infoGeneral$Year)
    
    observe({
        infoElegido <<- infoGeneral %>% filter(infoGeneral$Year == input$eligeMundial)
        infoElegidoMatches <<- infoMatches %>% filter(infoMatches$Year == input$eligeMundial)
        
        output$Wc.Campeon <- renderInfoBox({
            infoBox(
                "Campeon del torneo", 
                infoElegido$Winner, 
                icon = icon("trophy", lib = "font-awesome"),
                color = "yellow", 
                fill = FALSE
            )
        })
        
        output$Wc.Second <- renderInfoBox({
            infoBox(
                "Finalista", 
                infoElegido$Second, 
                icon = icon("medal", lib = "font-awesome"),
                color = "maroon", 
                fill = FALSE
            )
        })
        
        output$Wc.Third <- renderInfoBox({
            infoBox(
                "Tercer lugar", 
                infoElegido$Third, 
                icon = icon("award", lib = "font-awesome"),
                color = "blue", 
                fill = FALSE
            )
        })
        
        output$Wc.Fourth <- renderInfoBox({
            infoBox(
                "Cuarto lugar", 
                infoElegido$Fourth, 
                icon = icon("award", lib = "font-awesome"),
                color = "blue", 
                fill = FALSE
            )
        })
        
        output$Wc.Matches <- renderInfoBox({
            infoBox(
                "Partidos disputados", 
                infoElegido$MatchesPlayed, 
                icon = icon("futbol", lib = "font-awesome"),
                color = "black", 
                fill = FALSE
            )
        })
        
        output$Wc.Goles <- renderInfoBox({
            infoBox(
                "Goles anotados", 
                infoElegido$GoalsScored, 
                icon = icon("futbol", lib = "font-awesome"),
                color = "black", 
                fill = FALSE
            )
        })
        
        output$Wc.Teams <- renderInfoBox({
            infoBox(
                "Equipos participantes", 
                infoElegido$QualifiedTeams, 
                icon = icon("star", lib = "font-awesome"),
                color = "aqua", 
                fill = FALSE
            )
        })
        
        output$Wc.Fans <- renderInfoBox({
            infoBox(
                "Aficionados asistentes", 
                formatC(infoElegido$Attendance, format = "d", big.mark = ","), 
                icon = icon("grin-stars", lib = "font-awesome"),
                color = "aqua", 
                fill = FALSE
            )
        })
    })
    
    
    
    observeEvent(input$eligeMundial,{
        
        
        noTabs<-infoElegidoMatches$Stage %>% unique()
        if (length(noTabs)>=1)
        {
            infoElegidoMatches$Home.Team.Name <- paste0('<img src="',
                                                        infoElegidoMatches$Home.Team.Initials,
                                                        '.jpg"> ',
                                                        infoElegidoMatches$Home.Team.Name,
                                                        ' </img>')
            
            infoElegidoMatches$Away.Team.Name <- paste0('<img src="',
                                                        infoElegidoMatches$Away.Team.Initials,
                                                        '.jpg"> ',
                                                        infoElegidoMatches$Away.Team.Name,
                                                        ' </img>')
            
            infoElegidoMatches$Attendance <- infoElegidoMatches$Attendance %>% formatC(format = "d", big.mark = "," )
            
            columns2hide <- match(c("Year","RoundID","MatchID",
                                    "Home.Team.Initials","Away.Team.Initials",
                                    "Stage","Half.time.Home.Goals", "Half.time.Away.Goals"), colnames(infoElegidoMatches))
            #Limpiar el tabPanel
            if(!is.null(capturaTorneo))
            {
                for (j in 1:length(capturaTorneo)){
                    removeTab(inputId = "torneo", target = capturaTorneo[j], session = session)
                }
            }
            
            #Llenar con los nuevos stage
            for (i in 1:length(noTabs))
            {
                
                Wc.stage <- infoElegidoMatches %>% filter(infoElegidoMatches$Stage ==noTabs[i])
                prependTab("torneo", session = session,
                           tabPanel(title = noTabs[i], value = noTabs[i], target = noTabs[i],
                                    Wc.stage %>% datatable(
                                        escape = FALSE, colnames = c('Local' = 'Home.Team.Name',
                                                                     'Visitante' = 'Away.Team.Name',
                                                                     'Goles local' = 'Home.Team.Goals',
                                                                     'Goles visitante' = 'Away.Team.Goals',
                                                                     'Aficionados' = 'Attendance',
                                                                     'Condiciones' = 'Win.conditions'),
                                                           options = list(searching = FALSE, ordering = TRUE, 
                                                                          pageLength = 25, dom = 't',
                                                                          columnDefs = list(
                                                                              list(
                                                                                  visible = FALSE, targets = columns2hide
                                                                              )
                                                                          )
                                                                          ),
                                                           selection = list(mode = 'single',
                                                                            target = 'cell'),
                                        width = "100%", height = "100%"),
                                    )
                           )
                capturaTorneo <<- noTabs
            }
            
            updateTabItems(session = session, inputId = "torneo", selected = "Final" )
        }
        
        output$mundialElegido <- renderText({
            paste0("Mundial de ",input$eligeMundial,
                   " jugado en ", infoElegido$Country)
             
        })
        
        output$imagenMundialElegido <- renderImage({
            list(
                src = paste0("www/",infoElegido$Country.Ab,".jpg"),
                width = "auto",
                height = "auto", deleteFile = FALSE
            )
        })
        
        
        
    })
    
    #------------------------INI: Estadisticas generales ------------------------------------
    output$totalGoles <- renderInfoBox({
        infoBox(
            "Total goles anotados", 
            formatC(sum(salidaGeneral$GoalsScored), format = "d", big.mark = "," ), 
            icon = icon("futbol", lib = "font-awesome"),
            color = "purple", 
            fill = TRUE
        )
    })
    
    output$totalJuegos <- renderInfoBox({
        infoBox(
            "Total juegos realizados", 
            formatC(sum(salidaGeneral$MatchesPlayed), format = "d", big.mark = "," ), 
            icon = icon("futbol", lib = "font-awesome"),
            color = "green", 
            fill = TRUE
        )
    })
    
    output$totalAsistentes <- renderInfoBox({
        infoBox(
            "Total aficionados", 
            formatC(sum(infoGeneral$Attendance), format = "d", big.mark = "," ), 
            icon = icon("fist-raised", lib = "font-awesome"),
            color = "orange", 
            fill = TRUE
        )
    })
    
    output$maximoGanadorMundiales <- renderInfoBox({
        infoBox(
            "Mas veces campeón", 
            paste0(masCampeon, " con ",
                   masFrecuencia," campeonatos"), 
            icon = icon("trophy", lib = "font-awesome"),
            color = "blue", 
            fill = TRUE
        )
    })
    
    output$masAficionados <- renderInfoBox({
        infoBox(
            "Mas aficionados en un mundial", 
            paste0(formatC(maxAttendance, format = "d", big.mark = "," ),
                   " en el mundial de ",
                   mundialMaxAttendance$Year,
                   " en ", mundialMaxAttendance$Country), 
            icon = icon("user-friends", lib = "font-awesome"),
            color = "lime", 
            fill = TRUE
        )
    })
    
    output$datosGenerales <- renderDataTable({
        
        salidaGeneral$Year <- paste0("<a href='",
                                     "http://", session$clientData$url_hostname,":",
                                     session$clientData$url_port,
                                     session$clientData$url_pathname,
                                     "?tab=infoXwc&",
                                     "wc=",salidaGeneral$Year,
                                     "' >",
                                     salidaGeneral$Year,"</a>")
        
        salidaGeneral %>% datatable( escape = FALSE, 
                                     options = list(searching = FALSE, ordering = TRUE, pageLength = 25),
                                     selection = list(mode = 'single',
                                                      target = 'cell'))
    })
    
    #------------------------INI: Lectura de parametros ------------------------------------    
    observe({
        
        query <- parseQueryString(session$clientData$url_search)
        
        tabs <- query[["tab"]]
        
        wc <- query[["wc"]]
        if(!is.null(tabs)){
            updateTabItems(session,"opciones",tabs)
            if (!is.null(wc)){
                updateSelectInput(session,"eligeMundial",selected = wc)
            }
        }
        # if(!is.null(bar_col)){
        #     updateSelectInput(session,"set_col",selected = bar_col)
        # }
        # browser()  <-----Para debuguear
    })
    
    #-----------------------FIN----------------------------------
    
})