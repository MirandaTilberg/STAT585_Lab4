library(shiny)
library(dplyr)
library(lubridate)
library(stringr)


ui <- fluidPage(
  titlePanel("Liquor Purchases in Story County"),
  #select menu 
  #inputId is the label used in the server 
  #label is the Name of the input
  #choice is the option for the input
  #multiple is whether input could be multiple choice
  selectizeInput(inputId = "code", label = "XXX", 
                 choices=1:5, 
                 selected=NULL,
                 multiple=T),
  #check box menu
  #we can add more kinds of input menu if we need
  fluidRow(
    column(4,
           checkboxGroupInput(inputId = "feature", label = "Type of Liquor", 
                              choices = c(1:5), 
                              selected = NULL)
    ),
    column(4,
           checkboxGroupInput("icons", "Choose icons:",
                              choiceNames =
                                list(icon("calendar"), icon("bed"),
                                     icon("cog"), icon("bug")),
                              choiceValues =
                                list("calendar", "bed", "cog", "bug"))
    ),
    column(4,
           selectInput('facet_row', 'Facet Row', c(None='.', names(iris)))
    )
  ),
  hr(),
  mainPanel(
    tabsetPanel(
      #temporal tab
      #plot name in the plotOutput
      tabPanel("spatial", leaflet::leafletOutput("map")),
      tabPanel("temporal", plotOutput("plot_temporal"))
    )
  )
) 

server <- function(input, output) {
  output$plot_temporal <- renderPlot({
    #plot function
    # plot_temporal_function()
  })
  output$plot_saptial <- renderPlot({
    #plot function
    # plot_temporal_function()
    }
  )
  output$map <- leaflet::renderLeaflet({
    leaflet::leaflet(data = df) %>% leaflet::addTiles() %>%
    leaflet::addCircleMarkers(~ Longitude, ~ Latitude, popup = ~ Item, label = ~ Category,
                              clusterOptions = leaflet::markerClusterOptions())
  })
}

shinyApp(ui = ui, server = server)    
