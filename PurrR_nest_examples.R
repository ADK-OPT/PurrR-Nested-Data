library(tidyverse)
library(readxl)
library(janitor)
library(lubridate)

data_2023 <- read_excel(r"(C:\Users\adkay\OneDrive - Ohio Auditor of State\Desktop\2023Data.xlsx)") # path will very by user


nested_data <- data_2023 %>%
  select(c(2,3,9,10)) %>%  #grabs columns we want.. next line filters out Leave, Admin, Open time
  filter(!`Please Indicate the Project you expect to work on in the next week...` %in% c("Leave","Administrative (Assigned Other, Cont Improv., etc...)","Available hours / Uncommitted hours")) %>%
  clean_names() %>% # easier to tread
  group_by(week_start,name) %>% 
  nest()




df3 <- nested_data %>% 
  mutate(charge_hrs = map_dbl(.x=data, ~ sum(.x$how_many_hours_are_you_expecting_to_work_on_the_above_task))) # in each nested dataframe, get a sum of projected hours, and outputs outside the nested data

df_final2 <- df3 %>% 
  arrange(name,week_start) # sorting



library(writexl)

write_xlsx(df_final2, "C:/Users/adkay/OneDrive - Ohio Auditor of State/Desktop/Project_Hours_Data.xlsx") # path will very by user