library(tidycensus)
library(tidyverse)
library(janitor)
library(stringr)
library(scales)
library(ggthemes)
library(leaflet)
library(sf)
library(stringr)
library(rmarkdown)
library(knitr)
library(reshape2)
library(DT)

census_api_key(Sys.getenv("CENSUS_API_KEY"))


acs_variable_list <- load_variables(2017, "acs5", cache = TRUE)

B1001_vars <- acs_variable_list %>%
  filter(str_detect(name, "^B01001_") | str_detect(name, "^B01001B") | str_detect(name, "^B01001C") |
           str_detect(name, "^B01001D") | str_detect(name, "^B01001F") |str_detect(name, "^B01001G") |
           str_detect(name, "^B01001H") | str_detect(name, "^B01001I")) %>%
  pull(name)



years <- lst( 2017)

sex_by_age <-  map_dfr(
  years,
  ~ get_acs(
    geography = "state",
    state="MN",
    variables = B1001_vars,
    year = .x,
    survey = "acs1"
  ),
  .id = "year"
) %>% clean_names() 

sex_by_age <-  left_join(sex_by_age, acs_variable_list %>% select(name, label), by=c("variable"="name")) %>% 
  mutate(label=case_when(label=='Estimate!!Total'~ 'Total', TRUE ~str_sub(label,18,255)))

sex_by_age <-  sex_by_age %>% mutate(gender = case_when(str_sub(label,1,3)=='Tot'~'Total',
                                                                    str_sub(label,1,3)=='Fem'~'Female',
                                                                    str_sub(label,1,3)=='Mal'~'Male'))

sex_by_age <-  sex_by_age %>% mutate(agegroup = case_when(grepl("Under 5", label) ~ 'Under 5',
                                                                      grepl("5 to 9", label)~'5 to 9',
                                                                      grepl("10 to 14", label)~'10 to 17',
                                                                      grepl("15 to 17", label)~'10 to 17',
                                                                      grepl("18 and", label)~'18 to 24',
                                                                      grepl("20", label)~'18 to 24',
                                                                      grepl("21", label)~'18 to 24',
                                                                      grepl("20 to 24", label)~'18 to 24',
                                                                      grepl("22 to 24", label)~'18 to 24',
                                                                      grepl("25 to", label)~'25 to 34',
                                                                      grepl("30 to", label)~'25 to 34',
                                                                      grepl("35 to", label)~'35 to 44',
                                                                      grepl("40 to", label)~'35 to 44',
                                                                      grepl("45 to", label)~'45 to 54',
                                                                      grepl("50 to",label)~'45 to 54',
                                                                      grepl("55 to", label)~'55 to 64',
                                                                      grepl("60 and", label)~'55 to 64',
                                                                      grepl("62 to", label)~'55 to 64',
                                                                      grepl("65 to", label)~'65 to 74',
                                                                      grepl("65 and", label)~'65 to 74',
                                                                      grepl("70 to", label)~'65 to 74',
                                                                      grepl("67 to", label)~'65 to 74',
                                                                      grepl("75 to", label)~'75 to 84',
                                                                      grepl("80 to", label)~'75 to 84',
                                                                      grepl("85 years",label)~'85 and up',
                                                                      TRUE~'Total') )

sex_by_age <-  sex_by_age %>% mutate(racialgroup = case_when(str_sub(variable,1,7)=='B01001B'~'Black',
                                                                         str_sub(variable,1,7)=='B01001C'~'Am Indian',
                                                                         str_sub(variable,1,7)=='B01001D'~'Asian',
                                                                         str_sub(variable,1,7)=='B01001E'~ 'Pac Isl',
                                                                         str_sub(variable,1,7)=='B01001F'~'Other',
                                                                         str_sub(variable,1,7)=='B01001G' ~'Multi',
                                                                         str_sub(variable,1,7)=='B01001H'~ 'White-NonHispanic',
                                                                         str_sub(variable,1,7)=='B01001I'~'Hispanic',
                                                                         str_sub(variable,1,7)=='B01001_'~'Total'))

sex_by_age <-  sex_by_age %>% mutate(largegroup = case_when(racialgroup=='White-NonHispanic'~'White',
                                                                        racialgroup=='Total'~'Total',
                                                                        TRUE~'People of color'))



sex_by_age2 <-  sex_by_age %>% group_by(gender, agegroup, racialgroup, largegroup) %>% summarise(est=sum(estimate))

under5 <-  sex_by_age2 %>% filter(agegroup=='Under 5') %>% group_by(largegroup) %>% summarise(estimate=sum(est))
