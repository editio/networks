
  ###-------------------------------------------###
  ###     Multilingual Discourse in Fiction     ###
  ###     Analysis with Character Networks      ###
  ###             J.L. Losada 2019              ###
  ###-------------------------------------------###

### ├── languages.graph.R         <--+ you are here
###   └── languages.graph.viz.R   


# Mulitple graph of a network of characters connected by the language they speak.

# This script loads the table of interactions (each row corresponds to one interaction), creates a edge list, a graph object as multigraph, calculates the edges weight, adds degree, betweeness, articulation points, and eigenvector metrics.

library(igraph)
library(tidyverse)

# Load data----

interaction.table <- read.csv("csv/redes.eustorgio.csv", na.strings="")
interaction.table <- data.frame(lapply(interaction.table, str_trim)) # str_trim() removes whitespace from start and end of a string. " Eustorgio " ≠ "Eustorgio".

# Reshape table into edgelist----

  ## Put character (nodes) in a column asigning each row (shared scene) in other column.
  df <- select(interaction.table, -lengua) %>%  # without lengua column. Later use for conecting characters (nodes) with lengua (edges).
    rowid_to_column() %>%
    gather(col, name, -rowid) %>%
    drop_na(name) # no include NA.

  ## co-occurrences of "name" grouped by rowid sharing scene. It creates 2 columns.
  final = df %>% 
    group_by(rowid) %>% 
    mutate(name2 = list(name)) %>% 
    unnest() %>% 
    filter(name < name2)

  ## rowid to column in interaction table
  interaction.table = rowid_to_column(interaction.table)

  ## assigning language to the co-occurrences comparing with the interaction.table
  final$lengua = interaction.table$lengua[match(final$rowid,interaction.table$rowid)]

  ## Select columns for the edgelist
  edgelist = subset(final, select=c(name, name2, lengua))

# Edgelist with weighted co-occurrences by language----

  ## Edgelist considering who speaks which language: i.e, Pedro and Juan (german) ≠ Pedro and Juan (spanish). If characters (nodes) speak different languages between them, we get multiple edges (also called parallel edges or a multi-edges): the is graph is then a multi-graph. 

edgelist_weighted <- edgelist %>% 
  group_by(name, name2) %>%
  count(lengua, name = "weight") %>%
  ungroup()

  ## To get a weighted edgelist just by interaction, not considering the language, count(lengua) must be dropped.  

  # edgelist_weighted <- edgelist %>% 
  #    group_by(name, name2) %>%
  #    summarise(weight = n()) %>%  
  #    ungroup() 


  # Edgelist (dataframe) to graph----
graph <- graph.data.frame(edgelist_weighted, directed = F)

  # Metrics----
    ## Degree
    V(graph)$degree = degree(graph) 
    
    ## Eigenvector Centrality
    V(graph)$eigen = eigen_centrality(graph)$vector
    
    ## Betweenness
    V(graph)$betweenness = betweenness(graph)
    
    ## Articulation points.  If removing a node (so call "cut nodes"), it disconnects the graph. Characters connecting 2 worlds
    bi_co <- biconnected_components(graph)
    ### Just to get the variable into a V(graph) attribute.
    cut_nodes = as.list(bi_co$articulation_points) %>%
    as_tibble() %>%
    colnames()   

    V(graph)$art.point = V(graph)$name
    V(graph)$art.point[V(graph)$art.point %in% cut_nodes] = 1
    V(graph)$art.point[V(graph)$art.point != 1] =  0

# Poliglots----
    
## How many languages speak every character

df$lengua = interaction.table$lengua[match(df$rowid,interaction.table$rowid)]

nodes.per.language <- df %>% 
  group_by(name, lengua) %>%
  count() %>%
  ungroup()

numero.lenguas = nodes.per.language %>% 
  group_by(name) %>%
  count(name) 

nodes.per.language$num = numero.lenguas$n[match(nodes.per.language$name, numero.lenguas$name)]

# Adding the info to the graph object
V(graph)$num.lenguas = numero.lenguas$n[match(V(graph)$name, numero.lenguas$name)]

# Remove from Rstudio environment everything but "graph" (just for binder)
rm(list = ls(pattern = "^[^graph$]")) 
