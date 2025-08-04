function [Pk,pk] = ex3_recursive_lsq_hammerstein_algorithm_template(k,u,y,parx,pini,Pini)
%
% TEMPLATE
%
% Function: ex3_recursive_lsq_hammerstein_algorithm
%
%  Description:
%          Implementation of recursive LSQ including a Hammerstein model
%
%  Specials:
%          -
%
%  Function Inputs:
%          k    ... current sampling step
%          u    ... system input u(j) for j=0,1,...,k
%          y    ... system output y(j) for j=0,1,...,k
%          parx ... structure of parameters for ARX model structure with
%                      parx.na   ... considered samples in A(q)
%                      parx.nb   ... considered samples in B(q)
%                      parx.ha   ... maximum power to be considered in Hammerstein part
%          pini ... initial value for parameter estimation phat(k-1)
%          Pini ... initial value for matrix P(k-1) 
%
%  Function Outputs:
%  
%  Authors: Thomas Meurer (KIT)
%  Email: thomas.meurer@kit.edu
%  Website: https://www.mvm.kit.edu/dpe.php
%  Creation date: 03.12.2023
%  Last revision date: 25.11.2024
%  Last revision author: Thomas Meurer (KIT)
%
%  Copyright (c) 2023, DPE/MVM, KIT
%  All rights reserved.

% Initialization of ARX model
na = parx.na;
nb = parx.nb;

% Initialization of Hammerstein model
ha = parx.ha.num;

yk = y(end);

% Set up the data vector
%
% Note that this can be realized more efficient, e.g., by handing over the previous data vector as output
% argument to the function and returning this vector as input in the next step to be processed further
%
S = zeros(1,na+(nb+1)*ha);
sy = zeros(1,na);
su = zeros(1,nb+1);
yi = [k-1:-1:k-na];
ui = [k:-1:k-nb];
iy = find(yi>0); 
iu = find(ui>0);
if ~isempty(iy)
    sy(iy) = y(yi(iy));
end
if ~isempty(iu)
    % ... TO DO: ADD A FOR LOOP ADDING THE STATIC NONLINEAR CONTRIBUTIONS DEFINED BY parx.ha.fun(j,u(ui(iu))); FOR j=2,3,...,ha
end
S = [sy,su]';

%Estimate parameter vector according to Algorithm 1 from lecture notes
kk = Pini * S/(1+S'*Pini*S);
Pk = Pini - (kk*S')*Pini;
pk = pini + kk*(yk-S'*pini); 

end

