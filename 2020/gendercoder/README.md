
<!-- README.md is generated from README.Rmd. Please edit that file -->
gendercodeR
===========

The goal of gendercodeR is to allow simple recoding of freetext gender responses.

Why would we do this?
---------------------

Researchers who collect self-reported demographic data from respondents occasionally collect gender using a free-text response option. This has the advantage of respecting the gender diversity of respondents without prompting users and potentially including misleading responses. However, this presents a challenge to researchers in that some inconsistencies in typography and spelling create a larger set of responses than would be required to fully capture the demographic characteristics of the sample.

For example, male participants may provide freetext responses as "male", "man", "mail", "mael". Non-binary participants may provide responses as "nonbinary", "enby", "non-binary", "non binary"

This package uses dictionaries of common misspellings to recode these freetext responses into a consistent set of responses.

Installation
------------

This package is not on CRAN. To use this package please run the following code:

``` r
devtools::install_github("ropenscilabs/gendercodeR")
library(gendercodeR)
```

Example
-------

You have a dataframe with the following format where individuals have provided gender in a range of inconsistent formats.

``` r

library(gendercodeR)
#> Welcome to the genderCodeR package
#> 
#> This package attempts to remove typos from free text gender data
#> The defaults that we used are specific to our context and your data may be
#> different. We offer two categorisations, board and narrow both are opinionated
#> about how gender descriptors collapse into categories as these are culturally
#> specific they may not be suitable for your data. In particularly the narrow
#> setting makes opinionated choices about some responses that we want to
#> acknowledge are potentially problematic.
#>       In particular,
#>         * In 'narrow' coding intersex responses are recoded as 'sex and gender
#>           diverse'
#>         * In 'narrow' responses where people indicate they are trans and
#>           indicate their identified gender are recoded as the identified gender
#>           (e.g. 'Male to Female' is recoded as Female). We wish to acknowledge
#>           that this may not reflect how some individuals would classify
#>           themselves when given these categories and in some contexts may make
#>           systematic errors. The broad coding dictionary attempts to avoid these
#>           issues as much as possible - however users can provide a custom
#>           dictionary to add to or overwrite our coding decisions if they feel
#>           this is more appropriate. We welcome people to update the inbuilt
#>           dictionary where desired responses are missing.
#>         * The 'broad' coding separates out those who identify as trans
#>           female/male or cis female/male into separate categories it should not
#>           be assumed that all people who describe as male/female are cis, if you
#>           are assessing trans status we recommend a two part question see:
#> 
#>           Bauer, Greta & Braimoh, Jessica & Scheim, Ayden & Dharma, Christoffer.
#>           (2017).
#>           Transgender-inclusive measures of sex/gender for population surveys:
#>           Mixed-methods evaluation and recommendations.
#>           PLoS ONE. 12.

df <- data.frame(stringsAsFactors=FALSE,
      gender = c("male", "MALE", "mle", "I am male", "femail", "female", "enby"),
         age = c(34L, 37L, 77L, 52L, 68L, 67L, 83L)
)

df
#>      gender age
#> 1      male  34
#> 2      MALE  37
#> 3       mle  77
#> 4 I am male  52
#> 5    femail  68
#> 6    female  67
#> 7      enby  83
```

Running the `genderRecode()` function will take the inputted dataset, match freetext gender responses to the dictionary, create a new column in the dataframe with the recoded gender response. For freetext gender responses that are not in the dictionary the original freetext will be copied to the recoded gender column.

``` r
genderRecoded <- genderRecode(input=df,
                              genderColName = "gender", 
                              method = "broad",
                              outputColName = "gender_recode", 
                              missingValuesObjectName = NA,
           customDictionary = NULL)
#> 
#> The following responses were not auto-recoded. The raw responses
#>         have been carried over to the recoded column 
#>  
#> # A tibble: 1 x 2
#> # Groups:   responses [1]
#>   responses     n
#>   <fct>     <int>
#> 1 i am male     1

genderRecoded
#>      gender age gender_recode
#> 1      male  34          male
#> 2      MALE  37          male
#> 3       mle  77          male
#> 4 I am male  52     i am male
#> 5    femail  68        female
#> 6    female  67        female
#> 7      enby  83    non-binary
```

Options within the function
---------------------------

### method

The package provides the option to either correct spelling and standardise terms while maintaining the diversity of responses. This is selected by setting `method =  "broad"` or to compress all responses down to male/female/'sex and gender diverse' using `method =  "narrow"`.

##### Example using narrow coding

``` r
genderRecoded <- genderRecode(input=df,
                              genderColName = "gender", 
                              method = "narrow",
                              outputColName = "gender2", 
                              missingValuesObjectName = NA,
           customDictionary = NULL)
#> 
#> The following responses were not auto-recoded. The raw responses
#>         have been carried over to the recoded column 
#>  
#> # A tibble: 1 x 2
#> # Groups:   responses [1]
#>   responses     n
#>   <fct>     <int>
#> 1 i am male     1

genderRecoded
#>      gender age                gender2
#> 1      male  34                   male
#> 2      MALE  37                   male
#> 3       mle  77                   male
#> 4 I am male  52              i am male
#> 5    femail  68                 female
#> 6    female  67                 female
#> 7      enby  83 sex and gender diverse
```

### missingValuesObjectName

By default the unmatched responses and the number of times it exists in the input dataframe. Setting `missingValuesObjectName` saves the list of unmatched free text gender responses. We recommend assessing these as they may be human code-able (e.g. "I am male") or otherwise meaningful and not captured by our base dictionary. We expect that researchers may wish to manually recode such responses or add frequently occurring responses to their custom dictionary.

### customDictionary

Users can specify a custom dictionary that supplements or overwrites entries to the in-built dictionary.

There is a vignette for this function

Viewing the inbuilt dictionary
------------------------------

The inbuilt dictionary can be assigned to an object using the `getDictionary()` function. This function does not take any arguments.

``` r
test <- getDictionary()
#> Parsed with column specification:
#> cols(
#>   entries = col_character(),
#>   broad = col_character(),
#>   narrow = col_character()
#> )
test
#> # A tibble: 56 x 3
#>    entries     broad              narrow                
#>    <chr>       <chr>              <chr>                 
#>  1 female      female             female                
#>  2 male        male               male                  
#>  3 androgynous androgynous        sex and gender diverse
#>  4 non-binary  non-binary         sex and gender diverse
#>  5 nonbinary   non-binary         sex and gender diverse
#>  6 non binary  non-binary         sex and gender diverse
#>  7 trans       transgender        sex and gender diverse
#>  8 trans man   transgender male   male                  
#>  9 trans woman transgender female female                
#> 10 transman    transgender male   male                  
#> # ... with 46 more rows
```

Contributing to this package
============================

This package is a reflection of cultural context of the package contributors we welcome issues and pull requests to make the package more inclusive and/or suitable for a broader range of cultural contexts.

Acknowledgement of Country
==========================

We acknowledge the Wurundjeri people of the Kulin Nation as the custodians of the land on which this package was developed and pay respects to elders past, present and future.
