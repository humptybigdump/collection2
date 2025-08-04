%% Task 1
clear all;
close all;
clc;

m=1;
d=0.5;
c=10;

open_system('Simulink_Loesung');

[A,B,C,D] = tf2ss(1,[m d c]);%Zustandsraumdarstellung ermöglicht Definition von Anfangsbedingungen (siehe: Simulink, Aufgabe 3 unten)