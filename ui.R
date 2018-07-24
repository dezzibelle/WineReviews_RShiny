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
                  menuItem("Background", tabName = "background", icon = icon("cloud")),
                  menuItem("Ratings vs. Price", tabName = "ptsPrice", icon = icon("dollar")),
                  menuItem("Wine Chooser", tabName = "wineChooser", icon = icon("glass")),
                  menuItem("Wines by Region", tabName = "wineRegions", icon = icon("globe"))
                ) #end sidebarMenu
              ), #end sidebar
## -- BODY: ######################
              dashboardBody(
                tabItems(
## -- FIRST TAB: ######################
                  tabItem(tabName = "background",
                         h2("Project Background"),
                         br(),
                         h4("* Over 120,000 reviews, 20 different tasters"),
                         h4(uiOutput("WineMag")),
                         h4("* More than 110,000 different wines from 42 countries"),
                         h4("* Ratings ranged between 80-100 points"),
                         h4("* Wines priced at $4-$3300 per bottle")
                  ), #end 1st tab
                  
## -- SECOND TAB: ######################
                  tabItem(tabName = "ptsPrice", 
                          h3("Do Wine Ratings Correlate with Price?"),
                          
                          fluidRow(
                            box(plotOutput("plot1", height = 250)), #plot pts vs. price
                            box(plotOutput("plot2", height = 250))  #plot pts vs. log(price)
                          ),
                            # h4("A wine's rating and its price have ", correlation),
                          fluidRow(
                            box(plotOutput("hist1", height = 250)), #histogram, color by country 
                            box(plotOutput("hist2", height = 250))  #histogram, color by variety
                          )
                          
                  ), #end 2nd tab

## -- THIRD TAB: ######################
                  tabItem(tabName = "wineChooser", 
                          h3("Choose the top 20 highest-rated wines based on price range and varietal"),
                          fluidRow(
                          box(
                            selectInput("varietal", 
                                        label = "Choose a varietal:",
                                        choices = top_varieties,
                                        selected = "Pinot Noir"), 
                          
                            radioButtons("pricerange", label = h3("Select a price range:"),
                                         choices = list("< $10" = 1, "$10 - $25" = 2, "$25 - $50" = 3,
                                                        "$50 - $100" = 4, "$100 - $500" = 5, "< $500" = 6), 
                                         selected = 1),
                            width = 3, height = 350),
                          box(
                          tableOutput("selected_wines"), width = 9 
                          ))
                  ), #end 3rd tab
                  
## -- FOURTH TAB: ######################
                  tabItem(tabName = "wineRegions", 
                          h3("Most popular varietal produced by each country:"),
                          
                          fluidRow(
                            htmlOutput("map", width = 400) 
                                    )
                          # fluidRow(
                          #   htmlOutput("pie1")
                          #         )
                          ) #end 4th tab
                ) #end tabItems
              ) #end Body 
) #end Page

