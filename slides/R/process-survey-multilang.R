# this script does the following:
# 1. Defines helper functions
# 2. Imports survey data from googlesheets
# 3. Does some pre-processing for column names
# 4. Does some pre-processing for the free text gender field

language <- "English" # may also be "Spanish"

# packages needed
library(googlesheets)
library(tidyverse)
library(RColorBrewer)
library(gendercodeR)
library(here)


###
### Let's define helper functions before we get going:
###


# Split and aggregate: derives multiple answers to a single question by separating on commas and returning
# the results as an embedded list in the dataframe.
split_and_aggregate <- function(df, question_name) {
  quoted_question <- enquo(question_name)
  responses_df <- df %>% summarize(responses = sum(!is.na(!!quoted_question)))
  splits <- df %>% mutate(items = map(!!quoted_question, str_split, ", ")) %>% unnest()
  
  aggregated_items <- splits %>% unnest() %>% group_by(items) %>% count(sort=TRUE)
  aggregated_items <- aggregated_items %>% mutate(num_responses = responses_df$responses)
  return(aggregated_items)
}

# Top N choices: function to distill many possible results to a question to the top N
# responses, with the rest aggregated into an "Other" answer.
top_n_choices <- function(df, column_name, total_responses, num = 10) {
  
  quoted_column_name <- enquo(column_name)
  summarized_responses <- df %>% 
    mutate(percent = round(n / total_responses * 100)) %>% 
    arrange(desc(percent))
  
  # Now take these responses and only show the top N, aggregating the rest into an Other category
  
  literals <- head(summarized_responses, num) %>% 
    ungroup()
  other <- tail(summarized_responses, -num) %>% 
    ungroup() %>% 
    summarize(!!quoted_column_name := "Other", 
              n = sum(n),
              percent = round(n / first(total_responses) * 100))
  top_n <- rbind(literals, other) %>% drop_na()
  return(top_n)
}

question_text <- function(question_name_string)
{
  question_text <- survey_questions %>% filter(Question_name == question_name_string) %>% select(Question_text)
  return_text <- question_text$Question_text %>% str_wrap(width = 50)
  return(paste0('"', return_text, '"'))
}

##############################################################
### This section begins the mainline code to read the survey #
##############################################################

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
write_csv(survey, here::here("slides/data", paste0("survey_", language,".csv")))

# explore coded/uncoded genders
uncoded_genders <- survey %>% group_by(Qgender_coded) %>% count(sort = TRUE)
# write_csv(uncoded_genders, here::here("slides/data", "uncoded_genders_language.csv"))
