%% Geometrische Modelle der Geodäsie
% Matlabaufgabe
clear variables
close all
clc

input = 1:20;
funF = f(input);
funG = g(input);

s2 = sumN(funF, funG);

figure
hold on
scatter(funF, input, 'x')
scatter(funG, input, '^')
scatter(s2, input, 'v')
hold off