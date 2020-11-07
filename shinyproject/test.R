library(shiny)
library(tidyverse)


# Global
args <- commandArgs(trailingOnly=TRUE)
port <- args[[1]] %>% as.numeric()
data <- read_csv("~/shinyproject/data/sg.csv") 

# Define UI for application that plots random distributions 
ui <- shinyUI(fluidPage(
  
  # Application title
  titlePanel("How does coral growth vary over time?"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      selectInput("variables", 
                  "Select Variable:", 
                  choices = c("Calcification" = "calc",
                              "Linear extension" = "linext",
                              "Density" = "dens")),
    ),
    
    # Show a plot
    mainPanel(
      plotOutput(outputId = "plot")
    )
  )
))


# Server
server <- shinyServer(function(input, output) {
  
  # Read file
  data <- read.csv("~/shinyproject/data/sg.csv") 
  
  renderPrint({ input$selectInput })
  
  # Rendering plot
  output$plot <- renderPlot({
    df <- data
    year <- df$year
    calc <- df$calc
    ggplot(df, aes(x = year, y = calc)) +
             geom_point(alpha = 0.5)
  })
  
})



shinyApp(ui=ui, server=server, options=list(port=port, host="0.0.0.0"))

