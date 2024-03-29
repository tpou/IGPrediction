
load(url("https://rshiny.s3.ap-southeast-1.amazonaws.com/Dashboard.RData"))
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