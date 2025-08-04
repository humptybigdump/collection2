# Wissenschaftliches Arbeiten und Schreiben
# Autor: Gabriel C. Rau
import numpy as np

# Gleichungssystem als Matrix und Vektor aufstellen
a = np.array([[2,3,-4], [0.5,-13,1], [13,7,-21]])
b = np.array([4, 44, 98])

# und lösen
result = np.linalg.solve(a,b)
print(result)
