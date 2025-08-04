
# Pakete laden
library(tidyverse) # Sammlung an Paketen aus dem tidyerse
library(RColorBrewer) # Sinnvolle Farbpaletten
library(knitr) # Schoene Tabellen
library(lubridate) # Umgang mit Datumsangaben
library(DT) # coole Tabellen

## Daten einlesen

# encodingprobleme Die Datei ist latin1 kodiert
Beeren <- read_csv2("41232-0002.csv", skip = 7, n_max = 28) 


# Die fehlenden Werte (NA) werden noch nicht korrekt angezeigt
Beeren <- read_csv2("41232-0002.csv", skip = 7, n_max = 28, col_names = FALSE, locale = locale(encoding = "latin1"))
view(Beeren)

# korrekte Variante
Beeren <- read_csv2("41232-0002.csv", 
                    skip = 7, # die ersten 7 Zeilen werden uebersprungen
                    n_max = 280, # es werden nur 280 Zeilen eingelesen
                    col_names = FALSE, # Der ausgewaehlte Bereich enthaelt keine Ueberschriften
                    locale = locale(encoding = "latin1"), # Auswahl der latin1 Codierung
                    na = c("-", "x", ".")) # Bestimmte Zeichen werden als fehlende Werte festgelegt
view(Beeren)


## select (rename)
## Auswahl von Variablen
Beeren <- 
  Beeren %>%
  rename(
    Jahr = X1,
    Anbauform = X2,
    Art = X3,
    Anzahl_Betriebe = X4,
    Anbauflaeche_ha = X5,
    Erntemenge_t = X6
  )

select(Beeren, "Art", "Anbauflaeche_ha")
Beeren %>% select("Art", "Anbauflaeche_ha")


## mutate
## Neue Variablen und Variablen verändern

Beeren <-
  Beeren %>%
  mutate(Anbauform = if_else(Anbauform == "Freiland",
                             "Freiland",
                             "Schutzabdeckung"))


## pivot_wider pivot_longer

Beeren_wide <-
  Beeren %>%
  pivot_wider(
    names_from = Anbauform,
    values_from = c("Anzahl_Betriebe",
                    "Anbauflaeche_ha",
                    "Erntemenge_t")
  )

Beeren_long <-
  Beeren %>%
  pivot_longer(-c(Art, Anbauform, Jahr),
               names_to = "Metrik",
               values_to = "Wert")


## zurück zu mutate

Beeren %>% 
  mutate(durchschnittliche_Betriebsgroesse_ha = Anbauflaeche_ha / Anzahl_Betriebe)

Beeren_wide %>% 
  mutate(Anzahl_Betriebe = Anzahl_Betriebe_Freiland + Anzahl_Betriebe_Schutzabdeckung, 
         Anbauflaeche_ha = Anbauflaeche_ha_Freiland + Anbauflaeche_ha_Schutzabdeckung, 
         Erntemenge_t = Erntemenge_t_Freiland + Erntemenge_t_Schutzabdeckung) %>% 
  select(Jahr, Art, Anzahl_Betriebe, Anbauflaeche_ha, Erntemenge_t)

Beeren_wide %>% 
  mutate(across(where(is.numeric), ~if_else(is.na(.), 0, .))) %>% 
  mutate(Anzahl_Betriebe = Anzahl_Betriebe_Freiland + Anzahl_Betriebe_Schutzabdeckung, 
         Anbauflaeche_ha = Anbauflaeche_ha_Freiland + Anbauflaeche_ha_Schutzabdeckung, 
         Erntemenge_t = Erntemenge_t_Freiland + Erntemenge_t_Schutzabdeckung) %>% 
  select(Jahr, Art, Anzahl_Betriebe, Anbauflaeche_ha, Erntemenge_t)


## summarize
## group_by

Beeren %>% 
  summarise(Gesamternte = sum(Erntemenge_t, na.rm = TRUE)) # Berechnung der Summe unter Missachtung der fehlenden Werte (na.rm = TRUE)

Beeren %>% 
  group_by(Art, Jahr) %>% 
  summarise(Summe = sum(Erntemenge_t, na.rm = TRUE)) %>% view()

## filter

Beeren %>% filter(Jahr == "2018")

Beeren %>% filter(Jahr == "2018" & Anbauform == "Freiland")

Beeren %>% filter(Art != "Insgesamt")
Beeren %>% filter(!(Art == "Insgesamt"))

## Tabellen mit kable()
Beeren %>% filter(Jahr == "2018" & Anbauform == "Freiland") %>% kable()

Beeren %>% filter(Jahr == "2018" & Anbauform == "Freiland") %>% datatable()
