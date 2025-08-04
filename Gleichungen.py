#Importieren von Bibliotheken
import numpy as np

#Gl. 9 zum Berechnen der fl. Zusammensetzung einer Komponente
def gleichung9(x1, x1_0, xj_0, N_N0, wjp):
    return xj_0 * np.power(x1/x1_0, wjp) * np.power(N_N0, wjp-1)

#Gl. 10 - 1 zum iterativen lösen nach x1
def gleichung10_minus1(x1, x1_0, x2_0, x3_0, N_N0, w21, w31):
    x2 = gleichung9(x1, x1_0, x2_0, N_N0, w21)
    x3 = gleichung9(x1, x1_0, x3_0, N_N0, w31)

    return x1 + x2 + x3 - 1

def gleichung17(x1, x2, x3, w21, w31):
    a = 1 + w21*(x2/x1) + w31*(x3/x1)

    return 1/a

def gleichung16(yp, xp, xj, wjp):
    yj = yp*wjp*(xj/xp)

    return yj