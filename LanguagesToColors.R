###-------------------------------------------###
###     Multilingual Discourse in Fiction     ###
###     Analysis with Character Networks      ###
###             J.L. Losada 2020              ###
###-------------------------------------------###

### ├── LanguagesToColors.R   <--+ you are here
###   └── tripartite.sankey.viz.R         
###   └── bipartite.graph.viz.plot.R      

# For plotting same colours for shared languages across novels in tripartite.sankey.viz (col) or in bipartite.graph.viz.plot.R (col_len)

library(tidyverse)
library(qualpalr) # To generate customized colors

## Extract languages to create a unique list of all languages from both novels.

L1 <- read.csv("csv/redes.semprilis.csv", na.strings="")
L2 <- read.csv("csv/redes.eustorgio.csv", na.strings="")
L3 = full_join(L1, L2, by="lengua")
all_l = unique(L3$lengua)  # unique languages
n = length(all_l) # total number of languages

## Set colors for each language
pal = qualpal(n, colorspace = list(h = c(0, 300), s = c(0.2, 1), l = c(0, 0.5)))
col = setNames(pal$hex, all_l) # assign color to languages (for both novels, so that a shared language has the same color in different viz)

## Variable for bipartite plot igraph
col_len = as.data.frame(col) %>% 
rownames_to_column(., "lengua")

# Documentation: not used here, but useful to understand qualpal color generation. Also posible to choose colors manualy from there <https://medialab.github.io/iwanthue/>.