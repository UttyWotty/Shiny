install.packages("shiny")
install.packages("shinythemes")

library(shiny)
library(shinythemes)


 ui  <- fluidPage(theme = shinytheme("cyborg"),
  navbarPage(
    "My First App",
    tabPanel("NavBar 1",
             sidebarPanel(
               tags$h3("Input:"),
               textInput("txt1", "Given Name:", ""),
               textInput("txt2", "Surname", ""),
             ),
              mainPanel(
                          h1("Header 1"),
                          
                          h4("Output 1"),
                          verbatimTextOutput("txtout"),
                          
                  )
               ),
               tabPanel("NavBar2","This panel is intertionaly left blank"),
               tabPanel("NavBar3","This panel is intertionaly left blank")
            )
        )

server <-function(input,output) {
  
  output$txtout <- renderText({
    paste( input$txt1, input$txt2, sep = " ")
  })
}
             
shinyApp(ui = ui, server = server)
               
               
           
