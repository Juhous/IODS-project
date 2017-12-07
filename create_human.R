# Juho Pirhonen
# Data originates from http://hdr.undp.org/en/content/human-development-index-hdi
# Data wrangling for Dimensionality reduction exercise 

library(magrittr)
library(ggplot2)
library(stringr)
library(tidyr)
library(dplyr)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", 
               stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", 
                stringsAsFactors = F, na.strings = "..")

str(hd)
str(gii)

names(hd) <- c("HDIr", "country", "HDI", "lifeExp", "expEdu", "meanEdu", "GNIC", "GNICr_HDIr")
names(gii) <- c("GIIr", "country", "GII", "matMort", "adolBirthRate", "reprParl", 
                "edu2F", "edu2M", "labF", "labM")
summary(hd)
summary(gii)

gii %<>% mutate(eduRatio = edu2F/edu2M, labRatio = labF/labM)

human <- inner_join(hd, gii, by = "country")
glimpse(human)

human %<>% mutate(GNIC = as.numeric(str_replace(GNIC, ",", "")))
glimpse(human)
human %<>% dplyr::select(country, eduRatio, labRatio, expEdu, lifeExp, 
                  GNIC, matMort, adolBirthRate, reprParl)
glimpse(human)

human %<>% filter(complete.cases(.)) 

tail(human,10)
human <- human[1:155,]

rownames(human) <- human$country
human %<>% dplyr::select(-country)

glimpse(human)

write.csv(human, file = "data/human.csv")
