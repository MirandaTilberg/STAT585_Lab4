library(shiny)

ui <- fluidPage(
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
  checkboxGroupInput(inputId = "feature", label = "XXX", 
                     choices=c(1:5), 
                     selected=NULL),
  #set tab
  mainPanel(
    tabsetPanel(
      #temporal tab
      #plot name in the plotOutput
      tabPanel("temporal", plotOutput("plot_temporal")),
      tabPanel("spatial", leaflet::leafletOutput("map"))
    )
  )
) 

server <- function(input, output) {
  raw_df <- "https://data.iowa.gov/resource/m3tr-qhgy.json?county=Story" %>%
    jsonlite::read_json() %>%
    purrr::map_df(~ dplyr::as_tibble(as.list(unlist(.x, use.names = T))))
  
  df <- raw_df %>% mutate(date = ymd_hms(date),
                          longitude = as.numeric(store_location.coordinates1),
                          latitude = as.numeric(store_location.coordinates2)) %>%
    filter(!is.na(latitude)) %>%
    filter(!is.na(longitude))
  
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
    leaflet::addCircleMarkers(~longitude, ~latitude, popup = ~name, label = ~name,
                              clusterOptions = leaflet::markerClusterOptions())
  })
}

shinyApp(ui = ui, server = server)    
