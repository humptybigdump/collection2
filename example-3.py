# Wissenschaftliches Arbeiten und Schreiben
# Autor: Gabriel C. Rau

# importiert SymPy
import sympy as sp

# Variablen definieren
x = sp.Symbol('x', real=True)
# Funktion definieren
f = sp.exp(-x**2 / 2) * sp.cos(sp.pi*x)

# ableiten (lassen) ...
dfdx = f.diff(x)

# Ergebis anzeigen
print("f'(x) =", sp.pretty(sp.simplify(dfdx)))

