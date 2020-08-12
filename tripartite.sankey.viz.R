
###-------------------------------------------###
###     Multilingual Discourse in Fiction     ###
###     Analysis with Character Networks      ###
###             J.L. Losada 2020              ###
###-------------------------------------------###

### ├── LanguagesToColors.R             
###   └── tripartite.sankey.viz         <--+ you are here

# Uwaga! The funcion in the LanguagesToColors.R need to be run first. I keep them separated just for clarity. Only needed for plotting same colours for shared languages across novels: otherways comment/uncomment scale_fill_manual().

library(tidyverse)
library(ggalluvial) # To plot sankey diagramms with ggplot

# Tripartite viz of characters, gender, and languages spoken (by each character). It creates a ggplot viz.

# This script loads the table of interactions (each row corresponds to one interaction) and the table with character gender. Creates a edgelist with the 3 variables: lengua, personajes, gender, and plots a sankey diagram.

### Load data----

## Comment/Uncomment interaction.table&table.gender for each novel and rerun the script.

# interaction.table <- read.csv("csv/redes.eustorgio.csv", na.strings="")
interaction.table <- read.csv("csv/redes.semprilis.csv", na.strings="")

table.gender <- read.csv("csv/names_by_gender_Semprilis.csv") # character gender
# table.gender <- read.csv("csv/names_by_gender_Eustorgio.csv") 


interaction.table <- data.frame(lapply(interaction.table, str_trim)) # str_trim() removes whitespace from start and end of a string. " Semprilis " ≠ "Semprilis".

### Reshape table into edgelist----
edgelist <- interaction.table %>% 
  gather(column_to_drop,personajes,-lengua, na.rm = T) %>% # melt by language.
  select(c(1,3)) # drop column name.

# Add gender to create tripartite and count interactions.

edgelist_tripartite = edgelist %>%
  mutate(
    gender = table.gender$gender[match(edgelist$personajes, table.gender$personajes)]
  ) %>%
  group_by(lengua, personajes, gender) %>%
  count()

### Vizualize with a sankey diagramm----

ggplot(subset(edgelist_tripartite, n > 0), # Subset if needed to exclude small interacctions
       aes(y = n, axis3 = personajes, axis2 =  gender, axis1 =  lengua)) +
  geom_alluvium(aes(fill = lengua)) +
  geom_stratum(alpha = .3, width = 1/5) +
  scale_fill_manual(values = col) +  #  Vide LanguagesToColors.R or just comment/uncomment   
  geom_label(stat = "stratum", aes(label = after_stat(stratum)), size = 4, min.y = 6) + # min.y to exclude labels that do not fit in the box.
  theme_void() +
  # theme(legend.position = "none")
  theme(legend.position = "bottom", legend.title = element_blank()) +
  guides(fill=guide_legend(nrow=1))


# Documentation
# labels for ggalluvial: <https://corybrunson.github.io/ggalluvial/articles/labels.html>

