library(shiny)

ui <- fluidPage(
  #select menu 
  #inputId is the label used in the server 
  #label is the Name of the input
  #choice is the option for the input
  #multiple is whether input could be multiple choice
  selectizeInput(inputId = "code", label = "XXX", 
                 choices=XXXX, 
                 selected=NULL,
                 multiple=T),
  #check box menu
  #we can add more kinds of input menu if we need
  checkboxGroupInput(inputId = "feature", label = "XXX", 
                     choices=c(XXXX), 
                     selected=NULL),
  #set tab
  mainPanel(
    tabsetPanel(
      #temporal tab
      #plot name in the plotOutput
      tabPanel("temporal", plotOutput("plot_temporal")),
      tabPanel("spatial", plotOutput("plot_saptial"))
    )
  )
) 

server <- function(input, output) {
  output$plot_temporal <- renderPlot({
    #plot function
    plot_temporal_function()
  })
  output$plot_saptial <- renderPlot({
    #plot function
    plot_temporal_function()
    }
  })
}

shinyApp(ui = ui, server = server)    
