
load(url("https://aiprediction.s3.us-east-2.amazonaws.com/AIproduction.RData"))
# Deploy app:
# library(rsconnect)
rsconnect::deployApp('/shiny.io/igprediction')

library(shiny)

ui <- fluidPage(
  
        tabsetPanel(
          tabPanel("Dashboard",
                   navlistPanel(widths = c(2,10),
                     tabPanel("Plot", 
                                fluidRow
                                (
                                  column(2),
                                  column(6, sliderInput(inputId = "num", label ="Chose a number:",
                                                        value = 25, min =1, max = 100))
                                ),
                                
                                fluidRow
                                (
                                  column(4, offset =8,plotOutput(outputId = "hist"))
                                )),
                    tabPanel("Summary"),
                    tabPanel("Table")
                    )),
          tabPanel("Scheduling"),
          tabPanel("Model Assumption"),
          tabPanel("Production Allocation"),
          tabPanel("Decline Curve"),
          tabPanel("Interactive Plot"),
          tabPanel("Machine Learning")))
             # Input() function,
             # Output() function


server <- function(input, output) {
  
  output$hist <- renderPlot({hist(rnorm(input$num))})
}

shinyApp(ui = ui, server = server)