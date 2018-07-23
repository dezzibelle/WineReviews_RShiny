## server.R ##

library(shiny)
library(shinydashboard)

function(input,output) {

  url <-a("Wine Enthusiast Magazine", href="https://www.winemag.com/")
  output$WineMag <-renderUI({
  tagList(url)
  })
  
  output$plot1 <- renderPlot({
    ggplot(wine_sampdf2, aes(x=price,y=ave_score)) + 
      geom_point(position = "jitter") + geom_smooth(method = "loess") +
      coord_cartesian(ylim = c(80,100)) + 
      labs(title = "Rating vs. Price") + 
      scale_x_continuous(name = "Price ($)") +
      scale_y_continuous(name = "Points")
  })

  output$plot2 <- renderPlot({
    ggplot(wine_sampdf2, aes(x=log(price),y=ave_score)) + 
      geom_point(position = "jitter") + geom_smooth(method = "lm") +
      coord_cartesian(ylim = c(80,100)) + 
      labs(title = "Rating vs. log(Price)") + 
      scale_x_continuous(name = "log(Price ($))") +
      scale_y_continuous(name = "Points")
  })
    
  output$hist1 <- renderPlot({
    ggplot(wine_sampdf2 %>% filter(country %in% wine_countries[1:10]),aes(x=ave_score)) + 
      geom_histogram(bins=21, aes(fill=country)) + 
      labs(title = "Histogram of Wine Ratings", subtitle = "for Top 10 Wine-Producing Countries") + 
      scale_x_continuous(name = "Rating") +
      scale_y_continuous(name = "")
  })
  
  output$hist2 <- renderPlot({
    ggplot(wine_sampdf2 %>% filter(variety %in% top_varieties[1:10]),aes(x=ave_score)) + 
      geom_histogram(bins=21, aes(fill=variety)) + 
      labs(title = "Histogram of Wine Ratings", subtitle = "for Top 10 Wine Varietals") + 
      scale_x_continuous(name = "Rating") +
      scale_y_continuous(name = "")
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
      mutate(Rank = row_number()) %>%
      rename(Wine = title, Country = country, "Price ($)" = price, Rating = ave_score ) %>%
      select(Rank, Wine, Country, "Price ($)", Rating) %>%
      top_n(20, desc(Rank))
  },digits=0)
  
  output$map <- renderGvis({
    gvisGeoChart(wine_df3, "country", hovervar = "variety")
  })
      
  # output$pie1 <- renderGvis({
  #   gvisPieChart(wine_df3$country, 
  #                labelvar = "variety", 
  #                numvar = "count", 
  #                options = (sliceVisibilityThreshold = .25))
  # })
  
}