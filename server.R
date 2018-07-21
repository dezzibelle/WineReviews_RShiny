library(shiny)

shinyServer(function(input, output) {
  

  output$selected_var <- renderText({
    paste("You have selected", input$varietal)
  })

  output$range <- renderText({
    paste("You have chosen a price range that goes from $",
          input$pricerange[1], " to $", input$pricerange[2])
  })

output$selected_var1 <- renderPlot({
  ggplot(data = (wine_df %>%
                   filter(variety == input$varietal) %>%
                   distinct(title, price, ave_score)),
         aes(x=price,y=ave_score)) +
    geom_point(aes(color=price)) +
    geom_smooth(method = "loess") +
    coord_cartesian(xlim = c(0,500), ylim = c(75,100))
 })
  
})
