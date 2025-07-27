
library(tinytex)
library(kableExtra)
library(dplyr)
library(janitor)
library(rvest)
library(magrittr)
library(tidyr)
library(ggplot2)
library(knitr)
library(showtext)

set.seed(1963)
blueshade <- "#3d6da9" # match blue colour for plots to jamovi logo colour 

#### knitr options -----------
knitr::opts_chunk$set(
          fig.align = "left",
          out.width =  if (knitr::is_latex_output()) "100%" else "100%"
          )

options(knitr.kable.NA = '')


mykbl <- function(data, col_labs = NA, col_align = 'c') {
  if (names(data[1]) == "X1") {
    names(data) <- c(data[1,])
    data <- data[-1,]
  }
  kbl(data,
      linesep = '',
      escape = FALSE,
      col.names = col_labs,
      booktabs = TRUE,
      align = col_align
  ) |>
    kable_styling(
      bootstrap_options = c("hover", "responsive"),
      full_width = FALSE,
      latex_options = "scale_down"
    )
}

lsj_chapter_tables <- readRDS("data_and_tables/lsj_chapter_tables.rds")


font_add(family = "TeX Gyre Pagella",   
          regular = "texgyrepagella-regular.otf") # Name you want to use to call the font
showtext_auto()

theme_set(theme_classic(base_size=12, base_family="TeX Gyre Pagella"))
update_geom_defaults(
   geom = "text",
   aes(family = "TeX Gyre Pagella",
       fontface = "plain",
       size = 3)
)
