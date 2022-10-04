###-------------------------------------------###
###     Multilingual Discourse in Fiction     ###
###     Analysis with Character Networks      ###
###             J.L. Losada 2022              ###
###-------------------------------------------###

### ├── languages.graph.R         
###   └── languages.graph.metrics.R  <--+ you are here  

# Uwaga! # languages.graph.R needs to be run first. You need a graph object.

library(CINNA)
library(pheatmap)

selection = c("Closeness Centrality (Freeman)", "eigenvector centralities","Degree Centrality","Shortest-Paths Betweenness Centrality", "Current-Flow Closeness Centrality", "Load Centrality", "Flow Betweenness Centrality","Information Centrality","Weighted Vertex Degree")

metrics  = calculate_centralities(graph, include = selection) 

viz <- pheatmap(as.data.frame(metrics), 
                display_numbers = T, 
                scale = "column", 
                cluster_rows = F, 
                cluster_cols = F, 
                angle_col = 45, 
                cellwidth = 40, 
                legend = F
                )
