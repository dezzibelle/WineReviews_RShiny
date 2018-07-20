library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)
library(stringr)


#install.packages("RColorBrewer")
library(RColorBrewer)
#display.brewer.all()
#install.packages("mapproj")
library(mapproj)

wine = read_csv("winemag-data.csv")

###############################
#---------SETUP DF------------#

wine_df = cbind(wine[2:10],wine[12:14])
wine_df = wine_df %>% 
  drop_na(points,price)
wine_df = wine_df %>% 
  mutate(country = as.factor(country),
         province = as.factor(province),
         taster_name = as.factor(taster_name),
         variety = as.factor(variety))

wine_df = wine_df %>% 
  mutate(price_range = case_when(price <= 10 ~ "< $10", 
                                 price <=25 & price > 10 ~ "$10-$25",
                                 price <=50 & price > 25 ~ "$25-$50",
                                 price <=100 & price > 50 ~ "$50-$100",
                                 price <=500 & price >100 ~ "$100-$500",
                                 price > 500 ~ "> $500"))

ave_scores = wine_df %>%
  group_by(title) %>% 
  summarise(ave_score = as.integer(mean(points)))

joined = inner_join(wine_df,ave_scores, by = 'title')

wine_df = joined %>% 
  mutate(point_range = case_when(ave_score <= 85 ~ "< 85", 
                                 ave_score <= 90 & ave_score > 85 ~ "85-90",
                                 ave_score <= 95 & ave_score > 90 ~ "90-95",
                                 ave_score <=100 & ave_score > 95 ~ "95-100"))

wine_df = wine_df %>% 
  mutate(price_range = as.factor(price_range), point_range = as.factor(point_range))  ##best df to analyze

###############################
#--------SAMPLE INPUTS----------#
input_variety = 'Pinot Noir'  #take from top_variety selector df
input_country = 'Argentina'  #take from top_country selector df
input_pricerange = '$10-$25'  #take from top_variety selector df

###############################
#---------SELECTORS-------------#
#create lists for selectors

top_varieties = (wine_df %>%   
                   group_by(variety) %>% 
                   distinct(title) %>%
                   summarise(count = n()) %>% 
                   arrange(desc(count)) %>% 
                   top_n(25,count) %>%
                   select(variety))[[1]]

wine_countries = (wine_df %>% 
                    group_by(country) %>% 
                    drop_na(country) %>%
                    summarise(count = n()) %>% 
                    arrange(desc(count)) %>% 
                    select(country))[[1]]

tasters = (wine_df %>%
             select(taster_name) %>%
             drop_na(taster_name) %>%
             distinct(taster_name))[[1]]

multi_reviews = (wine_df %>% 
  group_by(title) %>% 
  summarise(count = n()) %>% 
  filter(count > 1) %>% 
  arrange(desc(count)) %>%
  top_n(11,count) %>%
  select(title))[[1]]


###############################
#----------OUTPUTS-------------#


#----------LISTS-------------#

#A - top 10 best scoring wines by variety
#B - top 10 best scoring wines by price range
#C - combo of A&B?
#D - list of varieties in a region/country (chosen on map)


#----------GRAPHS-------------#

#1 - map locations

#2 - graph comparison of reviewers' scores for different wines

ggplot(data = wine_df %>% filter(title == "Gloria Ferrer NV Sonoma Brut Sparkling (Sonoma County)"), 
       aes(x=taster_name, y=points)) + geom_col()


#3 - graph of price vs score for specified variety


  
ggplot(data = wine_df %>% filter(variety == "Prosecco") %>% distinct(title, price, ave_score), aes(x=price,y=ave_score)) + 
  geom_point(aes(color=price)) 

#filter out highest prices:
ggplot(data = wine_df %>% filter(variety == "Pinot Noir"), aes(x=ave_score,y=price)) + 
  geom_point(aes(color=price)) + coord_cartesian(ylim = c(0,750))



#Statistics:
compare = wine_df %>% distinct(title,price,ave_score) %>% select(title, price, ave_score)
cor.test(compare$price, compare$ave_score)




######## Clean-up Code (removed from Global): #########

wine = read_csv("winemag-data.csv")

###############################
#---------SETUP DF------------#

wine_df = cbind(wine[2:10],wine[12:14])
wine_df = wine_df %>%
  drop_na(points,price,country,variety) %>%
  mutate(country = as.factor(country),
         province = as.factor(province),
         taster_name = as.factor(taster_name),
         variety = as.factor(variety)) %>%
  mutate(price_range = case_when(price <= 10 ~ "< $10",
                                 price <=25 & price > 10 ~ "$10-$25",
                                 price <=50 & price > 25 ~ "$25-$50",
                                 price <=100 & price > 50 ~ "$50-$100",
                                 price <=500 & price >100 ~ "$100-$500",
                                 price > 500 ~ "> $500"))

ave_scores = wine_df %>%
  group_by(title) %>%
  summarise(ave_score = as.integer(mean(points)))

joined = inner_join(wine_df,ave_scores, by = 'title')

wine_df = joined %>%
  mutate(point_range = case_when(ave_score <= 85 ~ "< 85",
                                 ave_score <= 90 & ave_score > 85 ~ "85-90",
                                 ave_score <= 95 & ave_score > 90 ~ "90-95",
                                 ave_score <=100 & ave_score > 95 ~ "95-100")) %>%
  mutate(price_range = as.factor(price_range),
         point_range = as.factor(point_range)) %>%
  mutate(year = as.integer(str_extract(title,"(19|20)\\d{2}")))

#rearrange columns
wine_df = wine_df[c("title","winery","variety","designation","year","country",
                    "province","region_1","region_2","price","price_range",
                    "taster_name","points","ave_score","point_range")]   

#remove temp data
rm(joined, wine, ave_scores)

#reduces wine_df from 24.7 MB to 22.8 MB
wine_df2 = wine_df[c("title","winery","variety","designation","year","country","province","price","price_range","taster_name","points","ave_score","point_range")]

