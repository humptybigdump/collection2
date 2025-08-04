library(tidyverse)
library(jsonlite)
library(stringr)
library(tidygraph)
library(ggraph)
library(igraph)


## Beispielskript zum Abrufen der bioRxiv API

# import_bioRxiv <- function(server = "biorxiv", interval = paste("2010-01-01", today(), sep = "/")){
#   firstdump <- fromJSON(paste("https://api.biorxiv.org/details", server, interval, sep = "/"))
#   n <- firstdump$messages$total
#   chunks <- seq(0,n,100)
#   chunks <- chunks[-1]
#   failed <- NULL
#   data <- tibble(firstdump$collection)
#   for(cursor in chunks){
#     dump <- NULL
#     try(dump <- fromJSON(paste("https://api.biorxiv.org/details", server, interval, cursor, sep = "/")))
#     if(is.null(dump)){failed <- c(failed, cursor)}else{
#       data <- data %>% bind_rows(tibble(dump$collection))}
#   }
#   list(data, failed)
# }
# 
# biorxiv <- import_bioRxiv()

# load("biorxiv.RData")
# biorxiv <- biorxiv %>% select(-abstract)
# save(biorxiv, file = "biorxiv_ohne_abstract.RData")

## Gespeicherte Daten einlesen

setwd("/home/lars/Nextcloud/WMK/projects/2021_ditkomm/2021-12-10") # Muss individuelle gesetzt werden
load("biorxiv_ohne_abstract.RData")

## einfache Haeufigkeitstabelle
table(biorxiv$category) 

## tidyverse-Version
biorxiv %>% 
  group_by(category) %>% 
  summarise(n = n()) %>% 
  arrange(n, category)

## Zoologie-Datensatz
zoology_authors <- 
  biorxiv %>% 
  group_by(doi) %>% # Gruppierung nach preprint
  filter(version == max(version), 
         category == "zoology") %>% # Filter nach Kategorie Zoologie und letzter verfuegbarer Version
  select(doi, authors) %>% 
  mutate(Autoren = str_split(authors, pattern = ";")) %>% # Autorenzeile wird am Semikolon in einzelne Autoren getrennt
  unnest_longer(Autoren) %>% # und in ein tidy-Format gebracht
  filter(Autoren != "") # Leere Eintraege werden geloescht

## Erzeugung Knoten-Datensatz
zoology_authors_knoten <- 
  zoology_authors %>% 
  group_by(Autoren) %>% 
  summarise(n = n()) %>% 
  filter(n >= 2) %>% # Es werden nur die Autoren betrachtet, die mindestens zwei Mal vorkommen
  rename(name = Autoren)

## Erzeugung Kanten-Datensatz (mit map-magic)
zoology_authors_kanten <- 
  zoology_authors %>% 
  filter(Autoren %in% zoology_authors_knoten$name) %>% # Herausfiltern der Kanten, die für den reduzierten Knoten-Datensatz relevant sind
  select(-authors) %>% 
  group_by(doi) %>% 
  filter(n() > 1) %>% 
  split(.$doi) %>% # Beginn map-magic, nicht weiter erlaeutert
  map(., 2) %>% 
  map(~combn(.x, m = 2)) %>% 
  map(~t(.x)) %>% 
  map_dfr(as_tibble) %>% 
  rename(from = V1, to = V2)

## Restlicher Code siehe Netzwerk- Uebung
zoo_netzwerk <- as_tbl_graph(graph_from_data_frame(
  zoology_authors_kanten,
  vertices = zoology_authors_knoten))  

zoo_netzwerk <- zoo_netzwerk %>% activate(nodes) %>% 
  mutate(knotengrad = centrality_degree())

zoo_netzwerk <- zoo_netzwerk %>% activate(nodes) %>% 
  mutate(komponente = group_components())

layout_zoo_netzwerk <- create_layout(filter(zoo_netzwerk, komponente == 1),
                                      layout = "igraph", algorithm = "nicely")

ggraph(layout_zoo_netzwerk) +
  geom_node_point(aes(size = knotengrad)) +
  geom_edge_link() + 
  geom_node_text(aes(label = name), colour = 'blue', vjust = 0.4)
