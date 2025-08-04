# Wissenschaftliches Arbeiten und Schreiben
import matplotlib.pyplot as plt
import numpy as np

# create a figure object
fig = plt.figure(figsize=[6,4])

x = np.linspace(0, 2.3 * np.pi, 100)
y = np.sin(x)
plt.plot(x, y, '-', c='g', label='or like that?')

x = np.linspace(0, 2.3 * np.pi, 6)
y = np.sin(x)
plt.plot(x, y, '-', c='b', label='like this?')
plt.plot(x, y, '.', c='r', label='data')

# add the vital elements
plt.ylim([-1.1,1.1])
plt.xlabel('Time [min]')
plt.ylabel('A variable [unit]')
plt.legend()

# save the plot
plt.savefig('example-2c.png', dpi=150)

