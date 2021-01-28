#' Returns the inbuilt dictionary
#'
#' @export
getDictionary <- function() {
 readr::read_csv(system.file("extdata",
                            "GenderDictionary_List.csv",
                            package = "gendercodeR"))
}
