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

setwd("/home/lars/Nextcloud/WMK/projects/2021_ditkomm/2021-12-10")
load("biorxiv_ohne_abstract.RData")
