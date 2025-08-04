%BEGINN DATEI „Flash_executable.m“
clear all
clc

%Charakterisierung Feed
Fpkt = 25;        %mol/s
z_MeOH = 0.13; %[-]
z_H2O = 0.87;  %[-]
FEED = [Fpkt, z_MeOH, z_H2O];

%Bestimmung Feed-Enthalpie 
cp_MeOH = 81.08;   %J/molK
cp_H2O = 75.29;    %J/molK
T_F = 35;          %°C

h_F = z_MeOH*cp_MeOH*T_F + z_H2O*cp_H2O*T_F;    %J/mol

%Charakterisierung des Flashs
p = 0.15;   %bar
T = 50;     %°C

%Verdampfungsenthalpien
delta_h_MeOH = 35000;   %J/mol
delta_h_H2O = 43000;    %J/mol

%Berechnung spezifischer Reinstoffenthalpie der austretenden Ströme
h_MeOH_L = cp_MeOH*T;             %J/mol
h_H2O_L = cp_H2O*T;               %J/mol
h_MeOH_G = cp_MeOH*T + delta_h_MeOH;  %J/mol
h_H2O_G = cp_H2O*T + delta_h_H2O;     %J/mol
ENTHALPIE = [h_F, h_MeOH_L, h_H2O_L, h_MeOH_G, h_H2O_G];

%Berechnung Sättigungsdampfdrücke
p_MeOH_sat = 1.013/760*10^(7.76879 - 1408.360/(T+223.600));    %bar
p_H2O_sat = 1.013/760*10^(8.07131 - 1730.630/(T+233.426));     %bar

%Zusammenfassung aller Parameter zu X_Para
X_Para = [FEED, ENTHALPIE, p_MeOH_sat, p_H2O_sat, p];

%Festlegung der Reihenfolge der zu bestimmenden Prozessgrößen
%X_Var0 = [G,       L,    y_MeOH,  y_H2O,  x_MeOH,  x_H2O,  h_G, h_L, Q]
X_Var0 = [0.5*Fpkt,   0.5*Fpkt,   0.5,    0.5,     0.5,    0.5, 45000,3700,4000000];

%Solver-Optionen setzen
options = optimset('Display','iter', 'MaxFunEvals', 50000, 'MaxIter', 10000);

%Lösen der Modellgleichungen „F.m“
[X_Var, res] = fsolve(@(X_Var) F(X_Var, X_Para), X_Var0,options)

%ENDE DATEI „Flash_executable.m“
