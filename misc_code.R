library(googleVis)

#global.R


#server.R

output$map <- renderGvis({
  gvisGeoChart(wine_df2, "country", variety,
               options= list(region="world",width = "auto", height="auto"))
})

output$hist <- renderGvis(
  gvisHistogram(wine_df2[,variety,drop=FALSE])
)


gvisPieChart(wine_df3$country, 
             labelvar = "variety", 
             numvar = "count", 
             options = (sliceVisibilityThreshold = .25))

wine_df4 = wine_df3 %>% 
  group_by(country) %>%
  (top_n(variety,5))

descriptors_list = c("apple", "pineapple", "pear", "peach", "lemon", "cherry",
                     "vanilla", "tobacco", "orange", "caramel", "chocolate",
                     "earthy", "dry", "sweet", "peppery", "sour", "bitter", 
                     "crisp", "zesty", "floral")

library(stringr)
wine_desc = wine %>% mutate(desc = str_match(description, descriptors_list))


x = wine_df2 %>% 
  group_by(country,variety) %>%
  mutate(count = n()) %>%
  arrange(country, desc(count))
