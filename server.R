library(shiny)

shinyServer(function(input, output) {
  
  
  output$selected_variety <- renderText({
    paste("You have selected the top rated ", 
          input$varietal, "wines with a price between $",
          input$pricerange[1], " and $", input$pricerange[2],".")
  })
  
  # output$selected_range <- renderText({
  #   paste("with a price between $",
  #         input$pricerange[1], " and $", 
  #         input$pricerange[2])
  # })
  
  output$selected_wines <- renderTable({
    wine_df %>%
      filter(variety == input$varietal, 
             price >= input$pricerange[1] & 
               price <= input$pricerange[2]) %>%
      distinct(title, country, price, ave_score) %>%
      arrange(desc(ave_score)) %>% 
      mutate(rank = row_number()) %>% 
      select(rank, title, country, price, ave_score) %>%
      top_n(20,ave_score)
  })
  
  output$price_vs_pts <- renderPlot({
    ggplot(data = (wine_df %>%
                     filter(variety == input$varietal, 
                            price >= input$pricerange[1] & 
                              price <= input$pricerange[2]) %>%
                     distinct(title, price, ave_score)),
           aes(x=price,y=ave_score)) +
      geom_point(aes(color=price)) +
      geom_smooth(method = "loess") +
      coord_cartesian(ylim = c(75,100))
  })
  
})
