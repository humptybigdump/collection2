"""
A simple example for a unknown cost_function that can still be evaluated.
"""
import numpy as np
import matplotlib.pyplot as plt
import mod.my_plotter as mp
from cost_function import cost_function

SETUP = False  
# SETUP = True # Uncomment this line on first run!

N = np.load('N.npy')

# Set-up Plot (only run once)
if SETUP:
    plt.close('all')
    mp.init_plot(mrksze=8, labelfontsize=18, fontsize=18, tickfontsize=15)
    fig, ax = plt.subplots() 
    ax.set_xlabel('$x$') 
    ax.set_ylabel('$y$')
    ax.set_ylim([0,12])
    ax.set_xlim([-3,3])
    ax.grid(True) 
    plt.tight_layout()
    
    N = 0
    
# Define point(s) to be added to the plot
x = 1.5
N += 1
# x = np.linspace(-2.5,2.5,100)
# N += len(x)
    
# Add points to the axes
plt.scatter(x, cost_function(x), marker='s', edgecolor='k')
plt.text(0.5, 0.95, f'sampled points: \n {N}', transform=plt.gca().transAxes, 
         fontsize=18, verticalalignment='top', horizontalalignment='center', 
         bbox=dict(boxstyle='round', facecolor='w', alpha=1))

np.save('N.npy', N)



