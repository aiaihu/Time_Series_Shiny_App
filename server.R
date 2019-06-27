library(shiny)
source("forecast_model.R")

server <- function(input, output) {
  getTemperature <- reactive({
    forecastTemperature(input$months)
    
  })
  
  
  getHumidity <- reactive({
    forecastHumidity(input$months)
  })
  
  
     output$temperature <- renderPlot({
     plot(getTemperature())
     })
     
     output$humidity<- renderPlot({
       plot(getHumidity())
    
       
  })
}
