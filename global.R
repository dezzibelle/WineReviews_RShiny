library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)
library(googleVis)
library(leaflet)
library(maps)
library(scales)


###############################
#----Load Data & Setup Variables----#

load("wine_dfR.RData")

#Filters for Price & Point Range Selectors:
wine_df = wine_df %>%
  mutate(price_range = case_when(price <= 10 ~ 1,
                               price <=25 & price > 10 ~ 2,
                               price <=50 & price > 25 ~ 3,
                               price <=100 & price > 50 ~ 4,
                               price <=500 & price >100 ~ 5,
                               price > 500 ~ 6))

y_int = 78.978654
m = 6.556461

wine_df = wine_df %>%
  mutate(Rating = case_when(ave_score <= 82 ~ "Acceptable", 
                            ave_score <= 86 & ave_score >= 83 ~ "Good",
                            ave_score <= 89 & ave_score >= 87 ~ "Very Good",
                            ave_score <= 93 & ave_score >= 90 ~ "Excellent",
                            ave_score <= 97 & ave_score >= 94 ~ "Superb",
                            ave_score >= 98 ~ "Classic")) %>%
  mutate(model_score = y_int + m * log10(price)) %>%
  mutate(Value = case_when(ave_score > (+model_score + 2.5) ~ "Good Value"))

#create lists for selectors/filters

top_varieties = wine_df %>%   
                   group_by(variety) %>% 
                   distinct(title) %>%
                   summarise(count = n()) %>% 
                   arrange(desc(count))
top_varieties = as.character(top_varieties$variety)
top_var = c("All",sort(top_varieties[1:25]))


wine_countries = wine_df %>% 
                    group_by(country) %>% 
                    drop_na(country) %>%
                    summarise(count = n()) %>% 
                    arrange(desc(count))
wine_countries = as.character(wine_countries$country)




#Reduced data set - for distinct wines, average rating from multiple reviews
wine_df2 = wine_df[c("title","winery","variety","country","province","price","ave_score")] %>%
  distinct(title,price,ave_score, variety, country) 



#Sampled data set for graphing (Rating vs. Price)
set.seed(1)
wine_sampdf2 = wine_df2[sample(nrow(wine_df2),5000),]


# #Data sets for bar graphs
# wbar1 = wine_df2 %>% 
#   filter(country %in% wine_countries[1:5], 
#          variety %in% top_varieties[1:10]) %>% 
#   group_by(country,variety) %>%
#   summarise(mean_rating = mean(ave_score))
# 
# 
# wbar2 = wine_df2 %>%
#   filter(country %in% wine_countries[1:5],
#          variety %in% top_varieties[1:10]) %>%
#   group_by(country,variety) %>%
#   summarise(median_price = median(price))


###############################
#---------MAP DATA------------#

wine_df3 = wine_df2 %>% 
  group_by(country,variety) %>%
  summarise(count = n(), "Ave.Rating" = mean(ave_score)) %>%
  arrange(country, desc(count)) %>% 
  filter(count == max(count)) %>% select(country,variety,"Ave.Rating")

wine_df4 = wine_df %>%
  filter(country == "US", province != "America") %>%
  group_by(province,variety) %>%
  summarise(count = n(),"Ave.Rating" = mean(ave_score)) %>%
  arrange(province, desc(count)) %>%
  filter(count == max(count)) %>% select(province, variety, "Ave.Rating")
