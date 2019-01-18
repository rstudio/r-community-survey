# learning-r-survey README
This repo contains the survey instruments, analysis documents, and data from the RStudio learning R survey, conducted between December 6 and December 31, 2018. This survey was designed to capture information about how users learn R.

Below are some details about the survey and the methdology:

- The survey was ielded on the Internet between December 6 and December 31, 2018
- The survey was fielded in both English and Spanish versions
- Respondents were solicited from
	- community.rstudio.com
	- Twitter followers of RStudio employees and colleagues
	- reddit.com/datascience

**Bias warning**: Because we relied on the RStudio community to solicit respondents, this data probably has significant sampling bias. We can't really advertise it as representative of the broad R community; this sample is NOT random. However, even if it is just people who know us well enough to answer our survey, it is a large enough collection of data to be interesting nonetheless.

The information in this repository is organized as follows:

- **data/**: This directory holds the original survey responses and lightly coded versions of those responses, all in tab-delimited files. Separate files are used for English and Spanish versions of the survey.
- **dictionaries/**: This directory contains a collection of ad-hoc dictionaries for interpreting open-text responses (most of the survey results arrive as open text). No separate dictionaries are used for Spanish and English -- these are where we translate the Spanish responses into English ones when we do a composite analysis.
- **gendercoder/**: This package uses dictionaries to interpret the open text responses to gender identification, which can have a very large space of answers. Instead of inventing my own way of interpreting that data, I relied instead on more authoritative folks who have studied this problem. The gender identification used in the results shown are extremely simplistic; that was my choice for ease of presentation and should not reflect on the more sophisticated work in the actual package.
- **plots/**: This directory holds exploratory data plots that Carl Howe presented at rstudio::conf 2019.
- **slides/**: This directory holds a PDF of the slides presented at RStudio::conf 2019 along with some experimental attempts to create Xaringan R Markdown slides from the material. While I intended to do this initially, I only had a couple weeks between the closing of the survey and the conference, so I didn't complete the work there.

The R Markdown document for processing the survey is `process_survey.Rmd`. You may need to install a variety of packages to generate the plots shown. You will need to use `devtools` to install `gendercode` from `github`. You can Google for its location.

Carl Howe
RStudio, Inc.
carl@rstudio.com




