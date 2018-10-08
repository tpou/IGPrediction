
load(url("https://s3.us-east-2.amazonaws.com/aiprediction/Dashboard.RData"))
# Deploy app:
# library(rsconnect)
#rsconnect::deployApp('path/to/your/app')

library(ggplot2)
library(reshape2)
library(shiny)
library(shinydashboard)
library(plotly)

Dashboard2<- melt(Dashboard,id.vars="Date",measure.vars=c("N","W","S","OT"))
#----------------------------------------------------------------------------------------------------------------------------
dbHeader <- dashboardHeader(titleWidth=250)
anchor <-tags$a(tags$img(src='header1.png',height='50',width='100'),'iG Forecast')
dbHeader$children[[2]]$children <- tags$div(align="left",tags$head(tags$style(HTML(".name {
                                                                                            font-family:Palatino Header;
                                                                                            font-size:1em;
                                                                                            font-weight:bold;
                                                                                            color:red}"))),
                                                         class = 'name',anchor)


#----------------------------------------------------------------------------------------------------------------------------
ui <- dashboardPage(skin="black",
        dbHeader,
        #--------------------------------------------------------------------------------------------------------------------
        dashboardSidebar(width=250,
           sidebarMenu(
             menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
             menuItem("Schedule", tabName = "schedule",icon = icon("calendar")),
             menuItem("Model", tabName = "model", icon = icon("cogs")),
             menuItem("Production Allocation", tabName ="prodallocation", icon = icon("")),
             menuItem("Decline Curve", tabName ="declinecurve", icon = icon("chart-line")),
             menuItem("Machine Learning", tabName = "machinelearning", icon = icon("brain"))
                      ) # end sidebarMenu              
                         
                         
                         
                         
                         ), # end dashboardSidebar
        #--------------------------------------------------------------------------------------------------------------------
        dashboardBody(
          tabItems(
              tabItem( tabName ="dashboard",

                    tabBox(title="Dashboard",
                           id = "tabbox1",
                           width = 12,
                           
                           #height = "750px",
                           tabPanel("Plot",
                                    fluidRow(
                                        column(width = 6,
                                               plotOutput("plot1")),
                                        column(width = 6,
                                               plotOutput("plot2"))
                                               
                                            ),
                                    fluidRow(
                                      column(width = 6,
                                             plotOutput("plot3")),
                                      column(width = 6,
                                             plotlyOutput("plot5"),
                                             verbatimTextOutput("event"))                                      
                                            )
                                    ),
                           tabPanel("Summary"),
                           tabPanel("Table",
                                    sliderInput("slider","Slider Input:",1,100,5),
                                    selectInput(inputId="x",
                                                label = "X-axis",
                                                choices = c("Date","N"),
                                                selected="Date"),
                                    selectInput(inputId="y",
                                                label = "Y-axis",
                                                choices = c("Capacity","Condensate"),
                                                selected="Capacity")))
                          
                      ),
              #--------------------------------------------------------------------------------------------------------------
              tabItem( tabName ="schedule",
                  h2("Schedule")
                      ),
              tabItem( tabName ="model",
                  h2("Model")
                      ),
              tabItem( tabName ="prodallocation",
                  h2("Production Allocation")  
                      ),
              tabItem( tabName ="declinecurve",
                  h2("Machine Learning")
                      ),
              tabItem( tabName ="machinelearning"
                
                      )
            
                  )
                      ) # end dashboardBody
                    ) # end ui dashboardPage

#----------------------------------------------------------------------------------------------------------------------------
server <- function(input, output) {
  
  output$plot1 <- renderPlot({
    ggplot(data=Dashboard,aes(x=Date)) + geom_line(aes(y=Capacity),size=0.5) +
      geom_line(aes(y=Gas.Production),color="red",size=1.5)+
      geom_line(aes(y=MDQ),color="turquoise2",size=1)
                            })
  output$plot2 <- renderPlot({
    ggplot(data=Dashboard,aes(x=Date)) + geom_line(aes(y=Capacity.Volume)) +
      geom_area(data=Dashboard2,aes(y=value,color=variable,fill=variable))
  })
  output$plot3 <- renderPlot({
    ggplot(data=Dashboard,aes(x=Date)) + geom_line(aes(y=Condensate,color=Condensate),color="seagreen",size=1.5) +
      geom_line(aes(y=Water),color="blue",size=1.5)
                             })
  output$plot4 <- renderPlot({
    ggplot(data=Dashboard,aes(x=Date)) + geom_line(aes(y=CO2),color="purple",size=1) +
      geom_line(aes(y=N2),color="orange", size=1)+ 
      geom_line(aes(y=BTU/50),color="red1",size=1)+
      scale_y_continuous(sec.axis=sec_axis(~.*50,name="GHV"))+
      scale_colour_manual(values=c("purple","orange"), name ="Fluid",labels=c("CO2","N2","GHV"))+
      labs(y="CO2 / N2",color="Parameters")+
      theme(plot.title = element_text(hjust=0.5),legend.position=c(0.8,0.9))+
      ggtitle("CO2/ N2 Forecast")
  })
  
  output$plot5 <- renderPlotly({
  plot_ly() %>%
      add_lines(x=Dashboard$Date,y=Dashboard$CO2,name="CO2") %>%
      add_lines(x=Dashboard$Date,y=Dashboard$N2,name="N2") %>%
      add_lines(x=Dashboard$Date,y=Dashboard$BTU,name="BTU",yaxis="y2")%>%
      layout(yaxis2=list(overlaying="y",side="right"))
  })

  output$event <- renderPrint({
    d<- event_data("plotly_hover")
    if (is.null(d)) "hover on a point!" else d
  })
}

#----------------------------------------------------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)