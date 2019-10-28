
  ###-------------------------------------------###
  ###     Multilingual Discourse in Fiction     ###
  ###     Analysis with Character Networks      ###
  ###             J.L. Losada 2019              ###
  ###-------------------------------------------###

### ├── languages.graph.R         
###   └── languages.graph.viz.R   <--+ you are here

# The funcion in the languages.graph.R need to be run first. I keep them separated just for clarity.

# Visualization with visNetwork----
library('visNetwork') 

visnet = toVisNetworkData(graph, idToLabel = F)  # From igraph format to visNetwork.

# Network properties.

# Legend
leyenda = paste0("<div style=\"text-align: center;\">","<font size=4 color=#045FB4>","Multilingual discourse in narrative fiction </font>","</div> <hr>")

library(RColorBrewer)
cbPalette = brewer.pal(6,"Dark2")

#EDGES
visnet$edges$color = cbPalette[as.factor(E(graph)$lengua)]
visnet$edges$label = E(graph)$lengua
visnet$edges$font.color = cbPalette[E(graph)$color]
visnet$edges$font.size = 150
visnet$edges$width = E(graph)$weight*20

# NODES
visnet$nodes$color = ifelse(V(graph)$art.point == 0, "#e3e3e3", "gray") 
visnet$nodes$size = V(graph)$eigen*1000
# visnet$nodes$font.size = V(graph)$eigen*2000
# visnet$nodes$label =  paste(round(V(graph)$betweenness), round(V(graph)$eigen, digits = 2), V(graph)$name,sep=" · ",V(graph)$num.lenguas) 

# Tooltip

# visnet$edges$title = paste0("<p>", E(graph)$lengua,":" ,"Metemos conversaciones...","</p>")
visnet$nodes$title = paste0("<p>", V(graph)$name,sep=" · ",V(graph)$num.lenguas, "</p>")

# run visNetwork----

visNetwork(visnet$nodes, visnet$edges, width="100%", height="600px", main = list(text = leyenda)) %>%
  visInteraction(hideEdgesOnDrag = TRUE) %>%
  visOptions(highlightNearest = list(enabled = TRUE), nodesIdSelection = F) %>%
  visEdges(smooth = list(enabled = TRUE, roundness = 0.9)) %>%
  visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -3000, avoidOverlap = 0.4))