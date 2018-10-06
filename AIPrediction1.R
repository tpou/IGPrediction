
load(url("https://s3.us-east-2.amazonaws.com/aiprediction/AIproduction.RData"))
# Deploy app:
# library(rsconnect)
#rsconnect::deployApp('path/to/your/app')

library(shiny)

ui <- fluidPage(
  # Input() function,
  # Output() function
  sliderInput(inputId = "num", label ="Chose a number:",
              value = 25, min =1, max = 100),
  
  plotOutput(outputId = "hist")
  
)

server <- function(input, output) {
  
  output$hist <- renderPlot({hist(rnorm(input$num))})
}

shinyApp(ui = ui, server = server)