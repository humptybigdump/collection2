%-------------------------------------------------------------
function [phi]=final_solution(x,kx,u,nu,time);
%
% Use: [phi]=final_solution(x,kx,u,nu,time);
%
% Computes the solution of a linear advection-diffusion
% equation in periodic domain (with period=1), with initial condition:
% plane wave. 
%
% phi=sin(kx*x')*exp(-kx^2*\nu*time)
%
% where: x'=x-u*time
%
x_prime=mod(x-u*time,1);
phi=sin(kx*x_prime)*exp(-kx^2*nu*time);