# this script does the following:
# 1. Imports survey data from googlesheets
# 2. Does some pre-processing for column names
# 3. Does some pre-processing for the free text gender field

language <- "English" # may also be "Spanish"

# packages needed
library(googlesheets)
library(tidyverse)
library(RColorBrewer)
library(gendercodeR)
library(here)


##############################################################
### This section begins the mainline code to read the survey #
##############################################################

# For xaringan slides, we'll output the processed data to a tsv file at this path:
survey_tsv_path <- here::here("slides/data", paste0("survey_", language,".tsv"))

# First, we'll just read in the data and fix all the question names, which in Google Forms, are literally
# the full text of the question. I've put short question names on another sheet of the results Google Sheet, so
# we do the substitution here.

mysheets <- gs_ls() # will authenticate

sheet_name <- case_when(
  language == "English" ~ "Learning R Internet Survey",
  language == "Spanish" ~ "Learning R Internet Survey (Spanish Version)",
  TRUE ~ "Unknown language"
)

if (sheet_name == "Unknown language") {
  print ("Language not set to Spanish or English")
  stop();
}

survey_handle <- gs_title(sheet_name)



## Unfortunately, this read brings in the question text as all the column names. That's not good.
## We'll save them in question_text and put shorter, more friendly names in instead.

## Alison added this
## This code does the following:
## 1. saves the column names
## 2. reads in the survey data with col_names set 
## 3. skips first row of full question text
## 4. parses datetime column correctly
survey_questions <- survey_handle %>% 
  gs_read(ws="Question Names") %>% 
  select(Question_text, Question_name) 

# Save question text for later
write_csv(survey_questions, here::here("slides/data", "survey_questions.csv"))

survey <- gs_title("Learning R Internet Survey") %>%
  gs_read(ws = "Form Responses 1", 
          col_names = survey_questions %>% pull(Question_name), 
          skip = 1,
          col_types = cols(Qtime = col_datetime(format = "%m/%d/%Y %H:%M:%S")))

## Original code
## get the survey results
#survey <- survey_handle %>%
#  gs_read(ws = "Form Responses 1")
#survey_questions <- survey_handle %>% 
#   gs_read(ws="Question Names")
#names(survey) <- survey_questions$Question_name
#est <- locale(tz="US/Eastern")
#survey$Qtime <- parse_datetime(survey$Qtime, format = "%m/%d/%Y %H:%M:%S", locale=est)


survey_save <- survey                # in case I mess up survey, I can check it against this

# This learner_type variable defines if someone is a recent R learner or not for faceting
# Alison changed to case_when
survey <- survey %>% 
  mutate(learner_type = case_when(
    Qr_year <= 2016 ~ "Early Learner",
    Qr_year > 2016 ~ "Recent Learner",
    Qr_year < 1900 ~ NA_character_)
  ) %>% 
  mutate(Qgender = str_trim(str_to_lower(Qgender)))

# old code
#survey <- survey %>% 
# mutate(learner_type = ifelse(Qr_year < 1900, NA, ifelse(Qr_year <= 2016, "Early Learner", "Recent Learner")))

# This codes the open-text gender question into a more friendly form for analysis
opentext_gender_dictionary <- read_csv("data/opentext_gender_dictionary.csv")
#survey$Qgender <- survey$Qgender %>% 
#  tolower() %>% 
#  str_trim()
survey <- genderRecode(survey, method = "narrow", 
                       genderColName = "Qgender",
                       outputColName = "Qgender_coded",
                       customDictionary = opentext_gender_dictionary)


# explore coded/uncoded genders
uncoded_genders <- survey %>% group_by(Qgender_coded) %>% count(sort = TRUE)
# write_csv(uncoded_genders, here::here("slides/data", "uncoded_genders_language.csv"))

# This codes the ethnicity question for further analysis
# We recognize that this is both an offensive question to some and an imperfect classification
# Its purpose is to simply measure how diverse our community is. Our rationale is that if
# we do not attempt to measure the R community's diversity, then our claims of community diversity
# are meaningless because our only measurements are anecdotal.

opentext_ethnicity_dictionary <- read_csv("data/opentext_ethnicity_dictionary.csv")
ethnicity_dictionary <- opentext_ethnicity_dictionary %>%  
  mutate(Input = str_replace_all(Input, "[[:punct:]]", ""))

# Yes, I know this will cause false categorizations of open-ended responses with commas as Multiple Ethnicities
# That said, I can't see an obvious other way to detect multiple ethnicities beyond the dictionary matches below

survey <- survey %>% 
  mutate(Qethnicity_processed = ifelse(str_detect(Qethnicity, ","), "Multiple Ethnicities", Qethnicity))
survey$Qethnicity_processed <- survey$Qethnicity_processed %>% tolower() %>% str_trim() %>% str_replace_all("[[:punct:]]", "")
survey <- survey %>% 
  left_join(ethnicity_dictionary, by=c("Qethnicity_processed" = "Input"))
uncoded_ethnicities <-survey %>% 
  anti_join(ethnicity_dictionary, by=c("Qethnicity_processed" = "Input")) %>% 
  count(Qethnicity_processed, sort = TRUE) 
survey <- survey %>% 
  mutate(Qethnicity_coded = ifelse(Qethnicity_coded == "Prefer not to answer",
                                   NA, 
                                   Qethnicity_coded))
collected_ethnicities <- survey %>% group_by(Qethnicity_coded) %>% count(sort = TRUE)


write_tsv(survey, survey_tsv_path)
