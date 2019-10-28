
  ###-------------------------------------------###
  ###     Multilingual Discourse in Fiction     ###
  ###     Analysis with Character Networks      ###
  ###             J.L. Losada 2019              ###
  ###-------------------------------------------###

### ├── bipartite.graph.R         
###   └── bipartite.graph.viz.R   <--+ you are here

# The funcion in the bipartite.graph.R need to be run first. I keep them separated just for clarity.

# Visualization with visNetwork----
library('visNetwork') 

visnet = toVisNetworkData(graph, idToLabel = F)  # From igraph format to visNetwork.

# Network properties. They can be modified in order to vizualize, for example, node size by degree.
visnet$edges$label = paste0(E(graph)$weight, " interacciones")
visnet$edges$font.size = 4
visnet$edges$width = E(graph)$weight
#visnet$nodes$size = V(graph)$deg*2  # node size base on degree.
visnet$nodes$size = 15
visnet$nodes$font.size = 40
visnet$edges$color = "grey"
visnet$nodes$color = ifelse(V(graph)$type, "orange", "green")
visnet$nodes$label = ifelse(V(graph)$type, "", V(graph)$name) # just plot languages nodes
visnet$nodes$title = paste0("<p>", V(graph)$name, "</p>")

# Run visNetwork----

# Without title
# visNetwork(visnet$nodes, visnet$edges, width="100%", height="700px")

# With title

tittle = paste0("<div style=\"text-align: center;\">","<font size=4 color=#045FB4>","Affiliation Network (bipartite graph) of languages and characteres in <i>Semprilis</i>","</div> <hr>")

visNetwork(visnet$nodes, visnet$edges, width="100%", height="700px", main = list(text = tittle)) %>%
  visInteraction(hideEdgesOnDrag = TRUE) %>%
  visOptions(highlightNearest = list(enabled = TRUE), nodesIdSelection = F)


