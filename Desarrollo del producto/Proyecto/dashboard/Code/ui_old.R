

library(shiny)
library(leaflet)

navbarPage("Location of Blood Banks", id="main",
           tabPanel("Map", leafletOutput("bbmap", height=1000)),
           tabPanel("Data", DT::dataTableOutput("data")),
           tabPanel("Read Me",includeMarkdown("readme.md")))


# shinyUI(fluidPage(
# 
# 
#     titlePanel("Template"),
#     
#     sidebarLayout(
#         sidebarPanel(),
#         mainPanel(
#             textOutput('Texto')
#             #dataTableOutput('datos')
#         )
#     )
# ))
