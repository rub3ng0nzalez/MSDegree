

library(shiny)

shinyUI(fluidPage(


    titlePanel("Template"),
    
    sidebarLayout(
        sidebarPanel(),
        mainPanel(
            textOutput('Texto')
            #dataTableOutput('datos')
        )
    )
))
