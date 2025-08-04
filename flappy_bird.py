import gym
import copy
import numpy as np
import time as time
import torch
import torch.nn as nn
import gym_flappyBird
import genetics as gen
import matplotlib.pyplot as plt
import math
import pygame
from pygame.locals import *

done = False
reward = 0
env = gym.make("scienceCampBird-v1")
state = env.reset()

# Wenn du die Leertaste drückst, wirkt eine y-Kraft der 
# Schwerkraft entgegen. Probiere unterschiedliche Werte 
# für YKRAFT aus, um das beste Spielgefühl zu erreichen.

def birdAction(decision, bird):
    YKRAFT = # Füge hier deinen Code ein
    bird.forceY = YKRAFT * decision[0]
    
env.setAction(birdAction)

# In Folgenden baust du die Säulenlandschaft auf. 

# Abstand zwischen Säulen
ABSTAND_SAEULEN = [MIN0, MAX0]

# Höhe der Säulen
HOEHE_SAEULEN = [MIN1, MAX1]

# Öffnung der Säulen
LUECKEN_SAUELEN = [MIN2, MAX2]

env.setPipeIntervals([ ABSTAND_SAEULEN, HOEHE_SAEULEN, LUECKEN_SAUELEN ])

# Hier wird das Programm gestartet.

while True:
    
    decision = [0.0]     
    
    for event in pygame.event.get():
        
        if event.type == KEYDOWN and event.key == K_ESCAPE:
            pygame.quit()
        
        elif event.type == KEYDOWN and event.key == K_SPACE:
            decision = [1.0]
            
    state_old = state
    state, _, game_over, _ = env.step(decision)
    
    # Für jede Einheit, die das Flappy Bird nach rechts zurücklegt,
    # wird die Punktzahl erhöht.
    reward += 1
    
    env.render()
    
    # Wenn das Flappy Bird abstürzt oder gegen eine Säule fliegt,
    # wird das Spiel beendet.
    if game_over:
        # Die Punktzahl wird in der Konsole ausgegeben.
        print ('Score:', reward)
        
        # Das Spiel wird neu gestartet.
        state = env.reset()
        
        # Die Punktzahl wird wieder auf 0 gesetzt.
        reward = 0
        
        # Der Prozess wird drei Sekunden lang gestoppt.
        time.sleep(3)
        
        
# Erstelle eine Funktion, die die relevanten Feature zurückgibt.

def generateFeatures(state):
    pass


# Der auskommentierte Code ist nicht zur Ausführung gedacht, soll dir aber helfen
# sinnvolle Feature für die obere Funktion zu finden.

'''

Der Parameter state ist eine Dictionary, die ungefähr so aussieht:

{
    'bird': <Objekt der Klasse Bird>, 
    'pipes': [<naechste_sauele0>, <naechste_sauele1>, <naechste_sauele2>, <naechste_sauele3>, <naechste_sauele4>]
}



class Bird:

    def __init__(self, sh):
    
        # Position
        self.Y = 250
        self.X = 80
        
        # Geschwindigkeit
        self.speedY = 0
        self.speedX = 20
        
        # Kräfte
        self.forceX = 0.0 
        self.forceY = 0.0

        self.ticks = 0
        self.flap = 0

class Pipe:

    def __init__(self, pos,  height, gap, sh):
        
        # Höhe der Säulen
        self.height = height
        
        # Lücke zwischen Säulen
        self.gap = gap
        
        # Position
        self.pos = pos
 
'''

# Implementiere hier die Architektur deines neuronalen Netzes und
# erzeuge anschließend ein Objekt davon.
# Das erzeugte Objekt soll 'net' heißen.

# Wähle hier sinnvolle Zahlen für die Variablen.

POPULATIONSGROESSE = # Füge hier deinen Code ein.
ANZAHL_TOP_K_VOEGEL = # Füge hier deinen Code ein. 
MUTATIONSSTAERKE = # Füge hier deinen Code ein.

# Analog zu oben, kannst du hier die y-Kraft festlegen.
def birdAction(eingabe, bird):
        YFORCE = # Füge hier deinen Code ein.
        bird.forceY = YFORCE * eingabe[0]

def computeReward(state_old, state_new):
    return 1

# Analog zu oben, kannst du hier die Säulenparameter ändern.
sauelen_distanz = [250, 350]
sauelen_hoehe = [100,300]
saulen_luecke = [120,130]

Score_Max = 4000
fittestBirds = []

# Hier wird die Environment eingerichtet.
env = gym.make("scienceCampBird-v1")
env.setPipeIntervals([Interval_distance, Interval_height,Interval_gap])
population = gen.Population(POPULATIONSGROESSE, 5, 2, computeReward, net)
env.setAction(birdAction)
population.evaluate_on_env(env,generateFeatures, Score_Max)
k_te_generation = 0  
punktzahl_der_besten_voegel = []

# Durch die Ausführung dieses Codefelds startest du das Spiel.

while True:
    population = gen.mutate_population(population, PARENTS_COUNT, NOISE_STD)
    population.evaluate_on_env(env, generateFeatures, Score_Max)
    fittestBirds.append(population.population[0])
    ecount +=1
    if(ecount % k_te_generation == 0):
        print("evaluaton")
        net = population.population[0][1]
        score_e = population.population[0][0]
        score_p = env.playWithNet(net, generateFeatures, Score_Max, computeReward, k_te_generation)
        print("----------------------------------------------------------------------------")
        print("----------------------------------------------------------------------------")
        print('Population: ', k_te_generation)
        print("____________________________________________________________________________")
        print('Punktzahl Training: ', score_e, ' Punktzahl Spiel: ', score_p)
        print("____________________________________________________________________________")
       
    punktzahl_der_besten_voegel = [score[0] for score in fittestBirds]
    
# Mit dieser Funktion kannst du dir die beste Punktzahl
# der jeweiligen Generationen anzeigen lassen.

def beste_punktzahl(scores):
    fig, ax = plt.subplots()
    ax.plot(scores)
    ax.set(xlabel='Pupulation', ylabel='Punktzahl',
    title='Punktzahl der besten Vögel der Population')
    ax.grid()
    plt.show()
    
beste_punktzahl(punktzahl_der_besten_voegel)

# Durch die Ausführung dieses Codefelds, kannst du den besten Vogel 
# aller Populationen fliegen lassen.

env.playWithNet(fittestBirds[-1][1], generateFeatures, Score_Max, computeReward, ecount)