library(shiny)
library(leaflet)
library(dplyr)
library(lubridate)
library(DT)
library(ggplot2)
library(scales)
library(plotly)
library(RMySQL)

con <- dbConnect(MySQL(),user = 'usrmapa', password = 'prueba123', host ='db', port = 3306, dbname ='Mapamundi')
datos_covid <- dbGetQuery(con,'select * from casos_covid')

query.tops <- 'select Pais, sum(Confirmados) as suma_Confirmados, sum(Recuperados) as suma_Recuperados, sum(Fallecidos) as suma_Fallecidos '
query.tops <-paste0(query.tops,'from casos_covid group by Pais')

datos_tops <- dbGetQuery(con,query.tops)


#datos_covid <- read.csv("Datos/casos_covid.csv", sep = ";", header = TRUE, encoding='latin-1')
df_covid <- as.data.frame(datos_covid)
df_covid <- na.omit(df_covid)


df_covid_fecha <- NULL
max_confirmados<- max(as.integer(df_covid$Confirmados))
total_confirmados_fecha <- sum(as.integer(df_covid$Confirmados))

shinyServer(function(input, output, session) {
    
    filtro_data <- reactive({
        
        #fecha_filtro <- paste0(day(input$fecha_fil),'/',month(input$fecha_fil),'/',year(input$fecha_fil))
        #fecha_filtro <- as.character(input$fecha_fil)
        
        
        if(input$pais_fil == 'TODOS'){
            datos_filtrados<- df_covid %>%
                filter(Fecha == as.character(input$fecha_fil))
            
            return(datos_filtrados)
        }
        else
        {
            datos_filtrados<- df_covid %>%
                filter(Fecha == as.character(input$fecha_fil), Pais == input$pais_fil)
            
            return(datos_filtrados)
        }
        
        
    })
    
    RV <- reactiveValues(data = NULL)
    nombresColumnas <-function(nombre) {
        salida = ''
        if(nombre == 'Cantidad de casos confirmados')
            salida = RV$data$suma_Confirmados
        else if (nombre == 'Cantidad de casos recuperados')
            salida = RV$data$suma_Recuperados
        else if (nombre == 'Cantidad de fallecidos')
            salida = RV$data$suma_Fallecidos
        
        return(salida)
    }
    
    observe({
        
        leafletProxy("mapa", data = filtro_data()) %>% 
            clearShapes()  %>%
            #setView(lat = ~Latitud, lng = ~Longitud, zoom = 5) %>%
            addCircles(lng = ~Longitud,
                       lat = ~Latitud,
                       radius = ~log(as.integer(Confirmados)) * 50000,
                       weight = 1,
                       opacity = 1,
                       color = ~ifelse(Confirmados > 0, reds(Confirmados), NA),
                       popup = ~paste(sep = "<br/>",
                                      paste0("<b>Pais: </b>", Pais),
                                      paste0("<b>Estado: </b>", Estado),
                                      paste0("<b>Casos confirmados : </b>", format(Confirmados, nsmall=0, big.mark=",")),
                                      paste0("<b>Recuperados : </b>", format(Recuperados, nsmall=0, big.mark=",")),
                                      paste0("<b>Muertes : </b>", format(Fallecidos, nsmall=0, big.mark=","))
                       )
            )
        
    }) 
    
    data_fecha <- reactive({
        
        datos_cov<- df_covid %>%
            filter(Fecha == as.character(input$fecha_fil))
        
        return(datos_cov)
    })
    
    observe({
        
        pa<-factor(df_covid$Pais)
        paises <-levels(pa)
        tod <- c("TODOS")
        t_paises <- cbind(paises,tod)
        
        updateSelectInput(session,"pais_fil",
                          choices = t_paises,
                          selected = "TODOS")
    })
    
    observe({
        
        df_covid_fecha <<- data_fecha()
        max_confirmados<<- max(as.integer(df_covid_fecha$Confirmados))
        total_confirmados_fecha <- sum(as.integer(df_covid_fecha$Confirmados))
        
    })
    
    vb_confirmados <- reactive({
        
        
    })
    
    calc_datos_grafico <- reactive({
        
        if(input$pais_fil == 'TODOS'){
            datos_filtrados<- df_covid %>%
                group_by(Fecha) %>% 
                summarize(Confirmados = sum(Confirmados, na.rm = TRUE),
                          Recuperados = sum(Recuperados, na.rm = TRUE),
                          Fallecidos = sum(Fallecidos, na.rm = TRUE)
                          )
            
            datos_piv <- datos_filtrados %>%
                pivot_longer(Confirmados:Fallecidos, names_to = "Casos", values_to = "Cantidad")
            
            return(datos_piv)
        }
        else
        {
            datos_filtrados<- df_covid %>%
                filter(Pais == input$pais_fil) %>% 
                group_by(Fecha) %>% 
                summarize(Confirmados = sum(Confirmados, na.rm = TRUE),
                          Recuperados = sum(Recuperados, na.rm = TRUE),
                          Fallecidos = sum(Fallecidos, na.rm = TRUE)
                )
            
            datos_piv <- datos_filtrados %>%
                pivot_longer(Confirmados:Fallecidos, names_to = "Casos", values_to = "Cantidad")
            
            return(datos_piv)
        }
        
        
    })
    
    reds <- colorNumeric(c("green", "yellow", "orange", "red"), domain = range(0,max_confirmados))
    
    output$mapa <- renderLeaflet({
        
        leaflet(data_fecha(), options = leafletOptions(minZoom = 1, maxZoom = 18, worldCopyJump = T)) %>% 
            setView(lat = 0, lng = 0, zoom = 4) %>%
            addProviderTiles(providers$CartoDB.Positron,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            fitBounds(lng1 = ~min(Longitud), 
                      lat1 = ~min(Latitud), 
                      lng2 = ~max(Longitud), 
                      lat2 = ~max(Latitud)) %>%
            addLegend("bottomleft", pal = reds, values = ~Confirmados,
                      title = "Casos Confirmados",
                      opacity = 1,
                      bins = 6
            )
    })
    
    output$casos_confirmados <- renderValueBox({
        
        vb_datos <- filtro_data()
        valor <- format(sum(vb_datos$Confirmados), nsmall=0, big.mark=",")
        
        valueBox(
            valor, 
            "Confirmados",
            icon("stats",lib='glyphicon'),
            color = "red",
            width = 12)
        
    })
    
    output$casos_recuperados <- renderValueBox({
        
        vb_datos <- filtro_data()
        valor <- format(sum(vb_datos$Recuperados), nsmall=0, big.mark=",")
        
        valueBox(
            valor, 
            "Recuperados",
            icon("stats",lib='glyphicon'),
            color = "blue",
            width = 12)
        
    })
    
    output$casos_fallecidos <- renderValueBox({
        
        vb_datos <- filtro_data()
        valor <- format(sum(vb_datos$Fallecidos), nsmall=0, big.mark=",")
        
        valueBox(
            valor, 
            "Fallecidos",
            icon("stats",lib='glyphicon'),
            color = "purple",
            width = 12)
        
    })
    
    output$filtro_p <- renderInfoBox({
        
        infoBox(input$pais_fil,
                title = NULL,
                width = 12
        )
    })
    
    output$plot_evolucion <- renderPlotly({
        datos_grafico <- calc_datos_grafico()
        
        datos_grafico$Fecha <- as.Date(datos_grafico$Fecha, "%Y-%m-%d")
        datos_grafico$Cantidad <- as.numeric(datos_grafico$Cantidad)
        
        casos_plot <- ggplot(datos_grafico, aes(Fecha, Cantidad)) + 
            geom_line( aes(col = Casos), size = 1) + 
            xlab("Fecha") + ylab("Numero de Casos") + 
            scale_x_date(labels = date_format(format= "%b-%Y"),breaks = date_breaks("1 month")) +
            scale_y_continuous(labels = comma)+
            #scale_fill_manual(values=c("darkred","steelblue", "black"))+
            scale_color_manual(values=c("darkred", "black", "steelblue")) +
            theme_light()
        
        fig <- ggplotly(casos_plot)
        
        fig

        
    })
    
    output$tabla_datos <- renderDataTable({
        datatable(filtro_data())
        #datatable(calc_datos_grafico())
    })
    
    
    #------------------Tab de datos Top------------------------------------------
    
    observeEvent(input$buscar, {
        RV$data <- datos_tops
        
        if (input$masomenos =="BOTTOM")
            RV$data <- RV$data %>% slice_min(nombresColumnas(input$indicador), n = as.numeric(input$cantidad))
        else
            RV$data <- RV$data %>% slice_max(nombresColumnas(input$indicador), n = as.numeric(input$cantidad))
        
        
    })
    
    output$filtroTop <-renderDataTable({
        #RV$data$suma_Confirmados <- RV$data$suma_Confirmados %>% formatC(format = "d", big.mark = "," )
        #RV$data$suma_Recuperados <- RV$data$suma_Recuperados %>% formatC(format = "d", big.mark = "," )
        #RV$data$suma_Fallecidos <- RV$data$suma_Fallecidos %>% formatC(format = "d", big.mark = "," )
        RV$data %>% datatable(escape = FALSE, options = list(searching = FALSE, ordering = FALSE))
    })
    
    output$bar <- renderPlot( {
        #   graficos <- RV$data %>% select("suma_Confirmados")
        
        if(!is.null(RV$data$suma_Confirmados)){
            barplot(RV$data$suma_Confirmados, col = rgb(0.2,0.4,0.6,0.6) )
        }
        
    }) 
    
})
