# Wissenschaftliches Arbeiten und Schreiben
# Autor: Gabriel C. Rau

# importiert Pandas
import pandas as pd
# importiert NumPy
import numpy as np

# öffnet eine Excel-Datei und liest die Daten ein
data = pd.read_excel('example-1.xlsx')

# Schreibt die Daten auf den Bildschirm
print(data)

# HIER KÖNNEN DIE DATEN MANIPULIERT WERDEN

# Messwerte quadrieren
data['Analysis'] = data['Measurement']**2

# Durchschnitt
average = np.mean(data['Measurement'])
print(average)

# Standardabweichung
stdev = np.std(data['Measurement'])
print(stdev)

# Erbenisse als Excel-Datei speichern
data.to_excel('analysis-1.xlsx')
