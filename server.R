## server.R ##

library(shiny)
library(shinydashboard)


function(input,output) {
  set.seed(122)
  histdata <- rnorm(500)

  
  
  output$plot1 <- renderPlot( {
    data <- histdata[seq_len(input$slider)]
    hist(data)
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