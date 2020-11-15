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
    titlePanel("Ejemplos UI dinamico"),
    tabsetPanel(
        tabPanel("Ejemplo1",
                 numericInput("min",
                              "Limite inferior",
                              value = 0),
                 numericInput("max",
                              "Limite superior",
                              value = 15),
                 sliderInput("slider_ej1","Seleccione intervalo",
                             min = 0,
                             max = 15,
                             value = 5)),
        tabPanel("Ejemplo2",
                 sliderInput("s1","s1",value = 0, min = -5, max = 5),
                 sliderInput("s2","s2",value = 0, min = -5, max = 5),
                 sliderInput("s3","s3",value = 0, min = -5, max = 5),
                 sliderInput("s4","s4",value = 0, min = -5, max = 5),
                 actionButton('clean','limpiar')
                 ),
        tabPanel("ejemplo 3",
                 numericInput("n","corridas", value = 10),
                 actionButton("correr","correr")
                 ),
        tabPanel("ejemplo 4",
                 numericInput("nvalue","valor",value = 0)
                 ),
        tabPanel("ejemplo 5",
                 numericInput("c","Temperatura en grados celcius", value = NULL),
                 numericInput("f","Temperatura en grados Farenheit", value = NULL)
                ),
        tabPanel("ejemplo 6",
                 selectInput("dist",
                             "Distribucion",
                             choices = c("normal","uniforme","exponencial")),
                 numericInput("nrandom",
                              "Numero de muestras",100),
                 tabsetPanel(id = "params", 
                             type = "hidden",
                             tabPanel("normal",
                                      numericInput("mean","Media",value = 0),
                                      numericInput("sd","Desviacion",value = 1)
                                      ),
                             tabPanel("uniforme",
                                      numericInput("min5","minimo",value = 0),
                                      numericInput("max5","maximo", value = 1)
                                      ),
                             tabPanel("exponencial",
                                      numericInput("taza","taza",value = 1, min = 0)
                                     )
                             ),
                 plotOutput("plot_dist")
                 )
    )

   
))
