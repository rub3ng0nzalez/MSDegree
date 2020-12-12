#Curso: Product Development
#Integrantes:
#	Lilian Rebeca Carrera Lemus
#	Jose Armando Barrios Leon
#   Ruben Gonzales
#   Vidal Baenz
#Tarea: Proyecto Final COVID

library(shiny)
library(leaflet)
library(shinythemes)
library(dashboardthemes)
library(shinydashboard)

datos_covid <- read.csv("Datos/casos_covid.csv", sep = ";", header = TRUE, encoding='latin-1')
df_covid <- as.data.frame(datos_covid)
df_covid <- na.omit(df_covid)

shinyUI(
    
    dashboardPage(
        #Header
        dashboardHeader(
            title = shinyDashboardLogo(
                theme = "poor_mans_flatly",
                boldText = "Mapa",
                mainText = "COVID",
                badgeText = "19"
            )
        ),
        #Sidebar
        dashboardSidebar(
            sidebarMenu(
                menuItem("Mapa", tabName = "dashboard", icon = icon("map")),
                menuItem("About", tabName = "about", icon = icon("info-circle"))
            )
        ), 
        dashboardBody(
            shinyDashboardThemes(
                theme = "poor_mans_flatly"
            ),
            
            tabItems(
                # Primera tab de dashboard
                tabItem(
                    tabName = "dashboard",
                    
                    h2("Mapa de casos"),
                    fluidRow(
                        column(
                            4,
                            dateInput(
                                "fecha_fil",
                                "Fecha",
                                value = max(as.character(df_covid$Fecha)),
                                min = min(as.character(df_covid$Fecha)),
                                max = max(as.character(df_covid$Fecha)),
                                format = 'dd/mm/yyyy',
                                language = 'es',
                                weekstart = 1
                            )
                        ), 
                        column(
                            4, 
                            selectInput(
                                "pais_fil",
                                "Pais",
                                choices = "TODOS",
                                selected = "TODOS",
                                multiple = FALSE
                            )
                        )
                    ),
                    fluidRow(
                        leafletOutput("mapa")
                    ),
                    
                    h2("Tabla de datos"),
                    fluidRow(
                        dataTableOutput("tabla_datos")
                    )
                    
                ),
                
                # Segunda tab de tabla de data sin filtrar
                tabItem(
                    tabName = "about",
                    
                    h1("About"), 
                    h2("Curso"), 
                    p("Universidad Galileo"),  
                    p("Maestria en Data Science"),
                    p("Product Development - 2020"),
                    p("Proyecto FInal"),
                    
                    h2("Integrantes"), 
                    p("Lilian Rebeca Carrera Lemus"), 
                    p("Ruben Dario Gonzalez Monterroso"), 
                    p("Vidal Baez Fortunato"), 
                    p("Jose Armando Barrios Leon")
                )
            )
        )
    )
)
