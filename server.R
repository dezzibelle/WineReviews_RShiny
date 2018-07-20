library(shiny)

shinyServer(function(input, output) {

  output$selected_var <- renderText({
    paste("You have selected", input$varietal)
    })

  output$selected_var <- renderPlot({
    ggplot(data = (wine_df %>% filter(variety == input$varietal)), aes(x=price,y=ave_score)) + 
      geom_point(aes(color=price))
  })
  
})
