#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),
    tabsetPanel(
        tabPanel("Plot",
                 h1("Graficas en Shiny"),
                 h2("Grafica con base de R"),
                 plotOutput("grafica_base_r"),
                 h2("Grafica con ggplot"),
                 plotOutput("grafica_ggplot"),
                 ),
        tabPanel("Plot user Interactions",
                 plotOutput("plot_click_options",
                            click = 'clk',
                            dblclick = "dclk",
                            hover = "mhover",
                            brush = "mbrush"),
                 verbatimTextOutput("click_data"),
                 tableOutput("mtcars_tbl"))
    )
))
