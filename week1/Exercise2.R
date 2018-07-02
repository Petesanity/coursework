library(tidyverse)
table2
#A

spread(table2, type,count) %>%  mutate(rate = cases/ population *10000)


#B
table4a
table4b

tbl4a <- table4a %>% gather(`1999`, `2000`,key = "year", value = "cases")
tbl4b <- table4b %>% gather(`1999`, `2000`, key = "year", value = "population")
inner_join(tbl4a, tbl4b) %>% mutate(rate = cases/ population *10000)
