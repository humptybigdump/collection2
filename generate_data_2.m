% Script: generate_data
%
%  Description:
%          Main file to generate data by solving the PDE defined in
%          the function 'solve_pde'
%
%  Specials:
%          -
%
%  Authors: Thomas Meurer (KIT)
%  Email: thomas.meurer@kit.edu
%  Website: https://www.mvm.kit.edu/dpe.php
%  Creation date: 15.01.2024
%  Last revision date: 12.12.2024
%  Last revision author: Thomas Meurer (KIT)
%
%  Copyright (c) 2023, DPE/MVM, KIT
%  All rights reserved.

% Define the model parameters (cf. solve_pde.m)
p.d = 1.0; % diffusion parameter
p.c = 2.0; % convection parameter
p.fun = @(x,DxDz,z,t) -0.2*x + 5*sin(x); % reaction (use this to generate linear or nonlinear behavior) 

% Define the input
%p.t = 0:0.01:10.0;
%p.u = stepfun(p.t,1)-2*stepfun(p.t,2)-stepfun(p.t,3)+4*stepfun(p.t,4)-2*stepfun(p.t,6);

% Call the solver (using the standard initial condition)
[x,z,t] = solve_pde(p,p.ic);

% Plot simulation result
% figure(1);
% mesh(z,t,x);
% xlabel('z'); ylabel('t'); zlabel('x');



