# Juho Pirhonen 2017-11-08 Opening and reformatting data

# Load required packages
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)

# Load dataframe
df <- "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt" %>% 
  read.table(header = T, sep = "\t") %>% tbl_df()
glimpse(df)

# There is no ID for subjects, add a basic row-num just in case
df <- df %>% mutate(row_id = row_number())

summary(df)
# So 183 observations and 60 variables. Gonna need some info on the variables
# All but one are loaded as integer variables, with only 5 possible values. 
# So we are probably dealing with likert data, an ordered factor data type. 



# Create a simple frame to quickly check variable info
info <- read.delim("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt", 
                   header = F, sep = "\t", encoding = "latin1")[14:107,]
# There are more variables in info than in df, but I will not spend time on cleaning it more. 
info



# Creating analysis dataframe
# Current df doesn't have deep, stra, or surf, but can be counted as follows
info[73:75]
# And 
info [65:72]
# So all ST for stra, SU for surf. 
df$surf <- df %>% names() %>% str_subset("SU") %>% select(df, .) %>% rowMeans()
df$stra <- df %>% names() %>% str_subset("ST") %>% select(df, .) %>% rowMeans()
# D is special as there are D+alphabet variables that measure attitude, hence grepping
df %>% names() %>% str_subset("D[0-9]") %>% select(df, .)
df$deep <- df %>% names() %>% str_subset("D[0-9]") %>% select(df, .) %>% rowMeans()
analysis <- select(df, gender, Age, Attitude, deep, stra, surf, Points)
analysis


# Remove subjects with zero points
analysis <- filter(analysis, Points != 0)
analysis

# Save csv and reread it to prove a point
write.csv(analysis, file = "data/learning2014.csv", row.names = F)
prove <- read.csv("data/learning2014.csv")
str(prove)
head(prove)
