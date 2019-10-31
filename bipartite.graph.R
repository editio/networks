
  ###-------------------------------------------###
  ###     Multilingual Discourse in Fiction     ###
  ###     Analysis with Character Networks      ###
  ###             J.L. Losada 2019              ###
  ###-------------------------------------------###

### ├── bipartite.graph.R         <--+ you are here
###   └── bipartite.graph.viz.R                 

library(igraph) 
library(tidyverse)

# Bipartite graph of characters and languages spoken (by each character).

# This script loads the table of interactions (each row corresponds to one interaction), creates a edge list, a graph object as a bipartite network, calculates the edges weight, and adds nodes degree metrics.

# After runing it, variables are stored in the "graph" object.

# Load data----
interaction.table <- read.csv("csv/redes.semprilis.csv", na.strings="")
interaction.table <- data.frame(lapply(interaction.table, str_trim)) # str_trim() removes whitespace from start and end of a string. " Semprilis " ≠ "Semprilis".

# Reshape table into edgelist----
edgelist <- interaction.table %>% 
gather(column_to_drop,personajes,-lengua, na.rm = T) %>% # melt by language.
select(c(1,3)) # drop column name.

# Edgelist (dataframe) to graph----
graph <- graph.data.frame(edgelist, directed = F)

# Create a bipartite graph----
V(graph)$type <- V(graph)$name %in% edgelist[,2]  # It matches nodes names between graph and edgelist (character column), and it adds the info (true/false) as an atributte to the graph object.

# Calculate the edges weight----
# get.incidence(graph): it creates an incidences matrix with weighted edges. 
graph <- graph_from_incidence_matrix(get.incidence(graph), weighted=TRUE, directed = F)  

# Metrics----
V(graph)$deg = igraph::degree(graph)

# Remove from Rstudio environment everything but "graph" (just for clarity)
rm(list = ls(pattern = "^[^graph$]"))
