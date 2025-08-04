# Wissenschaftliches Arbeiten und Schreiben
import matplotlib.pyplot as plt
import numpy as np

# create a figure object
fig = plt.figure(figsize=[6,4])

# create some data
x = np.linspace(0, 2 * np.pi, 20)
y = np.sin(x)

# plot a line
plt.plot(x, y, '-')

# plot markers
plt.plot(x, y, '.')

# add the vital elements
plt.xlabel('Time [min]')
plt.ylabel('A variable [unit]')

# save the plot
plt.savefig('example-1.png', dpi=150)
