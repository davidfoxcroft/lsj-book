
library(tinytex)
library(huxtable)
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
          out.width =  if (knitr::is_latex_output()) "100%" else "80%"
          )
if (knitr::is_html_output()) options(huxtable.knitr_output_format = 'html')
options(knitr.table.format = function() {
  if (knitr::is_latex_output()) 'latex'
  if (knitr::is_html_output()) 'html' else pandoc
})

font_add(family = "TeX Gyre Pagella",   
         regular = "texgyrepagella-regular.otf") # Name you want to use to call the font
showtext_auto()

huxtabs <- readRDS("data_and_tables/lsj_chapter_huxtabs.rds")

theme_set(theme_classic(base_size=11, base_family="TeX Gyre Pagella"))
update_geom_defaults(
   geom = "text",
   aes(family = "TeX Gyre Pagella",
       fontface = "plain",
       size = 3)
)
