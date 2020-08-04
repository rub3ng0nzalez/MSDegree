library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(
    dashboardHeader(title = "Algoritmos en la Ciencia de Datos"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Ceros", tabName = "Ceros"),
            menuItem("Derivación", tabName = "Derivacion")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem("Ceros",
                    h1("Método de Newton"),
                    box(textInput("ecuacion", "Ingrese la Ecuación"),
                        textInput("initVal", "X0"),
                        textInput("Error", "Error")),
                    actionButton("nwtSolver", "Newton Solver"),
                    tableOutput("salidaTabla")),
            
            tabItem("Derivacion",
                    h1("Diferencias Finitas centradas"),
                    box(textInput("difFinEcu", "Ingrese la Ecuación"),
                    textInput("valorX", "x0"),
                    textInput("valorH", "h")),
                    
                    # Copy the line below to make a select box 
                    selectInput("select", label = h4("Seleccione metodo a usar"), 
                                choices = list("Diferencias finitas centradas 1h" = 1,
                                               "Diferencias finitas progresivas" = 2, 
                                               "Diferencias finitas centradas 2h" = 3), 
                                selected = 1),
                    
                    hr(),
                    fluidRow(column(3, verbatimTextOutput("value"))),
                    
                    actionButton("diferFinEval", "Evaluar Derivada"),
                    textOutput("difFinitOut"),
                    actionButton("EvalTable", "Comparacion con derivada"))
        )
    )
)
