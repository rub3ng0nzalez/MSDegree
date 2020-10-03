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
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })
    
    output$slider_io <- renderText({
        paste0( c('Output Slider input: ', input$Slider_input), collapse = '')
    })
    
    output$slider_io2 <- renderText({
        input$Slider_input2
    })
    
    output$select_input_text <- renderText({
        input$select_input
    })
    
    output$select_input_text2 <- renderText({
        paste0( c('Seleccciones del UI: ', paste0(input$select_input2, collapse = ", ")), 
                collapse = '')
    })
    
    output$date_input_text <- renderText({
        as.character(input$date_input)
    })
    
    output$daterange_input_text <- renderText(
        expr = as.character(input$date_range), sep = ' a '
    )
    
    output$numeric_input_text <- renderText({
        input$numeric_input
    })
    
    output$singlebox_input_text <- renderText({
        input$single_box
    })
    
    output$groupbox_input_text <- renderText({
        input$group_box
    })
    
    output$radio_buttons_input_text <- renderText({
        input$radio_buttons
    })
    
    output$text_input_text <- renderText({
        input$text_input
    })
    
    output$textarea_input_text <- renderText({
        input$text_area
    })
    
    output$actionButton_input_text <- renderText({
        input$action_button
    })
    
    output$actionLink_input_text <- renderText({
        input$action_link
    })

})
