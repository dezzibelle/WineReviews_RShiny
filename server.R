## server.R ##

library(shiny)
library(shinydashboard)

function(input,output) {

  url <-a("Wine Enthusiast Magazine", href="https://www.winemag.com/")
  output$WineMag <-renderUI({
  tagList(url)
  })
  
  url2 <-a("Kaggle Dataset: Wine Reviews",href="https://www.kaggle.com/zynicide/wine-reviews")
  output$Kaggle <-renderUI({
    tagList(url2)
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
    ggplot(wine_sampdf2, aes(x=log10(price),y=ave_score)) + 
      geom_point(position = "jitter") + geom_smooth(method = "lm") +
      coord_cartesian(ylim = c(80,100)) + 
      labs(title = "Rating vs. log(Price)") + 
      scale_x_continuous(name = "log(Price ($))") +
      scale_y_continuous(name = "Points")
  })
 
#Data sets for bar graphs

  

 
  output$barGraph1 <- renderPlot ({
#    if (input$swapPlot == 2) {

    wbar1 = wine_df2 %>%
      filter(country %in% wine_countries[1:5],
             variety %in% input$pickVar) %>%
      group_by(country,variety) %>%
      summarise(median_price = median(price))
    
      ggplot(wbar1, aes(x=variety, y=median_price)) + 
        geom_col(position="dodge", aes(fill=country)) + 
        scale_y_continuous(limits=c(5,65), oob = rescale_none) +
        coord_flip() +
        labs(title = "Median Varietal Prices by Country")
    })  
#    else  {
  output$barGraph2 <- renderPlot ({
    
    wbar2 = wine_df2 %>% 
      filter(country %in% wine_countries[1:5], 
             variety %in% input$pickVar) %>% 
      group_by(country,variety) %>%
      summarise(mean_rating = mean(ave_score))
    
      ggplot(wbar2, aes(x=variety, y=mean_rating)) + 
        geom_col(position="dodge", aes(fill=country)) + 
        scale_y_continuous(limits=c(80,95), oob = rescale_none) +
        coord_flip() + 
        labs(title = "Average Varietal Ratings by Country")
#    }
  })
  
  output$selected_wines <- DT::renderDataTable(DT::datatable({
    if(input$varietal == "All") {
      wine_df %>%
        filter(variety == variety,
               price_range == input$pricerange, 
               Rating %in% input$pointcategory) %>%
        distinct(title, country, year, price, ave_score, Value) %>%
        arrange(desc(ave_score),desc(price)) %>%
        mutate(Rank = row_number()) %>%
        rename(Wine = title, Country = country, Year = year, "Price ($)" = price, Rating = ave_score ) %>%
        select(Wine, Country, Year, "Price ($)", Rating, Value)
    }
    else{
      wine_df %>%
        filter(variety == input$varietal,
               price_range == input$pricerange, 
               Rating %in% input$pointcategory) %>%
        distinct(title, country, year, price, ave_score, Value) %>%
        arrange(desc(ave_score),desc(price)) %>%
        mutate(Rank = row_number()) %>%
        rename(Wine = title, Country = country, Year = year, "Price ($)" = price, Rating = ave_score ) %>%
        select(Wine, Country, Year, "Price ($)", Rating, Value)
    }
  }))
  
  output$map <- renderGvis({
    gvisGeoChart(wine_df3, "country", hovervar = "variety", 
                 colorvar = "Ave.Rating",
                 options=list(colorAxis="{colors:['pink','maroon']}",
                              backgroundColor="lightblue")
    )
  })
  
  output$map2 <- renderGvis({
    gvisGeoChart(wine_df4, "province", hovervar = "variety",
                 colorvar = "Ave.Rating", 
                 options=list(region="US", displayMode="regions", resolution="provinces",
                              colorAxis="{colors:['pink','maroon']}",backgroundColor="lightblue")
                 )
  })
  
}