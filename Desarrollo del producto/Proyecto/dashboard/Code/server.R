library(shiny)
library(leaflet)
library(dplyr)
library(lubridate)
library(DT)
library(RMySQL)

con <- dbConnect(MySQL(),user = 'usrmapa', password = 'prueba123', host ='db', port = 3306, dbname ='Mapamundi')
datos_covid <- dbGetQuery(con,'select * from casos_covid')

#datos_covid <- read.csv("Datos/casos_covid.csv", sep = ";", header = TRUE, encoding='latin-1')
df_covid <- as.data.frame(datos_covid)
df_covid <- na.omit(df_covid)
#df_covid$Fallecidos  <- format(as.integer(df_covid$Fallecidos) , nsmall=0, big.mark=",")


df_covid_fecha <- NULL
max_confirmados<- max(as.integer(df_covid$Confirmados))

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
    
    output$tabla_datos <- renderDataTable({
        datatable(filtro_data())
    })
    
})
