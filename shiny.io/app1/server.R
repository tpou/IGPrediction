
library(shiny)
shinyServer(function(input, output) {
  
  output$hist <- renderPlot({hist(rnorm(input$num))})
})

