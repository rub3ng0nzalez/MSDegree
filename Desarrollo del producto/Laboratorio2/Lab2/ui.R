library(shiny)
library(DT)

shinyUI(fluidPage(
    
    
    titlePanel("Laboratorio 2 Ruben Gonzalez"),
    
    tabsetPanel(
        
    
    tabPanel('Tarea',
             plotOutput('plot_tarea',
                        click = 'click_plot_tarea',
                        dblclick = 'dblclck_plot_tarea',
                        hover = 'hover_plot_tarea',
                        brush = brushOpts(id = 'brush_plot_tarea', resetOnNew = FALSE)
             ),
             dataTableOutput('tarea_dt')
    )
    )
    
))