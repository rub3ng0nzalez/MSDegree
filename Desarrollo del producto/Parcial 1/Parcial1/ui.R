#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(
    
    fluidPage(
        
        theme = shinytheme("sandstone"),
        
        # Application title
        titlePanel(h1("Parcial 1")),
        
        tabsetPanel(
            
            tabPanel('Detalles', 
                     icon = icon("people-carry", class = "font-awesome"),
                     h1('Integrantes'),
                     h4('Ruben Gonzalez - 20003314'),
                     h4('Vidal Baez - 20002076')
                     
            ),
            tabPanel('Estadisticas generales',
                     icon = icon("desktop", class = "font-awesome"),
                     valueBoxOutput("summ_vistas", width = 8)
            ),
            tabPanel('Estadisticas por indicador',
                     icon = icon("chart-bar", class = "font-awesome"),
                     
                     sidebarLayout(
                         sidebarPanel(
                             selectInput("stats",
                                         h4("Selecciona un indicador"),
                                         choices = c("Cantidad de vistas",
                                                     "Cantidad de likes","Cantidad de dislikes",
                                                     "Cantidad de favoritos", "Comentarios recibidos")
                             )
                             
                             
                         ),
                         mainPanel(
                             verbatimTextOutput("min_text"),
                             verbatimTextOutput("min"),
                             verbatimTextOutput("max_text"),
                             verbatimTextOutput("max"),
                             verbatimTextOutput("media_text"),
                             verbatimTextOutput("media"),
                             verbatimTextOutput("mediana_text"),
                             verbatimTextOutput("mediana")
                             
                         )
                     ),
                     plotOutput("plot_hist")
                     
            ),
            tabPanel('Tops',
                     icon = icon("award", class = "font-awesome"),
                     selectInput("indicador",
                                 h4("Selecciona un indicador"),
                                 choices = c("Cantidad de vistas",
                                             "Cantidad de likes","Cantidad de dislikes",
                                             "Cantidad de favoritos", "Comentarios recibidos")
                     ),
                     selectInput("masomenos",
                                 h4("Selecciona un tipo de filtro"),
                                 choices = c("TOP",
                                             "BOTTOM")
                     ),
                     selectInput("cantidad",
                                 h4("Selecciona una cantidad"),
                                 choices = c("5",
                                             "10","25","50","100")
                     ),
                     actionButton("buscar", label = "Buscar",
                                  icon = icon("search", class = "font-awesome")),
                     dataTableOutput('filtroTop')
            ),
            tabPanel('Datos',
                     dataTableOutput('datos')
            )
            
        )
    )
)
