
library(tinytex)
library(huxtable)
library(dplyr)
library(janitor)
library(rvest)
library(magrittr)
library(tidyr)
library(ggplot2)
library(knitr)

set.seed(1963)
blueshade <- "#3d6da9" # match blue colour for plots to jamovi logo colour 

#### knitr options -----------
knitr::opts_chunk$set(
          fig.align = "left",
          out.width =  if (knitr::is_latex_output()) "100%" else "80%"
          )
if (knitr::is_html_output()) options(huxtable.knitr_output_format = 'html')
options(knitr.table.format = function() {
  if (knitr::is_latex_output()) 'latex'
  if (knitr::is_html_output()) 'html' else pandoc
})

##### read tables from html files 
lsj_chapter_tables <- list()
lsj_chapter_tables[[1]] <- read_html("data_and_tables/1. Why do we learn statistics.html") %>% html_table() 
lsj_chapter_tables[[2]] <- read_html("data_and_tables/2. A brief introduction to research design.html") %>% html_table() 
lsj_chapter_tables[[3]] <- read_html("data_and_tables/3. Getting started with jamovi.html") %>% html_table() 
lsj_chapter_tables[[4]] <- read_html("data_and_tables/4. Descriptive statistics.html") %>% html_table() 
lsj_chapter_tables[[5]] <- read_html("data_and_tables/5. Drawing graphs.html") %>% html_table() 
lsj_chapter_tables[[6]] <- read_html("data_and_tables/6. Pragmatic matters.html") %>% html_table() 
lsj_chapter_tables[[7]] <- read_html("data_and_tables/7. Introduction to probability.html") %>% html_table() 
lsj_chapter_tables[[8]] <- read_html("data_and_tables/8. Estimating unknown quantities from a sample.html") %>% html_table() 
lsj_chapter_tables[[9]] <- read_html("data_and_tables/9. Hypothesis testing.html") %>% html_table() 
lsj_chapter_tables[[10]] <- read_html("data_and_tables/10. Categorical data analysis.html") %>% html_table() 
lsj_chapter_tables[[11]] <- read_html("data_and_tables/11. Comparing two means.html") %>% html_table() 
lsj_chapter_tables[[12]] <- read_html("data_and_tables/12. Correlation and linear regression.html") %>% html_table() 
lsj_chapter_tables[[13]] <- read_html("data_and_tables/13. Comparing several means (one-way ANOVA).html") %>% html_table() 
lsj_chapter_tables[[14]] <- read_html("data_and_tables/14. Factorial ANOVA.html") %>% html_table() 
lsj_chapter_tables[[15]] <- read_html("data_and_tables/15. Factor Analysis.html") %>% html_table() 
lsj_chapter_tables[[16]] <- read_html("data_and_tables/16. Bayesian statistics.html") %>% html_table() 


#lsj_chapter_tables      
saveRDS(lsj_chapter_tables, "data_and_tables/lsj_chapter_tables.rds")


##### huxtable defaults and function ----

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
  set_top_padding(everywhere, everywhere, 2 ) %>%
  set_bottom_padding(everywhere, everywhere, 2 ) %>%
  set_left_padding(everywhere, everywhere, 12 ) %>%
  set_right_padding(everywhere, everywhere, 12 ) %>%
  set_width(0.9) %>% 
  set_caption_pos("bottomleft") %>% 
  theme_article() #%>% 
  #set_background_color(odds, everywhere, "grey95")
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

# additional created tables

# table 7.1
newhux1 <- list(huxthattibble(tibble(`number of flips` = c(1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10, 11 , 12 , 13 , 14 , 15 , 16 , 17 , 18 , 19 , 20),
                     `number of heads` = c( 0 , 1 , 2 , 3 , 4 , 4 , 4 , 5 , 6 , 7,  8  ,  8 ,  9 , 10 , 10 , 10 , 10 , 10 , 10 , 11 ),
                     `proportion` = c( 0.00 , .50 , .67 , .75 , .80 , .67 , .57 , .63 , .67 , .70, .73 , .67 , .69 , .71 , .67 ,  .63 , .59 , .56 , .53 , .55))) |>
  set_number_format(,3,"%.2f") |>
  set_top_padding(3:21, everywhere, value=0 ) |>
  set_bottom_padding(2:20, everywhere, value=0 )
)
huxtabs[[7]] <- append(huxtabs[[7]], newhux1, 0)


# table 10.5
# Set p-values
p <- c(.05, 0.10, 0.30, 0.50, 0.90, 0.95, 0.99, 0.999)
# Set degrees of freedom
df <- seq(1,10)
# Calculate a matrix of chisq statistics
m <- outer(p, df, function(x,y) qchisq(x,y))
# Transpose for a better view
m <- as.data.frame(t(m))
m <- tibble::add_column(m, df, .before = 1) 
# Set column names
colnames(m) <- c("Degrees of freedom", 1 - p)
newhux2 <- list(
  hux(m) %>%
    set_top_border(2, 1:9, value = 0.4) %>%
    set_number_format(2:11, 2:9, "%5.3f") %>% 
    insert_row(c("","Probability", 3:9)) %>%
    insert_row(c("","Non-significant", 3:6, "Significant", 8:9), after=12) %>%
    merge_cells(1, 2:9) %>%
    merge_cells(13, 2:6) %>%
    merge_cells(13, 7:9) %>%
    set_font_size(1:13, 1:9, 10) %>%
    set_bold(c(1:2, 13), 1:9, value = TRUE) %>%
    set_left_border(1:13, c(2,7), value = 0.4) %>%
    set_top_border(13, 1:9, value = 0.4) %>%
    set_col_width(c(.2,.1,.1,.1,.1,.1,.1,.1,.1)) %>%
    set_bottom_border(13, 1:9, value = 0.4) %>%
    set_align(everywhere, everywhere, "center") %>% 
    set_top_padding(everywhere, everywhere, 2 ) %>%
    set_bottom_padding(everywhere, everywhere, 2 ) %>%
    #set_left_padding(everywhere, everywhere, 12 ) %>%
    #set_right_padding(everywhere, everywhere, 12 ) %>%
    set_width(0.9) %>% 
    set_caption_pos("bottomleft") 
)
huxtabs[[10]] <- append(huxtabs[[10]], newhux2, 5)

saveRDS(huxtabs, "data_and_tables/lsj_chapter_huxtabs.rds")
#huxtabs <- readRDS("data_and_tables/lsj_chapter_huxtabs.rds")



