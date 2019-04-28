# --------------------------------------------------------
# Monty Hall Shiny App - Lilian Cheung
# --------------------------------------------------------
source( '../Ch 2 R Source/Monty Hall in R.R' )
library( shiny )
library( shinydashboard )
library( ggplot2 )
library( tidyverse )
library( DT )
library( stringr ) 

ui <- dashboardPage(
   
  dashboardHeader( title = "Murphy Chapter 2" ),
  dashboardSidebar( 
    
    # --- id must be named to have a dynamic sidebar
    sidebarMenu(
      id = "sidebar_menu",
      menuItem( tabName = "monty_hall", "Monty Hall Problem" )
    ),
    
    shiny::uiOutput( "sidebar_ui" )
    
    ),
  
  dashboardBody(
    
    DT::dataTableOutput( "monty_hall_data" ),
    
    plotly::plotlyOutput( "monty_hall_plot")
    
  ),
  
  skin = "red" 
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # --- Define output with id sidebar_ui that reacts to changes in sidebar menu
  output$sidebar_ui <- shiny::renderUI(
    
    if( input$sidebar_menu == "monty_hall" ) {
      
      # --- Sidebar items should be a list
      list(     numericInput( inputId = "nsim", 
                              label = "Number of Games:",
                              value = 1000,
                              min = 1, 
                              max = 100000, 
                              step = 1 ),
                
                selectInput( inputId = "switch",
                             label = "Switch?",
                             choices = c( "Switch Doors",
                                          "Don't Switch Doors" )
                ),
                
                br(), br(), 
                
                actionButton( inputId = "update", 
                              label = "Update Inputs",
                              icon = icon( "refresh" ) ) )
      
    }
    
    
  )
  
  monty_hall_info <- eventReactive( input$update, {
    
    if( input$switch == "Switch Doors" ){
      switch_par <- TRUE 
    } else if ( input$switch == "Don't Switch Doors" ) {
      switch_par <- FALSE
    }

    Monty( n = input$nsim,
           switch = switch_par )

  })
  
  output$monty_hall_data <- DT::renderDataTable( 
    monty_hall_info()[[ "data" ]]
    
    )
  
  output$monty_hall_plot <- plotly::renderPlotly(
    monty_hall_info()[[ "plot" ]]
    
  )

}

# Run the application 
shinyApp(ui = ui, server = server)

