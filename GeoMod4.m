%% Geometrische Modelle der Geodäsie
% Übungsblatt 4 Matlabaufgabe
% Elisabeth Kral

clear variables
clc

A = randi(10, 20);
b = randi(10, 20, 1);

if det(A) ~= 0
    [Q, R] = qr(A);
    y = linsolve(R, Q'*b);
    x = linsolve(A, b);
    disp([x,y]);
    
    % Vergleich der Lösungen
    if round(x, 10) == round(y, 10)
        disp('QR-Zerlegung erglibt dasselbe wie linsolve.');
    else
        disp('Ein Fehler ist passiert.');
    end
end