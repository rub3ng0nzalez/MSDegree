library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

out_click<- mtcars
out_hover<-NULL
acumula <- 0

shinyServer(function(input, output) {
    
    
    
    
    click_points <- reactive({
        
       
        
        if(!is.null(out_hover)){
            points(out_hover[,1],out_hover[,2],
                   col='gray',
                   pch=20)}
        if(!is.null(out_click)){
            points(out_click[,1],out_click[,2],
                   col='green',
                   pch=20)}
        
        
        
        if(!is.null(input$click_plot_lab2$x)){
            df<-nearPoints(mtcars,input$click_plot_lab2,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            if (acumula ==0)
            {
                out_click <<- out
            }
            else
            {
                out_click <<- rbind(out_click,out) %>% distinct()
            }
            
            acumula <<- acumula + 1
            return(out_click)
        }
        if(!is.null(input$hover_plot_lab2$x)){
            df<-nearPoints(mtcars,input$hover_plot_lab2,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_hover <<- out
            return(out_hover)
        }
        
        if(!is.null(input$dblclck_plot_lab2$x)){
            df<-nearPoints(mtcars,input$dblclck_plot_lab2,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_click <<- setdiff(out_click,out)
            acumula <<- acumula - 1
            return(out_click)
        }
        
        if(!is.null(input$brush_plot_lab2)){
            df<-brushedPoints(mtcars,input$brush_plot_lab2,xvar='wt',yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            
            if (acumula ==0)
            {
                out_click <<- out
            }
            else
            {
                out_click <<- rbind(out_click,out) %>% distinct()
            }
            
            acumula <<- acumula + length(df)
            return(out_click)
        }
        
        
        
        
        
    })
    
    
    click_table <- reactive({
    
        
        input$click_plot_lab2$x
        input$dblclck_plot_lab2$x
        input$brush_plot_lab2
        input$hover_plot_lab2$x
        
    })
    
    
    output$plot_lab2 <- renderPlot({
        plot(mtcars$wt,mtcars$mpg,xlab="wt",ylab="Millas por Galon")
        click_points()
        
    })
    
    
    output$tarea_dt <- renderDataTable({
        
        click_table()
        out_click %>% datatable(style = "bootstrap")
        
    })
    
    
})