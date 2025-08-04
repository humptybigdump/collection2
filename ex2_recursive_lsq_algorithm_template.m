function [Pk,pk] = ex2_recursive_lsq_algorithm_template(ADD_ARGUMENTS)
%
% TEMPLATE
%
% Function: ex2_recursive_lsq_algorithm
%
%  Description:
%          Implementation of recursive LSQ 
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
%          pini ... initial value for parameter estimation phat(k-1)
%          Pini ... initial value for matrix P(k-1) 
%
%  Function Outputs:
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

% Initialization of ARX model
na = parx.na;
nb = parx.nb;     
yk = y(end);

% Set up the data vector
%
% Note that this can be realized more efficient, e.g., by handing over the previous data vector as output
% argument to the function and returning this vector as input in the next step to be processed further
%

% *** ADD YOUR WAY TO SET UP THE DATA VECTOR

% ...

% S = ...;


%Estimate parameter vector according to Algorithm 1 from lecture notes
%
% *** RUN ALL NECESSARY COMPUTATIONS
%

end

