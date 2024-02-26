install.packages("shiny")
install.packages("shinythemes")
install.packages("data.table")
install.packages("RCurl")
install.packages("randomForest")

library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)

weather <- read.csv("golf_df.csv", header = T)

model <- randomForest(play ~ ., data = weather, ntree = 500, mtry = 4, importance = TRUE)

ui <- fluidPage(theme= shinytheme("cyborg"),
                
                headerPanel("Should I play golf?"),
                
                sidebarPanel(
                  HTML("<h3>Input parameters</h3>"),
                  
                  selectInput("outlook", label = "Outlook",
                              choices = list("Sunny" = "sunny", "Overcast" = "OverCast", "Rainy" = "rainy"),
                                             selected = "Rainy"),
                              sliderInput("temprature", "Temprature",
                                          min = 64, max = 86,
                                          value = 70),
                              sliderInput("humidity", "Humiditiy",
                                          min = 65, max = 96,
                                          value = 90),
                              sliderInput("windy", "Windy",
                                          choices = list("yes" = "TRUE", "no" = "FALSE"),
                                          selected = "TRUE"),
                  
                  actionButton("submitbutton", "Submit", class = "btn btn-primary")
                ), 
mainPanel(
  tags$label(h3('status/Output')),
  verbatimTextOutput('contents'),
  tableOutput('tabledata')
  
)
)

server <- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    # outlook,temperature,humidity,windy,play
    df <- data.frame(
      Name = c("outlook",
               "temperature",
               "humidity",
               "windy"),
      Value = as.character(c(input$outlook,
                             input$temperature,
                             input$humidity,
                             input$windy)),
      stringsAsFactors = FALSE)
    
    play <- "play"
    df <- rbind(df, play)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    test$outlook <- factor(test$outlook, levels = c("overcast", "rainy", "sunny"))
    
    
    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}
    shinyApp(ui = ui, server= server)
    
    