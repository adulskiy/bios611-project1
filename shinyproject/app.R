library(shiny)
library(tidyverse)


# Global
args <- commandArgs(trailingOnly=TRUE)
port <- args[[1]] %>% as.numeric()
data <- read_csv("~/shinyproject/data/sg.csv") 

# Define UI for application that plots random distributions 
ui <- shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hello Shiny!"),
  
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
      plotOutput("plot")
    )
  )
))


# Define server logic required to generate and plot a random distribution
server <- shinyServer(function(input, output) {
  
  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #

  renderPrint({ input$selectInput })
  
  #output$plot <- renderPlot({
    #ggplot(data, aes_string(x = year, y = input$variables) +
            # geom_point(alpha = 0.5))
  #})
  
})


# Create Shiny object.
shinyApp(ui=ui, server=server, options=list(port=port, host="0.0.0.0"))
