# convert html chapters to md and rename as .Rmd - run this in terminal
pandoc -f html -t commonmark "2. A brief introduction to research design.html" -o "02-A-brief-introduction-to-research-design.md" --markdown-headings=atx

# open converted file in atom and:
1. find / replace:
  '\\( ' '$'
  '\\(' '$'
  ' \\)' '$'
  '\)' '$'
  '\( ' '$'
  '\(' '$'
  ' \)' '$'
  '\)' '$'
2. change notation tables to footnotes using [^ref] and [^ref]:
3. proof and check headings and text

# build book including latest chapter in bookdown html

# scrape tables from html chapter files
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

lsj_chapter1_tables
lsj_chapter2_tables
lsj_chapter3_tables #empty
lsj_chapter4_tables
lsj_chapter5_tables #empty
lsj_chapter6_tables
lsj_chapter7_tables
lsj_chapter8_tables
lsj_chapter9_tables 
lsj_chapter10_tables 
lsj_chapter11_tables 
lsj_chapter12_tables 
lsj_chapter13_tables 
lsj_chapter14_tables 
lsj_chapter15_tables #empty
lsj_chapter16_tables 

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
                  
lsj_chapter_tables      
saveRDS(lsj_chapter_tables, "lsj_chapter_tables.rds")

# re-open chapter.Rmd file rstudio and replace figures and tables with rcode chunks, fix fig and tab refs

------ ### code fragments stored here for convenient copy / paste
  \@ref[tab:tab-1-1)
  
```{r tab1-1}
huxtabs[[7]][[1]] %>% set_caption("...") 
```

lsj_chapter_tables

```{r fig1-1, fig.cap="...", out.width = "90%"}
knitr::include_graphics("images/Figure1.PNG")
```
  set_contents(1, 1, "") %>% 
  set_colspan(1, 2, 2) %>% 
  set_colspan(1, 4, 2) %>%

# switch to 'visual' mode in rstudio to fix footnote labelling

# check and fix bib refs and fix any book cross-refs

# proof including footnotes, check any escapes required for % etc

# build bookdown different formats and proof

