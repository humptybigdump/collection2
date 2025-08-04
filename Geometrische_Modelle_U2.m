%% 
clear variables
close all
clc

%% 
a = @computeSquare;
b = @computeRoots;
%% Werte 1,...,20 in f und g und sum einsetzen
werte = (1:20);
aWerte = a(werte);
bWerte = b(werte);
sumWerte = sum(aWerte, bWerte);

%% Plotten mit scatter
figure;
scatter(werte, aWerte, 'r')
hold on
scatter(werte, bWerte, 'b')
hold on
scatter(werte, sumWerte, 'g')
hold off;
%%
function f = computeSquare(x)
f = x.^2;
end

%%
function g = computeRoots(b)
g = 3*b.^(1/2);
end

function q = sum(x, y)
q = x+y;
end


