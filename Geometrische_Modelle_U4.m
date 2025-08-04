clear variables
close all
clc
%% QR-Zerlegung

A = randi([1,10], 20, 20);
b = randi([1, 10], 20, 1);

[Q, R] = qr(A);

x_1 = linsolve(R, Q'*b)

%% LGS mit bekannter Methode lösen

x_2 = linsolve (A, b)

% Beim Vergleichen der Vektoren im Command Window ist zu erkennen, dass x_1
% und x_2 gleich sind.
