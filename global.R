library(shiny)
library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)
library(googleVis)
library(leaflet)
library(maps)

###############################
#----Load Data & Setup Variables----#

load("wine_dfR.RData")

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


###############################
#---------MAPPING------------#


# map("world", fill = TRUE, plot = FALSE)

