% Autor: Felix Birkelbach
% Datum: 19.11.2020

%A stellt eine Matrix dar, B einen Vektor 
A = randi([1 10],20,20);
B = randi([1 10],20,1);

[L,U] = lu(A);

y = linsolve(L,b);
x = linsolve(U,y);