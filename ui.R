## ui.R ##


library(shiny)
library(shinydashboard)

dashboardPage(skin = "purple",
              dashboardHeader(title = "Wine Reviews - Visualized", #########################
                              titleWidth = 275
              ),  
## -- SIDEBAR: ######################
              dashboardSidebar(   
                width = 275,
                sidebarMenu(
                  menuItem("Background", tabName = "background", icon = icon("cloud")),
                  menuItem("Ratings vs. Price", tabName = "ptsPrice", icon = icon("dollar")),
                  menuItem("Wine Chooser", tabName = "wineChooser", icon = icon("glass")),
                  menuItem("Wines by Region", tabName = "wineRegions", icon = icon("globe"))
                )
              ),
## -- BODY: ######################
              dashboardBody(
                            div(img(src = "bottles.jpeg"), style="text-align: center;"),  #Fix picture link 
                tabItems(
                  
## -- FIRST TAB: ######################
                  tabItem(tabName = "background", title = "Project Background",
                         h2("Background, reviews source, details")
                  ),
                  
## -- SECOND TAB: ######################
                  tabItem(tabName = "ptsPrice", title = "Does Rating Correlate with Price?",
                          fluidRow(
                            box(plotOutput("plot1", height = 250)),
                            box(sliderInput("slider","Number of Observations:", 0,100,50))
                          )
                  ),
                  
## -- THIRD TAB: ######################
                  tabItem(tabName = "wineChooser", h3("Pick the best wines based on price range, variety, and country"),
                          fluidRow(
                          box(
                              selectInput("varietal", 
                                          label = "Choose a varietal:",
                                          choices = top_varieties,
                                          selected = "Pinot Noir")), 
                          box(
                              sliderInput("pricerange",
                                          label = "Pick a price range ($):",
                                          min = 0,
                                          max = 3500,
                                          value = c(10,2000))
                          )),
                          fluidRow(
                          tableOutput("selected_wines") 
                          )
                  ),
                  
## -- FOURTH TAB: ######################
                  tabItem(tabName = "wineRegions",
                          h2("Best wines in each region")
                  )
                )
              )
)

