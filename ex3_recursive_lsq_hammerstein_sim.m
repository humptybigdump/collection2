function y = ex3_recursive_lsq_hammerstein_sim(t,u,y0,parx,pval)
%
% Function: ex3_recursive_lsq_hammerstein_sim
%
%  Description:
%          Simulation of discrete time difference equation resulting from recursive LSQ including a Hammerstein model
%
%  Specials:
%          -
%
%  Function Inputs:
%          t    ... time vector
%          u    ... system input u(j) for j=0,1,...
%          y0   ... system output y(0) as initial condition
%          parx ... structure of parameters for ARX model structure with
%                      parx.na   ... considered samples in A(q)
%                      parx.nb   ... considered samples in B(q)
%                      parx.ha   ... maximum power to be considered in Hammerstein part
%          pval ... estimated model parametes 
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

% Set up output vector to be called in the main part
y  = [y0,zeros(1,length(u)-1)];

% Main part
for k=2:1:length(t)

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
        su(iu) = u(ui(iu));
        for j=2:1:ha % ... TO DO: CHECK IF THIS CALL MATCHES YOUR SETUP
            sh     = zeros(1,nb+1);
            sh(iu) = parx.ha.fun(j,u(ui(iu)));
            su     = [su,sh];
        end
    end
    S = [sy,su]';

    y(k) = pval'*S;
    
end






