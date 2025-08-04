function [f]=flux_upwind(a,phi,iface,nx);
%
%Use: [f]=flux_central(a,phi,iface,nx);
%
% computes a first order upwind approximation to the 
% flux "f=a*\phi" of a linear 1D advection problem,
% evaluated at a cell-face.
%
% input:
%
% a         - advection speed 
% phi(1:nx) - cell-averaged values of "phi" 
% iface     - index of the current cell-face
% nx        - dimension of the vector "phi"
%
% output:
%
% f         - the computed flux value 
%
%
ileft=iface-1;
iright=iface;
%"wrap-around" correction for periodicity:
if ileft<1
 ileft=nx; 
end
if iright>nx
 iright=1; 
end
%
if a>0
  f=a*phi(ileft);
else
  f=a*phi(iright);
end