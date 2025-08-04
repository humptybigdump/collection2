# Wissenschaftliches Arbeiten und Schreiben
import numpy as np
import matplotlib.pyplot as plt

# create the data
delta = 0.025
x = np.arange(-3.0, 3.0, delta)
y = np.arange(-2.0, 2.0, delta)
X, Y = np.meshgrid(x, y)
Z1 = np.exp(-X**2 - Y**2)
Z2 = np.exp(-(X - 1)**2 - (Y - 1)**2)
Z = (Z1 - Z2) * 2

# create a figure object
fig = plt.figure(figsize=[6,4])

# contour plot
CS2 = plt.pcolor(X, Y, Z)
cbar = plt.colorbar(CS2)
cbar.ax.set_ylabel('A third variable [unit]')

# draw contours
CS = plt.contour(X, Y, Z, 6, colors='k')
plt.clabel(CS, fontsize=9, inline=1)

plt.xlabel('A first variable [unit]')
plt.ylabel('A second variable [unit]')

# save the plot
plt.savefig('example-5.png', dpi=150)
