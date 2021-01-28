context("gendercodeR")
df <- data.frame(stringsAsFactors=FALSE,
                 gender = c("male", "MALE", "mle", "I am male", "femail", "female", "enby"),
                 age = c(34L, 37L, 77L, 52L, 68L, 67L, 83L)
)

test_that("gendercodeR prints text", {
  expect_that(genderRecoded <- genderRecode(input=df,
                                             genderColName = "gender",
                                             method = "broad",
                                             outputColName = "gender_recode",
                                             missingValuesObjectName = NA,
                                             customDictionary = NULL),
              prints_text("\\nThe following responses were not auto-recoded\\. The raw responses\\n        have been carried over to the recoded column \\n \\n# A tibble: 1 x 2\\n# Groups:   responses \\[1\\]\\n  responses     n\\n  <fct>     <int>\\n1 i am male     1"))
})
