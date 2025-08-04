function C = gauss_centralmoment(n,stdG)
%gauss_central Gaussian Moments
% Calculate central moments of scalar (one-dimensional) Gaussian random variable 
%
% Input arguments
%  - n    : order of moment
%  - stdG : standard deviation of the Gaussian
%
% Output arguments
%  - C    : central moment 
%
% Can't easily be vectorized because of prod() ... 
% Therefore individual computation via for-loop :( 

arguments
  n     double {mustBeNonnegative, mustBeInteger}
  stdG  double {mustBeNonnegative}
end

% Singleton expansion for easy referencing in for loop 
[n,stdG] = expand_singletons(n,stdG);

% Initialize results 
C = zeros(size(n));

% Calculate moments 
for l = 1:numel(n)
  % Central moment is 0 for uneven order
  if mod(n(l),2)==0 
    % Even order: calculate the according nonzero moment
    C(l) = prod(1:2:n(l)-1) * stdG(l)^n(l); 
  end
end

end

