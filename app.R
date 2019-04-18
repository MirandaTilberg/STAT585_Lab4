library(shiny)
library(dplyr)
library(lubridate)
library(stringr)

# Data Pre-processing
raw_df <- "https://data.iowa.gov/resource/m3tr-qhgy.json?county=Story" %>%
  jsonlite::read_json() %>%
  purrr::map_df(~ as_tibble(as.list(unlist(.x, use.names = T))))

df <- raw_df %>%
  mutate_at(vars(bottle_volume_ml, pack, starts_with("store_location.coordinates"),
                 starts_with("sale"), starts_with("state")), as.numeric) %>%
  mutate(date = date(ymd_hms(date)),
         category_type = case_when(
           str_detect(category_name, "WHISKIES") ~ "WHISKIES",
           str_detect(category_name, "SCHNAPPS") ~ "SCHNAPPS",
           str_detect(category_name, "CORDIALS") ~ "CORDIALS",
           str_detect(category_name, "LIQUEURS") ~ "LIQUEURS",
           str_detect(category_name, "VODKA") ~ "VODKA",
           str_detect(category_name, "GINS") ~ "GINS",
           str_detect(category_name, "RUM") ~ "RUM",
           str_detect(category_name, "AMARETTO") ~ "AMARETTO",
           str_detect(category_name, "TEQUILA") ~ "TEQUILA",
           T ~ "Others"
         )) %>%
  select(item = im_desc, category_name, category_type, date,
         longitude = store_location.coordinates1, latitude = store_location.coordinates2, everything()) %>%
  select(-name, -city, -county, -zipcode, -address, everything()) %>%
  select(-category, -county_number, -invoice_line_no, -itemno, -sale_gallons,
         -starts_with("store"), -starts_with("vendor")) %>%
  filter_at(vars(date, longitude, latitude), ~ !is.na(.)) %>%
  arrange(date)


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
    leaflet::addCircleMarkers(~ longitude, ~ latitude, popup = ~ name, label = ~ item,
                              clusterOptions = leaflet::markerClusterOptions())
  })
}

shinyApp(ui = ui, server = server)    
