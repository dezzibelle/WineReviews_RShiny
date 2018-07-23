## ui.R ##

library(shiny)
library(shinydashboard)

dashboardPage(skin = "purple",
              dashboardHeader(title = "Wine Reviews - Visualized", #########################
                              titleWidth = 275
              ), #end header  
## -- SIDEBAR: ######################
              dashboardSidebar(   
                width = 275,
                sidebarMenu(
                  menuItem("Background", tabName = "background", icon = icon("cloud")),
                  menuItem("Ratings vs. Price", tabName = "ptsPrice", icon = icon("dollar")),
                  menuItem("Wine Chooser", tabName = "wineChooser", icon = icon("glass")),
                  menuItem("Wines by Region", tabName = "wineRegions", icon = icon("globe"))
                ) #end sidebarMenu
              ), #end sidebar
## -- BODY: ######################
              dashboardBody(
                            div(img(src = "bottles.jpeg"), style="text-align: center;"),  #Fix picture link 
                tabItems(
                  
## -- FIRST TAB: ######################
                  tabItem(tabName = "background", title = "Project Background",
                         h3("Background"),
                         br(),
                         h5("Over 120,000 reviews from Wine Enthusiast Magazine of over 110,000 different wines from 42 countries."),
                         br(),
                         h5("Reviews from over 20 tasters."),
                         br(),
                         h5("Ratings ranging between 80-100 points and for wines priced at $4-$3300 per bottle.")
                         
                  ), #end 1st
                  
## -- SECOND TAB: ######################
                  tabItem(tabName = "ptsPrice", h3("Does Wine Rating Correlate with Price?"),
                          
                          fluidRow(
                            plotOutput("plot1", height = 250
                          ),
                          fluidRow(
                            box(plotOutput("hist1", height = 250)),
                            box(plotOutput("hist2", height = 250))
                          )
                          )
                  ), #end 2nd

## -- THIRD TAB: ######################
                  tabItem(tabName = "wineChooser", h3("Choose the best wines based on price range and varietal"),
                          fluidRow(
                          box(
                              selectInput("varietal", 
                                          label = "Choose a varietal:",
                                          choices = top_varieties,
                                          selected = "Pinot Noir"),height = 125), 
                          box(
                              sliderInput("pricerange",
                                          label = "Pick a price range ($):",
                                          min = 0,
                                          max = 3500,
                                          value = c(0,50)),height = 125)
                          ),
                          fluidRow(
                          tableOutput("selected_wines") 
                          )
                  ), #end 3rd
                  
## -- FOURTH TAB: ######################
                  tabItem(tabName = "wineRegions", h3("Best wines in each region")
                  ) #end 4th
                  
                ) #end tabItems
              ) #end Body 
) #end Page

