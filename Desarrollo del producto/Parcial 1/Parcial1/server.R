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
library("dplyr")
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
    
    parafiltros$published_date <- parafiltros$published_date %>% as.Date()
    
    RV <- reactiveValues(data = NULL)
    RV_datos <- reactiveValues(data = NULL)
    
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
        valueBox(formatC(sum(parafiltros$viewCount), format = "d", big.mark = "," ),
                 "Vistas",
            icon = icon("eye"),
            color = "blue"
        )
    })
    
    output$summ_likes <- renderValueBox({
        valueBox(formatC(sum(parafiltros$likeCount), format = "d", big.mark = "," ),
                 "Likes",
                 icon = icon("thumbs-up"),
                 color = "blue"
        )
    })
    
    output$summ_dislikes <- renderValueBox({
        valueBox(formatC(sum(parafiltros$dislikeCount), format = "d", big.mark = "," ),
                 "Dislikes",
                 icon = icon("thumbs-down"),
                 color = "blue"
        )
    })
    
    output$summ_favorites <- renderValueBox({
        valueBox(formatC(sum(parafiltros$favoriteCount), format = "d", big.mark = "," ),
                 "Favoritos",
                 icon = icon("heart"),
                 color = "blue"
        )
    })
    
    output$summ_comments <- renderValueBox({
        valueBox(formatC(sum(parafiltros$commentCount), format = "d", big.mark = "," ),
                 "Comentarios",
                 icon = icon("comments"),
                 color = "blue"
        )
    })
    #-----------------tab de Estadisticas por indicador-----------------
    
    output$min_text <- renderText({
        paste0('Menor ',input$stats)
    })
    
    output$min <- renderText({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        formatC( min(Columna), format = "d", big.mark = "," )
        
    })
    
    output$max_text <- renderText({
        paste0('Mayor ',input$stats)
    })
    
    output$max <- renderText({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        formatC(max(Columna), format = "d", big.mark = "," )
        
    })
    
    output$media_text <- renderText({
        paste0('La media de ',input$stats)
    })
    
    output$media <- renderText({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        formatC(round(mean(Columna[[1]]), digits = 0), format = "d", big.mark = "," )
        
    })
    
    output$mediana_text <- renderText({
        paste0('La mediana de ',input$stats)
    })
    
    output$mediana <- renderText({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        formatC(median(Columna[[1]]), format = "d", big.mark = "," )
        
    })
    
    output$plot_hist <- renderPlot({
        Columna <- parafiltros %>% select(nombresColumnas(input$stats))
        hist(x = Columna[[1]], main =paste0("Histograma de distribución ",input$stats), 
             xlab=input$stats, col = "blue", border = "black")
    })
    
    
    #------------------Tab de datos Top------------------------------------------
    observeEvent(input$buscar, {
        RV$data <- parafiltros
        if (input$masomenos =="BOTTOM")
            RV$data <- RV$data %>% slice_min(filtrosColumnas(input$indicador), n = as.numeric(input$cantidad))
        else
            RV$data <- RV$data %>% slice_max(filtrosColumnas(input$indicador), n = as.numeric(input$cantidad))
        
    })
    
    output$filtroTop <-renderDataTable({
        RV$data %>% datatable(escape = FALSE, options = list(searching = FALSE, ordering = FALSE))
    })
    
    #------------------Tab de datos------------------------------------------
    observeEvent(input$buscar_datos, {
        RV_datos$data <- parafiltros
        #browser()
        RV_datos$data <- filter(RV_datos$data, between(RV_datos$data$published_date, left = as.Date(input$date_range[1]), right = as.Date(input$date_range[2])))
        
    })
    
    fecha_minima <- as.Date(min(parafiltros$published_date))
    fecha_maxima <- as.Date(max(parafiltros$published_date))
    
    observe({
        updateDateRangeInput(session, "date_range", 
                             min = fecha_minima, start = fecha_minima,
                             max = fecha_maxima, end = fecha_maxima)
    })
    
    output$datos <-renderDataTable({
        RV_datos$data %>% datatable(escape = FALSE, options = list(searching = FALSE))
    })

})
