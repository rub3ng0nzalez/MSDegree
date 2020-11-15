library(shiny)

shinyUI(fluidPage(
    titlePanel("Interactive Plot"),
    
    tabsetPanel(
        tabPanel('Plot User Interactions', 
                 h2("Grafico interactivo"), 
                 plotOutput('plot_click_options', 
                            click = 'clk', 
                            dblclick = 'dclk', 
                            hover = 'mhover', 
                            brush = 'mbrush'), 
                 h2("Acciones detectadas"),
                 verbatimTextOutput('click_data'), 
                 h2("Seleccion realizada"),
                 DT::dataTableOutput('tabla_mtcars')
        )
    )
))