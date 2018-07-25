## ui.R ##

library(shiny)
library(shinydashboard)

dashboardPage(skin = "purple",
              dashboardHeader(title = "Wine Ratings - Visualized", ###########
                              titleWidth = 275
              ), #end header  
## -- SIDEBAR: ######################
              dashboardSidebar(   
                width = 275,
                div(img(src = "bottles.jpeg"), style="text-align: center;"),
                sidebarMenu(
                  menuItem("Background", tabName = "background", icon = icon("leaf")),
                  menuItem("Ratings vs. Price", tabName = "ptsPrice", icon = icon("leaf")),
                  menuItem("Compare Countries & Varietals", tabName = "barPlot", icon = icon("leaf")),
                  menuItem("Wine Selector", tabName = "wineChooser", icon = icon("leaf")),
                  menuItem("Top Varietal by Region", tabName = "wineRegions", icon = icon("leaf"))
                  ) #end sidebarMenu
              ), #end sidebar
## -- BODY: ######################
              dashboardBody(
                tabItems(
## -- FIRST TAB: ######################
                  tabItem(tabName = "background",
                         div(img(src = "grapes2.jpeg"), style="text-align: center;"),
                         h2("Background", style="text-align: center;"),
                         
                         br(),
                         h4("* Over 120,000 reviews, 20 different wine tasters"),
                         h4("* More than 110,000 different wines from 42 countries"),
                         h4("* Ratings ranged between 80-100 points"),
                         h4("* Wines priced at $4-$3300 per bottle"),
                         br(),
                         h4("Motivation: "),
                         h5(" - To investigate the relationship between a wine's 
                            rating and its price, origin, and varietal"),
                         br(),
                         h5("Sources: ",uiOutput("WineMag")),
                         h5(uiOutput("Kaggle"))
                         
                  ), #end 1st tab
                  
## -- SECOND TAB: ######################
                  tabItem(tabName = "ptsPrice", 
                          h3("Do Wine Ratings Correlate with Price?"),
                          
                          fluidRow(
                            box(plotOutput("plot1", height = 250),  #plot pts vs. price
                                plotOutput("plot2", height = 250), width = 12) #plot pts vs. log(price)
                          )
                  ), #end 2nd tab

## -- THIRD TAB: ######################
                  tabItem(tabName = "barPlot", 
                          h3("Compare Popular Varietals from the Top 5 Wine-Producing Countries"),
                          box(
                            radioButtons("swapPlot",
                                         label = "Choose a graph:",
                                         choices = list("Varietal vs. Average Rating" = 1,
                                                        "Varietal vs. Median Price" = 2),
                                         selected = 1,
                                         inline = TRUE)
                          ),
                          box(
                            plotOutput("barGraph", height = 450),width = 12
                          )
                  ), #end 3rd tab

## -- FOURTH TAB: ######################
                  tabItem(tabName = "wineChooser", 
                          h3("Choose the Top 20 Highest-Rated Wines Based on Price Range and Varietal"),
                          fluidRow(
                          box(
                            selectInput("varietal", 
                                        label = "Choose a varietal:",
                                        choices = top_varieties,
                                        selected = "Pinot Noir"), 
                          
                            radioButtons("pricerange", 
                                         label = h3("Select a price range:"),
                                         choices = list("< $10" = 1, 
                                                        "$10 - $25" = 2, 
                                                        "$25 - $50" = 3,
                                                        "$50 - $100" = 4, 
                                                        "$100 - $500" = 5, 
                                                        "> $500" = 6), 
                                         selected = 1),
                            width = 3, 
                            height = 350),
                          box(
                          tableOutput("selected_wines"), width = 9 
                          )
                          )
                  ), #end 4th tab
                  
## -- FIFTH TAB: ######################
                  tabItem(tabName = "wineRegions", 
                          h3("Average Rating for the Most Popular Varietal Produced by Each Region:"),
                          fluidRow(
                            box(htmlOutput("map"), width = 12 )
                          ),
                          fluidRow(
                            box(htmlOutput("map2"), width = 12)
                          )
                  )
                ) #end tabItems #####
              ) #end Body 
) #end Page

