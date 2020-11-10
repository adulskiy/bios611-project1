install.packages("shiny", repos = "http://cran.us.r-project.org")
library(shiny)
library(tidyverse)


# Process command line arguments.
args <- commandArgs(trailingOnly = TRUE)
port <- as.numeric(args[1])


# Define UI for application that plots random distributions 
ui <- shinyUI(fluidPage(
  
  # Application title
  titlePanel("How does coral growth vary over time?"),
  
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      selectInput("variables", 
                  "Select Variable:", 
                  choices = c("Linear extension" = "linext",
                              "Calcification" = "calc",
                              "Density" = "density")),
      selectInput("fit", "Select fit:",
                  choices = c("Smooth" = "smooth",
                              "Line" = "line"))
    ),
    
    # Show a plot
    mainPanel(
      # Brush & zoom
      fluidRow(
        column(width = 12, class = "well",
               style = "background-color: white;",
               h5("Brush and double-click to zoom."),
               h5("Double-click again to zoom out."),
               plotOutput("plot",
                          dblclick = "plot_dblclick",
                          click = "plot_click",
                          brush = brushOpts(
                            id = "plot_brush",
                            resetOnNew = TRUE)
               ),
               verbatimTextOutput("info")
        )
      )
    )
  )
))


# Server
server <- shinyServer(function(input, output) {
  
  # Read file
  data <- read.csv("shinyproject/data/sg.csv") 
  
  renderPrint({ input$variables })
  renderPrint({ input$fit })
  
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  
  output$plot <- renderPlot({
    df <- data
    year <- df$year
    linext <- df$linext
    calc <- df$calc
    dens <- df$density
    if(input$variables == "linext") {
      ggplot(data = df, aes_string(x = year, y = linext)) +
        geom_point(alpha = 0.5) +
        scale_x_continuous(breaks = seq(1890, 2014, by = 10)) +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE) +
        labs(x = "Year", y = "Extension (cm/year)") +
        if(input$fit == "smooth") {
          geom_smooth(col = "orange")
        } else {
          geom_line(col = "orange")
        }
    } else if(input$variables == "calc") {
      ggplot(data = df, aes(x = year, y = calc)) +
        geom_point(alpha = 0.5) +
        scale_x_continuous(breaks = seq(1890, 2014, by = 10)) +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE) +
        labs(x = "Year", y = "Calcification (g/cm2/yr)") +
        if(input$fit == "smooth") {
          geom_smooth(col = "navy")
        } else {
          geom_line(col = "navy")
        }
    } else {
      ggplot(data = df, aes(x = year, y = density)) +
        geom_point(alpha = 0.5) +
        scale_x_continuous(breaks = seq(1890, 2014, by = 10)) +
        coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE) +
        labs(x = "Year", y = "Density (g/cm3/yr)") +
        if(input$fit == "smooth") {
          geom_smooth(col = "red")
        } else {
          geom_line(col = "red")
        }
    }
  })
  
  # Brush & Click Output
  # When a double-click happens, check if there's a brush on the plot.
  # If so, zoom to the brush bounds; if not, reset the zoom.
  observeEvent(input$plot_dblclick, {
    brush <- input$plot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  # Brush and click text output.
  output$info <- renderText({
    xy_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
    }
    xy_range_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
             " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
    }
    
    paste0(
      "click: ", xy_str(input$plot_click),
      "brush: ", xy_range_str(input$plot_brush)
    )
  })
  
})

shinyApp(ui=ui, server=server, options=list(port=port, host="0.0.0.0"))

