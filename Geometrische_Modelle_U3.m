%%
clear variables
close all
clc

%%
A = zeros(20, 10);
for l = 1 : 20
    for k = 1 : 10
        if l == k
            A(l,k) = 100*randi(5);
        else
            A(l,k) = randi(5);
        end
    end
end

B = A'*A;
b = randi([1 10], 20, 1);

boolean rangueberpruefen;
rangueberpruefen = (rank(A) == 10);

boolean symmetriecheck;
symmetriecheck = (B == B');
  
eigenwerte = eig(B);

XA = (1:1:length(eigenwerte));
figure;
title('Eigenwerte von A');
xlabel('Menge der Eigenwerte');
ylabel('Eigenwert');
scatter(XA, eigenwerte);

R = chol(B)';

y = linsolve(R, A'*b);

xa = linsolve(R', y);

xb = linsolve(A'*A, A'*b);



