.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to the genderCodeR package\n
This package attempts to remove typos from free text gender data
The defaults that we used are specific to our context and your data may be
different. We offer two categorisations -- 'broad' and 'narrow.' Both are opinionated
about how gender descriptors collapse into categories as these are culturally
specific they may not be suitable for your data. In particular, the 'narrow'
setting makes opinionated choices about some responses that we want to
acknowledge as potentially problematic.
      In particular,
        * In 'narrow' coding, intersex responses are recoded as 'sex and gender
          diverse'
        * In 'narrow' responses, where people indicate they are trans and
          indicate their identified gender are recoded as the identified gender
          (e.g. 'Male to Female' is recoded as Female). We wish to acknowledge
          that this may not reflect how some individuals would classify
          themselves when given these categories and in some contexts may make
          systematic errors. The broad coding dictionary attempts to avoid these
          issues as much as possible - however users can provide a custom
          dictionary to add to or overwrite our coding decisions if they feel
          this is more appropriate. We welcome people to update the inbuilt
          dictionary where desired responses are missing.
        * The 'broad' coding separates out those who identify as trans
          female/male or cis female/male into separate categories it should not
          be assumed that all people who describe as male/female are cis, if you
          are assessing trans status we recommend a two part question see:

          Bauer, Greta & Braimoh, Jessica & Scheim, Ayden & Dharma, Christoffer.
          (2017).
          Transgender-inclusive measures of sex/gender for population surveys:
          Mixed-methods evaluation and recommendations.
          PLoS ONE. 12.")
}
