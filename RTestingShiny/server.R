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
    output$testText <- renderText("Here's some text!")
    
    observeEvent(input$referenceNetworkAdd, {
        output$outReferenceNetworkId <- renderText(input$referenceNetworkId)
        output$outReferenceNetworkName <- renderText(input$referenceNetworkName)
        output$outReferenceNetworkAbbreviation <- renderText(input$referenceNetworkAbbreviation)
        output$outReferenceNetworkChannel <- renderText(input$referenceNetworkChannel)
    })
    
    networkModule <- networkModuleServer("networkModule", stringsAsFactors = FALSE)
})
