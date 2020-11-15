#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$grafica_base_r <- renderPlot({
        plot(mtcars$wt, mtcars$mpg, xlab = "Peso del vehiculo", ylab = "Millas por galon")
        
    })
    
    output$grafica_ggplot <- renderPlot({
        diamonds %>% 
            sample_n(10000) %>%
            ggplot(aes(x=carat, y = price, color = color)) +
            geom_point()+
            ylab("precio") +
            xlab("Kilates")+
            ggtitle("Precio de diamantes por kilate")
        
    })
    
    
    
    
    
    
    
    output$plot_click_options <- renderPlot({
        plot(mtcars$wt, mtcars$mpg, xlab = "Peso del vehiculo", ylab = "Millas por galon")
    })
    
    output$click_data <- renderPrint({
        if(!is.null(input$clk$x)){
            clk_msg <- paste0("Click coordenada x = ", round(input$clk$x,2),
                              " Click coordenada y = ", round(input$clk$y,2))
            print(clk_msg)
        }
        
        if(!is.null(input$dclk$x)){
            dclk_msg <- paste0("Doble click coordenada x = ", round(input$dclk$x,2),
                              " Doble click coordenada y = ", round(input$dclk$y,2))
            print(dclk_msg)
        }
        
        if(!is.null(input$mhover$x)){
            mhover_msg <- paste0("Hover coordenada x = ", round(input$mhover$x,2),
                              " Hover coordenada y = ", round(input$mhover$y,2))
            print(mhover_msg)
        }
        
        if(!is.null(input$mbrush$xmin)){
            brushx <- paste0("(", input$mbrush$xmin,',',input$mbrush$xmax,")")
            brushy <- paste0("(", input$mbrush$ymin,',',input$mbrush$ymax,")")
            mbrush <- cat("rango en x:", brushx, "\n",
                          "rango en y:", brushy, "\n")
            
            cat(mbrush)
        }
    })
    
    output$mtcars_tbl <- renderTable({
        mtcars_df <- cbind(carname = row.names(mtcars),mtcars)
        df <- nearPoints(mtcars_df, input$clk, xvar = 'wt', yvar = 'mpg')
        df <- brushedPoints(mtcars_df, input$mbrush, xvar ="wt", yvar = "mpg")
        if(nrow(df) != 0){
            df
        }
        else
        {
            NULL
        }
    })

})
