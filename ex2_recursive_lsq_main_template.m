% Script: ex2_recursive_lsq_main
%
%  TEMPLATE
%
%  Description:
%          Main file to run recursive LSQ for a given example
%
%  Specials:
%          -
%
%  Authors: Thomas Meurer (KIT)
%  Email: thomas.meurer@kit.edu
%  Website: https://www.mvm.kit.edu/dpe.php
%  Creation date: 20.11.2023
%  Last revision date: 13.11.2024
%  Last revision author: Thomas Meurer (KIT)
%
%  Copyright (c) 2023, DPE/MVM, KIT
%  All rights reserved.

close all;
clear all; 

% ----------------------------------------------------------------------------------------------
% Initialize

% Parametrize ARX model structure
parx.na = 6; %PLAY with both orders
parx.nb = 5; 

% Load data set and choose a scenario
load('ex2_system1_data.mat');
t  = t1;
u  = u1;
y  = y1;
Ts = mean(diff(t)); %get sampling time assume t is equally spaced

% ----------------------------------------------------------------------------------------------
% Identification

% Initialize recursive LSQ
alpha = ??? %ADD
Pini = alpha*eye(parx.na+parx.nb+1);       %PLAY with alpha
pini = zeros(parx.na+parx.nb+1,1);
dpest = zeros(size(pini,1),length(t)-2); %Matrix to store estimation error

%Loop over samples
for k=1:1:length(t)-1

    %Evaluate
    [Pk,pk] = % *** YOUR_FUNCTION_IMPLEMENTING_RECURSIVE_LSQ;

    %Store pk value
    pest{k}.p = pk;

    %For analysis purposes compute change
    if k>1
        dpest(:,k-1) = pest{k}.p-pest{k-1}.p;
        dnorm(k-1)   = norm(dpest(:,k-1)); 
    end

    %Update
    % *** IN CASE YOU NEED TO UPDATE VARIABLES DO THIS HERE
    
end

% Create the corresponding z-transfer function
phat = pest{k}.p; %pick the last one
Gest = % *** SETUP THE TRANSFER FUNCTION USING YOUR RESULTS FROM ABOVE

% ----------------------------------------------------------------------------------------------
% Comparison and prediction

% Compare
yest = lsim(Gest,u,t);
figure(1); 
%
subplot(2,1,1); hold on
stairs(t,y,'b-');
stairs(t,yest,'r-');
%
subplot(2,1,2);
stairs(t,y-yest); 

%Predict behavior for other data set
ypred = lsim(Gest,u2,t2);
figure(2); 
%
subplot(2,1,1); hold on
stairs(t2,y2,'b-');
stairs(t2,ypred,'r-');
%
subplot(2,1,2);
stairs(t2,y2-ypred); 
