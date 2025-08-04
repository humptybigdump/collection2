function y = explEuler(odeFun, t, y0, varargin)
%
%  out = explEuler(odeFun,t,y0,varargin)
%    
%  Computes explicit Euler approximations
%
% Input arguments:
%
%   odeFun  - handle for y' = f(t,y)
%   t       - time array
%   y0      - initial value
%
% Output:
%
%   y       - vector with approximations
%
%

nsteps = length(t);

y = zeros(2,nsteps);
y(:,1) = y0;

for k=1:nsteps-1
    hc = t(k+1)-t(k);
    y(:,k+1) =  y(:,k) + hc*odeFun(t(k),y(:,k)); 
end
