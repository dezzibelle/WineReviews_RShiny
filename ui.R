library(shiny)

# Define UI ----
ui <- fluidPage(
  
  titlePanel("Making Sense of Wine Reviews"),
  
  sidebarLayout(
    sidebarPanel(strong("Make Your Selections:", style = "color: purple"),
                 
                 selectInput("varietal", 
                             label = "Choose a varietal:",
                             choices = top_varieties,
                             selected = "Pinot Noir"), 
                 
                 sliderInput("pricerange",
                             label = "Pick a price range ($):",
                             min = 0,
                             max = 3500,
                             value = c(10,2000))
                 
    ), #End sidebarPanel ----
    
    mainPanel(h1("Price versus Wine Rating", align = "center", style = "color:purple"),
              div(img(src = "bottles.jpeg"), style="text-align: center;"),
              
              textOutput("selected_variety"),
#              textOutput("selected_range"),
              tableOutput("selected_wines"),
              plotOutput("price_vs_pts")   #plot of points vs price (by varietal)
              
    ) #End mainPanel ----
  ) #End of sidebarLayout ---- 
  
  
  
  
) #End of UI fluidPage ----
