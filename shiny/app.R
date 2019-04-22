library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plotly)
library(leaflet)

df <- readRDS("../data/finalDF.rds")

ui <- fluidPage(
  titlePanel("Liquor Purchases in Story County"),
  
  fluidRow(
    column(8,
           sliderInput(inputId = "date", "Range of date",
                       min = min(df$Date),
                       max = max(df$Date),
                       value = as.Date(c("2012-12-01", "2013-03-02"), timeFormat = "%Y-%m-%d"),
                       width = "100%")
           ,
           selectInput(inputId = "city", label = "City", 
                       choices = unique(df$City), 
                       selected = "AMES",
                       multiple = F,
                       width = "100%")
    ),
    column(4,
           checkboxGroupInput(inputId = "category", label = "Type of Liquor", 
                              choices = unique(df$Category), 
                              selected = "WHISKIES",
                              width = "100%")
    )
  ),
  
  hr(),
  mainPanel(
    tabsetPanel(
      tabPanel("spatial", leafletOutput("spatial")),
      tabPanel("temporal", plotlyOutput("temporal"))
    ),
    width = 12
  )
) 

server <- function(input, output) {
  output$temporal <- renderPlotly({
    df_filter <- filter(df, Date %within% (input$date[1] %--% input$date[2]) &
                          Category %in% input$category &
                          City == input$city)
    
    validate(
      need(!is.null(input$category), "Check at least one category!"),
      need(nrow(df_filter)!= 0, "No data after filter."))
    
    ggplot(df_filter, aes(x = Date, y = `Sale(Dollars)`, color = Category)) +
      stat_summary(fun.y = sum, na.rm = TRUE, geom = "line") +
      labs(title = "Sale of Liquor", y = "Sale(Dollars)") +
      theme_bw() + theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$spatial <- renderLeaflet({
    df_filter <- filter(df, Date %within% (input$date[1] %--% input$date[2]) &
                          Category %in% input$category &
                          City == input$city)
    
    validate(
      need(!is.null(input$category), "Check at least one category!"),
      need(nrow(df_filter)!= 0, "No data after filter."))
    
    leaflet(data = df_filter) %>% addTiles() %>%
      addCircleMarkers(~ Longitude, ~ Latitude, popup = ~ Item, label = ~ Category,
                       clusterOptions = leaflet::markerClusterOptions())
  })
}

shinyApp(ui = ui, server = server)
