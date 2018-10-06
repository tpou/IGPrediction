library(shiny)

ui <- fluidPage(
  # Input() function,
  # Output() function
  sliderInput(inputId = "num", label ="Chose a number:",
              value = 25, min =1, max = 100),
  
  plotOutput(outputId = "hist")
  
)