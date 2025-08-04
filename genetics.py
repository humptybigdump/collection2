import copy
import numpy as np

import torch
import torch.nn as nn

def mutate_net(net, NOISE_STD):
    '''
    Addiert auf die Gewichte eines neuronalen Netzes net Zufallswerte der Grössenordnung NOISE_STD
    '''
    #Neuronales Netz kopieren 
    new_net = copy.deepcopy(net)
    
    #Über die Parameter des neuronalen Netzes itterieren und Zufallswerte addieren
    for p in new_net.parameters():
        noise_t = torch.tensor(np.random.normal(size = p.data.size()).astype(np.float32))
        p.data += NOISE_STD * noise_t
    return new_net


class Population ():
    '''
    Eine Population besteht aus einer Liste von neuronalen Netzen der Länge POPULATION_SIZE zusammen mit einer Bewertung.
    Die Bewertung wird duch spielen mit evaluate_on_env auf der Umgebung env berechnet. 
    Danach kann man mit  playWithFittest das Nettz mit der besten Bewertung auf auf der Umgebung env spielen lassen.
    '''
    def __init__(self, POPULATION_SIZE, obs_size, action_size, computeReward, net):
        self.POPULATION_SIZE = POPULATION_SIZE
        self.obs_size = obs_size
        self.action_size = action_size
        self.net = net
        self.nets = [copy.deepcopy(net) for _ in range(POPULATION_SIZE)]
        self.computeReward = computeReward


    def evaluate_on_env (self, env, generateFeatures, MAX_REWARD):
        '''
        Mit jedem Netz wird gespielt und die Punktezahl ermittelt. 
        Danach werden die Netze absteigend anhand ihrer Punktzahl sortiert.
        '''
        self.population = []
        for net in self.nets:
            state = env.reset()
            reward = 0.0
            done = False
            while not done and reward <MAX_REWARD:
                obs = torch.FloatTensor([generateFeatures(state)])
                act_prob = net(obs).data.numpy()[0] #
                state_old = state
                state, _, done, _ = env.step(act_prob)
                reward += self.computeReward(state_old, state)

            self.population.append([reward, net])

        self.population.sort(key=lambda p: p[0], reverse=True)
    

    def playWithFittest(self, env, generateFeatures, MAX_REWARD, num_pop):
        #Mit dem besten Netz der Population wird gespielt und das Spiel grafisch dargestellt.
        play_with_population(env, self.population[0], generateFeatures, MAX_REWARD, self.computeReward, num_pop)


def play_with_population(env, pop,generateFeatures, MAX_REWARD, computeReward, num_pop ):
    state = env.reset()
    reward = 0.0
    done = False
    net = pop[1]
    while not done and reward < MAX_REWARD:
        obs = torch.FloatTensor([generateFeatures(state)])
        action = env.action_space.sample()
        act_prob = net(obs).data.numpy()[0]
        acts = 0
#        if (act_prob[0] < act_prob[1]):
#            acts = 1

        #        print(acts)
        state_old = state

        state, _, done, _ = env.step(act_prob)
        reward += computeReward(state_old, state)
        env.num_pop = num_pop
        env.score += reward
        env.render()
    env.reset()
    print (reward)

def mutate_population(pop, PARENTS_COUNT, NOISE_STD):
    '''
    Erzeugt eine Mutation der Population pop mit Mutationsfaktor NOISE_STD und zufälliger Auswahl der besten bis PARENTS_COUNT.
    '''
    pop_mut = Population(0, pop.obs_size, pop.action_size, pop.computeReward, pop.net)
    pop_mut.nets = [(copy.deepcopy(pop.population[0][1]))]
    for _ in range(len(pop.population) - 1):
        parent_idx = np.random.randint(0, PARENTS_COUNT)
        parent = pop.population[parent_idx][1]
        net_mut = mutate_net(parent,NOISE_STD )
        pop_mut.nets.append(net_mut)
    return pop_mut

