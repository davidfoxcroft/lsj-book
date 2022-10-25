library(knitr)
if (knitr::is_html_output()) options(huxtable.knitr_output_format = 'html')
options(knitr.table.format = function() {
  if (knitr::is_latex_output()) 'latex'
  if (knitr::is_html_output()) 'html' else pandoc
})

library(tinytex)
library(huxtable)
library(dplyr)
library(janitor)
library(rvest)
library(magrittr)
lsj_chapter1_tables <- read_html("html_tables/1. Why do we learn statistics.html") %>% html_table() 
lsj_chapter2_tables <- read_html("html_tables/2. A brief introduction to research design.html") %>% html_table() 
lsj_chapter3_tables <- read_html("html_tables/3. Getting started with jamovi.html") %>% html_table() 
lsj_chapter4_tables <- read_html("html_tables/4. Descriptive statistics.html") %>% html_table() 
lsj_chapter5_tables <- read_html("html_tables/5. Drawing graphs.html") %>% html_table() 
lsj_chapter6_tables <- read_html("html_tables/6. Pragmatic matters.html") %>% html_table() 
lsj_chapter7_tables <- read_html("html_tables/7. Introduction to probability.html") %>% html_table() 
lsj_chapter8_tables <- read_html("html_tables/8. Estimating unknown quantities from a sample.html") %>% html_table() 
lsj_chapter9_tables <- read_html("html_tables/9. Hypothesis testing.html") %>% html_table() 
lsj_chapter10_tables <- read_html("html_tables/10. Categorical data analysis.html") %>% html_table() 
lsj_chapter11_tables <- read_html("html_tables/11. Comparing two means.html") %>% html_table() 
lsj_chapter12_tables <- read_html("html_tables/12. Correlation and linear regression.html") %>% html_table() 
lsj_chapter13_tables <- read_html("html_tables/13. Comparing several means (one-way ANOVA).html") %>% html_table() 
lsj_chapter14_tables <- read_html("html_tables/14. Factorial ANOVA.html") %>% html_table() 
lsj_chapter15_tables <- read_html("html_tables/15. Factor Analysis.html") %>% html_table() 
lsj_chapter16_tables <- read_html("html_tables/16. Bayesian statistics.html") %>% html_table() 

lsj_chapter_tables <- list(lsj_chapter1_tables,
                           lsj_chapter2_tables,
                           lsj_chapter3_tables, #empty
                           lsj_chapter4_tables,
                           lsj_chapter5_tables, #empty
                           lsj_chapter6_tables,
                           lsj_chapter7_tables,
                           lsj_chapter8_tables,
                           lsj_chapter9_tables, 
                           lsj_chapter10_tables, 
                           lsj_chapter11_tables,
                           lsj_chapter12_tables, 
                           lsj_chapter13_tables,
                           lsj_chapter14_tables, 
                           lsj_chapter15_tables, #empty 
                           lsj_chapter16_tables
)
#lsj_chapter_tables      
saveRDS(lsj_chapter_tables, "lsj_chapter_tables.rds")

# create huxtable
huxthattibble <- function(x) {
  { if (names(x[1]) == "X1") 
    ( hux(x) %>% 
          row_to_names(1) %>%
          set_header_rows(1, TRUE))
    else ( hux(x) %>% 
             set_contents(1, value = names(x)) ) 
   } %>%
  { if (knitr::is_latex_output()) 
    (set_escape_contents(., everywhere, value = FALSE)) 
    else (set_escape_contents(., everywhere, value = TRUE))
  } %>% 
  set_align(everywhere, everywhere, "center") %>% 
  set_width(0.9) %>% 
  set_caption_pos("bottomleft") %>% 
  theme_article() %>% 
  set_background_color(odds, everywhere, "grey95")
}

# Recursively apply function to all data frames in a nested list
dfrapply <- function(object, f, ...) {
  if (inherits(object, "data.frame")) {
    return(f(object, ...))
  }
  if (inherits(object, "list")) {
    return(lapply(object, function(x) dfrapply(x, f, ...)))
  }
  stop("List element must be either a data frame or another list")
}

#lsj_chapter_tables <- readRDS("lsj_chapter_tables.rds")
huxtabs <- dfrapply(lsj_chapter_tables, huxthattibble)
saveRDS(huxtabs, "lsj_chapter_huxtabs.rds")
#huxtabs <- readRDS("lsj_chapter_huxtabs.rds")


