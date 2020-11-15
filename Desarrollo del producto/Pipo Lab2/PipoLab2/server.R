library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

shinyServer(function(input, output) {
    #Cargar datos a la grafica
    #Tambien se capturan las acciones del usuario para cambiar el color a ciertos puntos
    output$plot_click_options = renderPlot({
        plot = ggplot(mtcars, 
                      aes(wt, mpg)) + 
            geom_point(size = 3) + 
            ylab("Millas por galon") + 
            xlab("Peso ") + 
            ggtitle("Rendimiento por peso de vehiculo") + 
            theme_minimal()
        
        if(!is.null(input$mbrush$xmin)) {
            df = brushedPoints(mtcars, input$mbrush, xvar = 'wt', yvar = 'mpg')
            if(nrow(df) != 0) {
                plot = plot +
                    geom_point(data = df,
                               aes(wt, mpg),
                               color = 'red', 
                               size = 4)
            }
        }
        else if(!is.null(input$clk$x)) {
            df = nearPoints(mtcars, input$clk, xvar = 'wt', yvar = 'mpg')
            
            if(nrow(df) != 0) {
                plot = plot +
                    geom_point(data = df,
                               aes(wt, mpg),
                               color = 'green',
                               size = 4)
            }
        }
        
        else if(!is.null(input$dclk$x)) {
            df = nearPoints(mtcars, input$dclk, xvar = 'wt', yvar = 'mpg')
            
            if(nrow(df) != 0) {
                plot = plot +
                    geom_point(data = df,
                               aes(wt, mpg),
                               color = 'black',
                               size = 4)
            }
        }
        
        else if(!is.null(input$mhover$x)) {
            df = nearPoints(mtcars, input$mhover, xvar = 'wt', yvar = 'mpg')
            
            if(nrow(df) != 0) {
                plot = plot +
                    geom_point(data = df,
                               aes(wt, mpg),
                               color = 'gray',
                               size = 4)
            }
        }
        
        plot
    })
    
    #Mostrar mensajes de acciones realizadas en el control de print
    output$click_data = renderPrint({
        if(!is.null(input$clk$x)) {
            clk_msg = paste0("Click en (", 
                             round(input$clk$x, 2), 
                             ", ",
                             round(input$clk$y, 2), 
                             ")")
            print(clk_msg)
        }
        if(!is.null(input$dclk$x)) {
            dclk_msg = paste0("Doble click en (", 
                              round(input$dclk$x, 2), 
                              ", ",
                              round(input$dclk$y, 2), 
                              ")")
            print(dclk_msg)
        }
        
        if(!is.null(input$mhover$x)) {
            hover_msg = paste0("Hover en (", 
                               round(input$mhover$x, 2), 
                               ", ",
                               round(input$mhover$y, 2), 
                               ")")
            print(hover_msg)
        }
        
        if(!is.null(input$mbrush$xmin)) {
            brusx = paste0("(", input$mbrush$xmin, ", ", input$mbrush$xmax, ")")
            brusy = paste0("(", input$mbrush$ymin, ", ", input$mbrush$ymax, ")")
            mbrush = cat("Area seleccionada \nX: ", brusx, "\n", 
                         "Y: ", brusy)
            print(mbrush)
        }
    })
    
    #Mostrar datos de los carros seleccionados, ya sea por click o brush
    output$tabla_mtcars = DT::renderDataTable({
        df_click = nearPoints(mtcars, input$clk, xvar = 'wt', yvar = 'mpg')
        df_brush = brushedPoints(mtcars, input$mbrush, xvar = 'wt', yvar = 'mpg')
        
        if(nrow(df_click) != 0) {
            df_click
        }
        else if(nrow(df_brush) != 0) {
            df_brush
        }
        else {
            NULL
        }
    })
    
    
})