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
library(DT)
library(ggplot2)
library(plotly)

con2 <- dbConnect(MySQL(),user = 'usrmapa', password = 'prueba123', host ='db', port = 3306, dbname ='Mapamundi')
datos_covid <- dbGetQuery(con2,'select * from casos_covid')

#datos_covid <- read.csv("Datos/casos_covid.csv", sep = ";", header = TRUE, encoding='latin-1')

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
                menuItem("Tops", tabName = "tops", icon = icon("award", class = "font-awesome")),
                menuItem("About", tabName = "about", icon = icon("info-circle"))
            )
        ), 
        dashboardBody(
            shinyDashboardThemes(
                theme = "poor_mans_flatly"
            ),
            
            tabItems(
                #DASHBOARD CASOS
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
                        #leafletOutput("mapa"),
                        
                        box(
                            title = "Mapa", status = "primary",
                            width = 8,
                            leafletOutput("mapa"),
                        ),
                        box(title = "Indicadores",  status = "primary", width = 4,
                            fluidRow(
                                infoBoxOutput(width = 12, outputId = "filtro_p"),
                                valueBoxOutput(width = 12, outputId = "casos_confirmados"),
                                valueBoxOutput(width = 12, outputId = "casos_recuperados"),
                                valueBoxOutput(width = 12, outputId = "casos_fallecidos")
                            )
                            
                        )
                    ),
                    
                    h2("Tabla de datos"),
                    fluidRow(
                        dataTableOutput("tabla_datos")
                    ),
                    
                    h2("Evolucion de casos a lo largo del tiempo"),
                    fluidRow(
                        plotlyOutput("plot_evolucion")
                    )
                    
                ),
                
                #TOPS
                tabItem(
                    tabName = 'tops',
                    selectInput("indicador",
                                h4("Selecciona un indicador"),
                                choices = c("Cantidad de casos confirmados",
                                            "Cantidad de casos recuperados","Cantidad de fallecidos")
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
                    plotOutput("bar"),
                    dataTableOutput('filtroTop')
                ),
                
                #ABOUT
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
