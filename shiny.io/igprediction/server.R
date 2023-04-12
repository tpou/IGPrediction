library(ggplot2)
library(reshape2)
library(shiny)
library(shinydashboard)
library(plotly)

load(url("https://tineusstorage.blob.core.windows.net/shiny/Dashboard.RData"))

Dashboard2<- melt(Dashboard,id.vars="Date",measure.vars=c("N","W","S","OT"))

shinyServer(function(input, output) {
  
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
})

