#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

i<-1

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    
    observe({
        
        query <- parseQueryString(session$clientData$url_search)
        
        bins <- query[["bins"]]
        
        bar_col <- query[["color"]]
        if(!is.null(bins)){
            bins <- as.integer(bins)
            updateSliderInput(session,"bins",value=bins)
        }
        if(!is.null(bar_col)){
            updateSelectInput(session,"set_col",selected = bar_col)
        }
        # browser()  <-----Para debuguear
    })
    
    
    observe({
        bins <- input$bins
        set_col <- input$set_col
        link_url <- paste0("http://", session$clientData$url_hostname,":",
                      session$clientData$url_port,
                      session$clientData$url_pathname,
                      "?bins=",bins,"&",
                      "color=",set_col)
        
        updateTextInput(session,"url",value = link_url)
        
        
    })
    

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = input$set_col, border = 'white')

    })

})
