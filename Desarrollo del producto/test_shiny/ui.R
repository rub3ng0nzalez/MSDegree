#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Inputs en Shiny"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("Slider_input",
                        "Seleccione valor",
                        min = 0,
                        max = 100,
                        value = 50,
                        step = 10,
                        post = '%', animate = TRUE),
            sliderInput("Slider_input2",
                        "Seleccione un rango",
                        min = 0,
                        max = 200,
                        value = c(0,200),
                        step = 10,
                        animate = TRUE),
            selectInput("select_input", "Seleccione un auto:",
                        choices = rownames(mtcars),
                        selected = "Camaro Z28",
                        multiple = FALSE),
            selectizeInput("select_input2","Seleccione autos:",
                           choices = rownames(mtcars),
                           selected = "Camaro Z28",
                           multiple = TRUE),
            dateInput('date_input',"Ingrese la fecha:",
                      value = today(),
                      min = today() - 60,
                      max = today() + 30,
                      language = 'es',
                      weekstart = 1),
            dateRangeInput('date_range','Ingrese Fechas',
                           start = today() - 7,
                           end = today(),
                           separator = 'a'),
            numericInput('numeric_input', 'Ingrese un numero: ', value = 10, 
                         min = 0, max = 100, step = 1),
            checkboxInput('single_box','Seleccione si verdadero:', value = FALSE),
            checkboxGroupInput('group_box','Seleccione opciones:',
                               choices = LETTERS[1:5]),
            radioButtons('radio_buttons','Seleccione Genero:', choices = c('masculino','femenino'),
                         selected = 'masculino'),
            textInput('text_input','Ingrese texto:'),
            textAreaInput('text_area','Ingrese párrafo:'),
            actionButton('action_button','ok'),
            actionLink('action_link','Siguiente'),
            submitButton(text = "reprocesar")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h2("Slider input sencillo"),
            verbatimTextOutput("slider_io"),
            h2("Slider input rango"),
            verbatimTextOutput("slider_io2"),
            h2("Select input"),
            verbatimTextOutput("select_input_text"),
            h2("Select input multiple"),
            verbatimTextOutput("select_input_text2"),
            h2("Fecha"),
            verbatimTextOutput("date_input_text"),
            h2("Rango de fechas"),
            verbatimTextOutput("daterange_input_text"),
            h2("Numeric Input"),
            verbatimTextOutput("numeric_input_text"),
            h2("Single Checkbox"),
            verbatimTextOutput("singlebox_input_text"),
            h2("Grouped Checkbox"),
            verbatimTextOutput("groupbox_input_text"),
            h2("Radio Buttons"),
            verbatimTextOutput("radio_buttons_input_text"),
            h2("Texto"),
            verbatimTextOutput("text_input_text"),
            h2("Párrafo"),
            verbatimTextOutput("textarea_input_text"),
            h2("Action Button"),
            verbatimTextOutput("actionButton_input_text"),
            h2("Action Link"),
            verbatimTextOutput("actionLink_input_text")
            #plotOutput("distPlot")
        )
    )
))
