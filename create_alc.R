# Juho Pirhonen 2017-11-20
# Data is from: https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip
library(dplyr, warn.conflicts = F)
library(tidyr)
library(purrr)

mat <- read.csv("data/student-mat.csv", sep = ";")
por <- read.csv("data/student-por.csv", sep = ";")

glimpse(mat)
glimpse(por)

joined <- c("school", "sex", "age", 
          "address", "famsize", "Pstatus", 
          "Medu", "Fedu", "Mjob", "Fjob", 
          "reason", "nursery","internet")

matPor <- inner_join(mat, por, by = joined) 
glimpse(matPor)

sapply(list(mat,por,df), dim)



unjoined <- select(por, -one_of(joined)) %>% names()
unjoined
is_num <- select(por, unjoined) %>% sapply(is.numeric)
is_num

df <- matPor %>% select(joined)
for(col in unjoined) {
  if(is_num[col]==T) {
    df[col] <- matPor %>%
      select(starts_with(col)) %>%
      rowMeans()
  }
  else{
    df[col] <- select(matPor, starts_with(col))[1] 
  }
}

glimpse(df)
rm(matPor, joined, unjoined, col, is_num, mat, por)

df <- mutate(df, alc_use = (Dalc+Walc)/2)
df <- mutate(df, high_use = alc_use > 2)
glimpse(df)

write.csv(df, file = "data/alc")
