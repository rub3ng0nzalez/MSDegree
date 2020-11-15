#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    observeEvent(input$min, {
        updateSliderInput(session,
                          inputId = "slider_ej1",
                          min = input$min)
    })
    
    observeEvent(input$max, {
        updateSliderInput(session,
                          inputId = "slider_ej1",
                          max = input$max)
    })
    
    
    observeEvent(input$clean,{
        updateSliderInput(session,
                          inputId = "s1",
                          value = 0)
        updateSliderInput(session,
                          inputId = "s2",
                          value = 0)
        updateSliderInput(session,
                          inputId = "s3",
                          value = 0)
        updateSliderInput(session,
                          inputId = "s4",
                          value = 0)
    })
    
    observeEvent(input$n,{
        msg <-paste0("Correr ", input$n, " veces")
        updateActionButton(session,
                           inputId = "correr",
                           label = msg)
    })
    
    observeEvent(input$nvalue,{
        updateNumericInput(session,
                           inputId = "nvalue",
                           value = input$nvalue + 1)
        
    })
    
    observeEvent(input$c,{
        f<- round(input$c * (9/5) + 32)
        updateNumericInput(session,
                           inputId = "f",
                           value = f)
    })
    
    observeEvent(input$f,{
        c<- round((input$f - 32) * 5/9)
        updateNumericInput(session,
                           inputId = "c",
                           value = c)
    })
    
    observeEvent(input$dist,{
        updateTabsetPanel(session,
                          input="params",
                          selected = input$dist
                          )
    })
    
    dist_sample <- reactive({
        switch(input$dist,
               "normal" = rnorm(input$nrandom, input$mean, input$sd),
               "uniforme" = runif(input$nrandom, input$min5, input$max5),
               "exponencial" = rexp(input$nrandom, rate = input$taza)
               )
    })
    
    output$plot_dist <- renderPlot({
        hist(dist_sample())
    })

})
