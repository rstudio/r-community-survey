# learning-r-survey README
This repo contains the survey instruments, analysis documents, and data from the RStudio learning R survey. This survey was run in December 2018, and we are now preparing to launch a second iteration in December 2019, with results to be published in January 2020.

This repo is organized simply:

- **2018/** contains the questions and data from the December 2018 survey
- **2019/** contains the questions from the December 2019 survey. It will be updated with the data after the survey has been fielded.

## Details of the surveys

### 2018

Below are some details about the 2018 survey and the methdology:

- The survey was fielded on the Internet between December 6 and December 31, 2018
- The survey was fielded in both English and Spanish versions
- Respondents were solicited from
	- community.rstudio.com
	- Twitter followers of RStudio employees and colleagues
	- reddit.com/datascience

We plan to keep the vast majority of the questions constant among years to allow us to see trends over time. However, I plan to 

**Bias warning**: Because we relied on the RStudio community to solicit respondents, this data probably has significant sampling bias. We can't really advertise it as representative of the broad R community; this sample is NOT random. However, even if it is just people who know us well enough to answer our survey, it is a large enough collection of data to be interesting nonetheless.

The information in this repository is organized as follows:

- **data/**: This directory holds the original survey responses and lightly coded versions of those responses, all in tab-delimited files. Separate files are used for English and Spanish versions of the survey.
- **dictionaries/**: This directory contains a collection of ad-hoc dictionaries for interpreting open-text responses (most of the survey results arrive as open text). No separate dictionaries are used for Spanish and English -- these are where we translate the Spanish responses into English ones when we do a composite analysis.
- **gendercoder/**: This package uses dictionaries to interpret the open text responses to gender identification, which can have a very large space of answers. Instead of inventing my own way of interpreting that data, I relied instead on more authoritative folks who have studied this problem. The gender identification used in the results shown are extremely simplistic; that was my choice for ease of presentation and should not reflect on the more sophisticated work in the actual package.
- **plots/**: This directory holds exploratory data plots that Carl Howe presented at rstudio::conf 2019.
- **slides/**: This directory holds a PDF of the slides presented at RStudio::conf 2019 along with some experimental attempts to create Xaringan R Markdown slides from the material. While I intended to do this initially, I only had a couple weeks between the closing of the survey and the conference, so I didn't complete the work there.

The R Markdown document for processing the survey is `process_survey.Rmd`. You may need to install a variety of packages to generate the plots shown. You will need to use `devtools` to install `gendercode` from `github`. You can Google for its location.

### 2019

The new 2019 survey is just completing development and we plan to launch it around December 11, 2019.

The survey in 2019 will be largely the same as in 2018, but with the addition of a few more questions regarding Python, the discoverability of packages, and R Markdown. We still are targeting roughly 10 minutes to complete the survey.


Carl Howe
RStudio, Inc.
carl@rstudio.com




