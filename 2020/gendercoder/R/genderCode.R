#' Gender column recoder
#'
#' Recodes gender column to
#'
#' @param input A dataframe with a column with the name specified in gender column name
#' @param genderColName Gender information column text name
#' @param outputColName Output column name
#' @param missingValuesObjectName Provide object name for function to write unknown
#'  responses and their locations to. If NA, the unrecognised responses will be
#'  printed but not saved.
#' @param method "broad" or "narrow". Broad returns responses classified into "female", "male",
#' "androgynous", "non-binary", "nonbinary", "transgender", "transgender male", "transgender female",
#'  "intersex", "agender", "gender-queer". Narrow returns "female", "male", "cis female", "cis male", "other".
#'  @param customDictionary enter custom dictionary set up as a data frame with two columns, the first
#'  of which will be treated as the values to be replaced and the second which will be treated as the
#'  replacement values (i.e., data.frame(c("cis  gender-male","trans-person" ), c("cis male", "transgender")))
#'
#' @return Returns the original dataframe with
#'
#' @examples
#'
#'
#' @export
genderRecode <-
  function(input, genderColName = "gender", method = "broad",
           outputColName = "gender_recode", missingValuesObjectName = NA,
           customDictionary = NULL) {

    # Coercing to data frame if necessary
    if(is.data.frame(input) == FALSE) {
      input <- data.frame(input)
    }

    if(length(input) == 1) {
      if(is.na(genderColName)) {
        names(genderColName) <- "gender"
          }
      names(input) <- genderColName
    }
    # Checking that the input has the gender col name
    if(all(names(input) != genderColName & !is.na(genderColName))) {
    stop("Your gender column name does not exist in the supplied input")
    }

    ## Need to check that the column name input is a character
    genderFreeText <- input[genderColName]

    # load dictionary
    # ideally we'd have some way of loading this in the package
    #suppressMessages(dictionary <- readr::read_csv(system.file("data/GenderDictionary.csv", package="gendercodeR") ))
    #moved data in line with recommendations http://r-pkgs.had.co.nz/data.html
    suppressMessages(dictionary <- readr::read_csv(system.file("extdata",
                                                               "GenderDictionary.csv",
                                                               package = "gendercodeR")))
    # Filter the dictionary to only use unique items
    dictionary <- dplyr::distinct(dictionary)

    if(method == "narrow") {
      dictionary <- dictionary[c("Typos", "ThreeOptions")]
    } else {
      dictionary <- dictionary[c("Typos", "BroadOptions")]
    }
    # Relabelling input column here and changing to tibble
    genderFreeText <- dplyr::data_frame(Typos = stringr::str_to_lower(genderFreeText[[1]]))


    if(!is.null(customDictionary)) {
      customDictionary <- dplyr::transmute_all(customDictionary, as.character)
      names(customDictionary) <- names(dictionary)
      suppressWarnings(  dictionary <- rbind(customDictionary, dictionary, stringsAsFactors = FALSE))
      dictionary <- dplyr::distinct(dictionary, Typos, .keep_all= TRUE)
      }

    # joining keeping all originals
    result <- dplyr::left_join(genderFreeText,dictionary,  by = c("Typos"))

    # Finding and printing unrecognised bits
    unrec <- result$Typos[which(is.na(result[2]))]
    unrecNum <- which(is.na(result[2]))
    if(length(unrec) > 0) {
    unrecognisedResponses <- data.frame(responses = unrec,
                                        row.numbers = unrecNum)
    cat("\nThe following responses were not auto-recoded. The raw responses
        have been carried over to the recoded column \n \n")
    print(dplyr::group_by(unrecognisedResponses, responses) %>% dplyr::count())
    # if is.na(missingValuesObjectName) == FALSE, save as missingValuesObjectName
    if(!is.na(missingValuesObjectName)) {
      assign( missingValuesObjectName, unrecognisedResponses, envir = .GlobalEnv)}
    }

responses <- ifelse(is.na(result[[2]]),  result[[1]], result[[2]])

response <- cbind(input, responses, stringsAsFactors = FALSE)
names(response)[ length(response)] <- outputColName

return(response)
  }

