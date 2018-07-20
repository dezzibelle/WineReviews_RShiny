library(shiny)

# Define UI ----
ui <- fluidPage(

  titlePanel("Making Sense of Wine Reviews"),
  
  sidebarLayout(
    sidebarPanel(strong("Sidebar Title", style = "color: purple"),
                 
                 selectInput("varietal", 
                             label = "Choose a varietal:",
                             choices = top_varieties,
                             selected = "Pinot Noir")
                 
                  ), #End sidebarPanel ----
    
    mainPanel(h1("Price versus Wine Rating", align = "center", style = "color:purple"),
              div(img(src = "bottles.jpeg"), style="text-align: center;"),
              # h2("Second level title", align = "center"),
              # h3("Third level title", align = "center"),
              # h4("Fourth level title", align = "center"),
              # h5("Fifth level title", align = "center"),
              # br(),
              # h6("Sixth level title", align = "center"),
              
              plotOutput("selected_var")
              
              ) #End mainPanel ----
  ) #End of sidebarLayout ---- 
 

   
    
) #End of UI fluidPage ----
