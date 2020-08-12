###-------------------------------------------###
###     Multilingual Discourse in Fiction     ###
###     Analysis with Character Networks      ###
###             J.L. Losada 2020              ###
###-------------------------------------------###

### ├── bipartite.graph.R  
### └── LanguagesToColors.R             
###   └── bipartite.graph.viz.plot.R    <--+ you are here 

# Uwaga!(1) # bipartite.graph.R needs to be run first. I keep them separated just for clarity.

# Uwaga!(2) LanguagesToColors.R needs to be run first. I keep them separated just for clarity. Only needed for plotting same colours for shared languages across novels: otherways comment/uncomment "vertex.color"

# Uwaga!(3) character gender for each novel comment/uncomment depending of novel

# table.gender <- read.csv("csv/names_by_gender_Semprilis.csv") # character gender
table.gender <- read.csv("csv/names_by_gender_Eustorgio.csv") 
V(graph)$gender = as.character(table.gender$gender[match(V(graph)$name, table.gender$personajes)])

# for shared languages across novels
V(graph)$color.languages = as.character(col_len$col[match(V(graph)$name, col_len$lengua)]) 

plot(graph, 
      vertex.color = ifelse(V(graph)$type, "white", V(graph)$color.languages),
      # vertex.color = ifelse(V(graph)$type, "white", as.factor(V(graph)$name[V(graph)$type==F])),
     vertex.size = ifelse(V(graph)$type==F, 10, 8),
     vertex.label = ifelse(V(graph)$type==F,V(graph)$name, ifelse(V(graph)$gender=="female", "F", "M")),
     vertex.shape = ifelse(V(graph)$type==F, "square", "circle"),
     vertex.label.color="black", 
     vertex.frame.color="grey",
     vertex.label.font= ifelse(V(graph)$type==F,1, ifelse(V(graph)$gender=="female", 2, 1)), # bold just for female labels
     vertex.label.dist= ifelse(V(graph)$type==F,  -1.2, 0),
     vertex.label.degree = -pi/2,
     edge.color="Gainsboro", # LightGrey
     edge.width=E(graph)$weight, 
     layout=layout_with_gem
) 

