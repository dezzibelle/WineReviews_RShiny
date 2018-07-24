library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)
library(googleVis)
library(leaflet)
library(maps)
library(DT)

###############################
#----Load Data & Setup Variables----#

load("wine_dfR.RData")
wine_df = wine_df %>%
  mutate(price_range = case_when(price <= 10 ~ 1,
                               price <=25 & price > 10 ~ 2,
                               price <=50 & price > 25 ~ 3,
                               price <=100 & price > 50 ~ 4,
                               price <=500 & price >100 ~ 5,
                               price > 500 ~ 6))

#create lists for selectors/filters

top_varieties = (wine_df %>%   
                   group_by(variety) %>% 
                   distinct(title) %>%
                   summarise(count = n()) %>% 
                   arrange(desc(count)) %>% 
                   top_n(50,count) %>%
                   arrange(variety) %>%
                   select(variety))[[1]]

wine_countries = (wine_df %>% 
                    group_by(country) %>% 
                    drop_na(country) %>%
                    summarise(count = n()) %>% 
                    arrange(desc(count)) %>% 
                    select(country))[[1]]

#Reduced data set
wine_df2 = wine_df[c("title","winery","variety","country","province","price","ave_score")] %>%
  distinct(title,price,ave_score, variety, country) 

#Sampled data set for graphing
set.seed(1)
wine_sampdf2 = wine_df2[sample(nrow(wine_df2),5000),]

# #Correlation calc:
# correlation = cor.test(wine_sampdf2$price, wine_sampdf2$ave_score)


###############################
#---------MAPPING------------#

wine_df3 = wine_df2 %>% 
  group_by(country,variety) %>%
  summarise(count = n()) %>%
  arrange(country, desc(count)) %>% 
  filter(count == max(count)) %>% select(country,variety)
