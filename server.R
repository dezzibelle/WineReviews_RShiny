## server.R ##

library(shiny)
library(shinydashboard)


function(input,output) {

  output$plot1 <- renderPlot({
    ggplot(wine_sampdf2, aes(x=price,y=ave_score)) + 
      geom_point() + geom_smooth(method = "loess") +
      coord_cartesian(ylim = c(80,100))
  })
  
  output$hist1 <- renderPlot({
    ggplot(wine_sampdf2 %>% filter(country %in% wine_countries[1:10]),aes(x=ave_score)) + 
      geom_histogram(bins=21, aes(fill=country))
  })
  
  output$hist2 <- renderPlot({
    ggplot(wine_sampdf2 %>% filter(variety %in% top_varieties[1:10]),aes(x=ave_score)) + 
      geom_histogram(bins=21, aes(fill=variety))
  })
  
  output$selected_variety <- renderText({
    paste0("These are the the top-rated ", 
           input$varietal, " wines with a price between $",
           input$pricerange[1], " and $", input$pricerange[2],".")
  })
  
  output$selected_wines <- renderTable({
    wine_df %>%
      filter(variety == input$varietal,
             price >= input$pricerange[1] &
               price <= input$pricerange[2]) %>%
      distinct(title, country, price, ave_score) %>%
      arrange(desc(ave_score),desc(price)) %>%
      mutate(rank = row_number()) %>%
      select(rank, title, country, price, ave_score) %>%
      top_n(20, desc(rank))
  })
  
  
  
  
  
  
}