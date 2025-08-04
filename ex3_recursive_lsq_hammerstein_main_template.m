% Script: ex3_recursive_lsq_hammerstein_main
%
%  Description:
%          Main file to run recursive LSQ with Hammerstein model for a given example
%
%  Specials:
%          -
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

close all;
clear all; 

% ----------------------------------------------------------------------------------------------
% Initialize

% Parametrize ARX model structure
parx.na = 4; %PLAY with both orders
parx.nb = 1;

% Parameterize Hammerstein model
parx.ha.num = 3; %Number of functions or degree of used polynomial
parx.ha.fun = % ... TO DO: DEFINE A SUITABLE FUNCTION 

% Load data set and choose a scenario
load('ex3_system2_data.mat');
t  = t1;
u  = u1;
y  = y1;
Ts = mean(diff(t)); %get sampling time assume t is equally spaced

% ----------------------------------------------------------------------------------------------
% Identification

% Initialize recursive LSQ
Pini = 1e6*eye(parx.na+(parx.nb+1)*parx.ha.num);       
pini = zeros(parx.na+(parx.nb+1)*parx.ha.num,1);
dpest = zeros(size(pini,1),length(t)-2); %Matrix to store estimation error

%Loop over samples
for k=1:1:length(t)-1

    %Evaluate
    [Pk,pk] = ex3_recursive_lsq_hammerstein_algorithm(k,u(1:k),y(1:k),parx,pini,Pini);

    %Store pk value
    pest{k}.p = pk;

    %For analysis purposes compute change
    if k>1
        dpest(:,k-1) = pest{k}.p-pest{k-1}.p;
        dnorm(k-1)   = norm(dpest(:,k-1)); 
    end

    %Update
    Pini = Pk;
    pini = pk; 
    
end

% Create the corresponding discrete time i/o-model 
phat = pest{k}.p; %pick the last one

% ----------------------------------------------------------------------------------------------
% Comparison and prediction

% Compare
yest = ex3_recursive_lsq_hammerstein_sim(t,u,y(1),parx,phat);
yest = yest';
figure(1); 
%
subplot(2,1,1); hold on
stairs(t,y,'b-');
stairs(t,yest,'r-');
%
subplot(2,1,2);
stairs(t,y-yest); 

%Predict behavior for other data set with different input
if exist('y2','var')
    
    ypred = ex3_recursive_lsq_hammerstein_sim(t2,u2,y2(1),parx,phat);
    ypred = ypred';
    figure(2); 
    %
    subplot(2,1,1); hold on
    stairs(t2,y2,'b-');
    stairs(t2,ypred,'r-');
    %
    subplot(2,1,2);
    stairs(t2,y2-ypred);

end

%Predict behavior for other data set with different input and modified initial condition
if exist('y3','var')
    
    ypred = ex3_recursive_lsq_hammerstein_sim(t3,u3,y3(1),parx,phat);
    ypred = ypred';
    figure(3); 
    %
    subplot(2,1,1); hold on
    stairs(t3,y3,'b-');
    stairs(t3,ypred,'r-');
    %
    subplot(2,1,2);
    stairs(t3,y3-ypred); 

end
