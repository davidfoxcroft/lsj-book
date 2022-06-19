library(knitr)
knitr::opts_chunk$set(echo = FALSE, message = FALSE)
options(knitr.table.format = function() {
  if (knitr::is_latex_output()) 'latex'
  if (knits::is_html_output()) 'html' else pandoc
})

library(magrittr)
library(huxtable)
library(dplyr)
library(janitor)

# create huxtable
huxthattibble <- function(x) {
  { if (names(x[1]) == "X1") 
    ( hux(x) %>% 
          row_to_names(1) %>%
          set_header_rows(1, TRUE))
    else ( hux(x) %>% 
             set_contents(1, value = names(x)) ) 
    } %>% 
  set_align(everywhere, everywhere, "center") %>% 
  set_width(1.01) %>% 
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

lsj_chapter_tables <- readRDS("lsj_chapter_tables.rds")
huxtabs <- dfrapply(lsj_chapter_tables, huxthattibble)


