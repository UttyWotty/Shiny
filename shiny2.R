install.packages("shiny")

library(shiny)
data(airquality)
summary(airquality)
View(airquality)

ui <- fluidPage(
  
  titlePanel("Ozone level"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput(inputId = "bins",
                  label = "Number of Bins:",
                  min = 1,
                  max = 50,
                  value = 30)
      
    ),
    
    mainPanel(
      
      plotOutput(outputId = "distPlot")
    ) 
  )
)


server <- function(input, output) {
  
  output$distPlot <- renderPlot({
  
  x <- airquality$Ozone
  x <- na.omit(x)
  bins <- seq(min(x), max(x), length.out = input$bins + 1)
  
  hist(x, breaks = bins, col = "green", border = "orange",
       xlab = "Ozone Level",
       main = "Histogram of Ozone Level")
})
  
  }

shinyApp(ui = ui, server = server)

