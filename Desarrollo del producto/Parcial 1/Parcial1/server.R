#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library("RMySQL")
library(DT)
library(dplyr)
library(ggplot2)
library(shinydashboard)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    con <- dbConnect(MySQL(),user = 'root', password = 'password', host ='parcial1_db_1', port = 3306, dbname ='videos')
    datos <- dbGetQuery(con,'select m.*, v.published_date, s.viewCount, s.likeCount, s.dislikeCount, s.favoriteCount, s.commentCount
                        from video_metadata m join video_data v on m.video_id=v.video_id
                        join video_stats s on m.video_id = s.video_id')
    
    parafiltros <- datos %>% select(c("video_id","title","published_date","viewCount","likeCount",
                                      "dislikeCount","favoriteCount", "commentCount"))
    
    parafiltros$video_id <- paste0("<a href='https://www.youtube.com/watch?v=", parafiltros$video_id ,
                                   "' target='_blank'>Ver video</a>")
    
    
    
    RV <- reactiveValues(data = parafiltros)
    
    nombresColumnas <-function(nombre) {
        salida = ''
        if(nombre == 'Cantidad de vistas')
            salida = 'viewCount'
        else if (nombre == 'Cantidad de likes')
            salida = 'likeCount'
        else if (nombre == 'Cantidad de dislikes')
            salida = 'dislikeCount'
        else if (nombre == 'Cantidad de favoritos')
            salida = 'favoriteCount'
        else if (nombre == 'Comentarios recibidos')
            salida = 'commentCount'
        
        return(salida)
    }
    
    filtrosColumnas <-function(nombre) {
        salida = ''
        if(nombre == 'Cantidad de vistas')
            salida = RV$data$viewCount
        else if (nombre == 'Cantidad de likes')
            salida = RV$data$likeCount
        else if (nombre == 'Cantidad de dislikes')
            salida = RV$data$dislikeCount
        else if (nombre == 'Cantidad de favoritos')
            salida = RV$data$favoriteCount
        else if (nombre == 'Comentarios recibidos')
            salida = RV$data$commentCount
        
        return(salida)
    }
    
    #-------------------tab de Estadisticas generales
    output$summ_vistas <- renderValueBox({
        valueBox(sum(parafiltros$viewCount),"Vistas",
                 icon = icon("eye"),
                 color = "blue"
        )
    })
    
    #-----------------tab de Estadisticas por indicador-----------------
    
    output$min_text <- renderText({
        paste0('Menor ',input$stats)
    })
    
    output$min <- renderText({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        min(Columna)
        
    })
    
    output$max_text <- renderText({
        paste0('Mayor ',input$stats)
    })
    
    output$max <- renderText({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        max(Columna)
        
    })
    
    output$media_text <- renderText({
        paste0('La media de ',input$stats)
    })
    
    output$media <- renderText({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        round(mean(Columna[[1]]), digits = 0)
        
    })
    
    output$mediana_text <- renderText({
        paste0('La mediana de ',input$stats)
    })
    
    output$mediana <- renderText({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        median(Columna[[1]])
        
    })
    
    output$plot_hist <- renderPlot({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        hist(x = Columna[[1]], main =paste0("Histograma de distribución ",input$stats), 
             xlab=input$stats, col = "chocolate")
    })
    
    
    #------------------Tab de datos Top
    observeEvent(input$buscar, {
        #browser()
        RV$data <- parafiltros
        #browser()
        if (input$masomenos =="BOTTOM")
            RV$data <- RV$data %>% slice_min(filtrosColumnas(input$indicador), n = as.numeric(input$cantidad))
        else
            RV$data <- RV$data %>% slice_max(filtrosColumnas(input$indicador), n = as.numeric(input$cantidad))
        
        #RV$data <- RV$data %>% arrange(RV$data$published_date)
        #browser()
        
    })
    
    output$filtroTop <-renderDataTable({
        RV$data %>% datatable(escape = FALSE, options = list(searching = FALSE, ordering = FALSE))
    })
    #------------------Tab de datos
    output$datos <-renderDataTable({
        parafiltros %>% datatable(escape = FALSE)
    })
    
})
