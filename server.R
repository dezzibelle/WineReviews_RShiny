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
 
  #Data sets for bar graphs
  wbar1 = wine_df2 %>% 
    filter(country %in% wine_countries[1:5], 
           variety %in% top_varieties[1:10]) %>% 
    group_by(country,variety) %>%
    summarise(mean_rating = mean(ave_score))
  
  wbar2 = wine_df2 %>%
    filter(country %in% wine_countries[1:5],
           variety %in% top_varieties[1:10]) %>%
    group_by(country,variety) %>%
    summarise(median_price = median(price))
 
  output$barGraph <- renderPlot ({
    if (input$swapPlot == 2) {
      ggplot(wbar2,aes(x=variety, y=median_price)) + 
        geom_col(position="dodge", aes(fill=country)) + 
        scale_y_continuous(limits=c(5,65), oob = rescale_none) +
        coord_flip() +
        labs(title = "Median Varietal Prices by Country")
    }  
    else  {
      ggplot(wbar1,aes(x=variety, y=mean_rating)) + 
        geom_col(position="dodge", aes(fill=country)) + 
        scale_y_continuous(limits=c(80,95), oob = rescale_none) +
        coord_flip() + 
        labs(title = "Average Varietal Ratings by Country")
    }
  })
  
  # output$hist1 <- renderPlot({
  #   ggplot(wine_sampdf2 %>% filter(country %in% wine_countries[1:10]),aes(x=ave_score)) + 
  #     geom_histogram(bins=21, aes(fill=country)) + 
  #     labs(title = "Histogram of Wine Ratings", subtitle = "for Top 10 Wine-Producing Countries") + 
  #     scale_x_continuous(name = "Rating") +
  #     scale_y_continuous(name = "")
  # })
  # 
  # output$hist2 <- renderPlot({
  #   ggplot(wine_sampdf2 %>% filter(variety %in% top_varieties[1:10]),aes(x=ave_score)) + 
  #     geom_histogram(bins=21, aes(fill=variety)) + 
  #     labs(title = "Histogram of Wine Ratings", subtitle = "for Top 10 Wine Varietals") + 
  #     scale_x_continuous(name = "Rating") +
  #     scale_y_continuous(name = "")
  # })
  #
  
  output$selected_wines <- renderTable({
    wine_df %>%
      filter(variety == input$varietal,
             price_range == input$pricerange) %>%
            distinct(title, country, price, ave_score) %>%
      arrange(desc(ave_score),desc(price)) %>%
      mutate(Rank = row_number()) %>%
      rename(Wine = title, Country = country, "Price ($)" = price, Rating = ave_score ) %>%
      select(Rank, Wine, Country, "Price ($)", Rating) %>%
      top_n(20, desc(Rank))
  },digits=0)
  
  output$map <- renderGvis({
    gvisGeoChart(wine_df3, "country", hovervar = "variety", 
                 colorvar = "count",
                 options=list(colorAxis="{colors:['pink','maroon']}",
                              backgroundColor="lightblue")
    )
  })
  
  output$map2 <- renderGvis({
    gvisGeoChart(wine_df4, "province", hovervar = "variety",
                 colorvar = "count", 
                 options=list(region="US", displayMode="regions", resolution="provinces",
                              colorAxis="{colors:['pink','maroon']}",backgroundColor="lightblue")
                 )
  })
  
}