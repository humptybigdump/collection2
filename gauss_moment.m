function E = gauss_moment(n, muG, stdG)
%gauss_central Gaussian Moments
% Calculate central moments of scalar (one-dimensional) Gaussian random variable 
%
% Input arguments
%  - n    : order of moment
%  - muG  : mean of the Gaussian
%  - stdG : standard deviation of the Gaussian
%
% Output arguments
%  - E    : moments around origin (not around the mean like central moments) 
%
% Can't easily be vectorized because of binomial coefficient ... 
% Therefore individual computation via for-loop :( 

arguments
  n     double {mustBeNonnegative, mustBeInteger}
  muG   double {mustBeReal}
  stdG  double {mustBeNonnegative}
end

% Singleton expansion for easy referencing in for loop 
[n,muG,stdG] = expand_singletons(n,muG,stdG);

% Initialize results 
E = NaN(size(n));

% Find unused dimension for sum
dimS = max([ndims(n), ndims(muG), ndims(stdG)]) + 1;

% Calculate moments 
for l = 1:numel(n)
  % Prepare vector 0:n(l), in dimension dimS 
  nvec = 0:n(l); % (1 x n+1)  
  dimvec = ones(1,dimS);
  dimvec(dimS) = numel(nvec);
  nvec = reshape(nvec,dimvec);                      % (1 x 1 x ... x n+1)  0:n(l)
  % Include vector of n(l) 
  [nl0,nl1] = expand_singletons( nvec, n(l) );      % (1 x 1 x ... x n+1)  0:n(l), n(l) 
  % Calculate binomial coefficient: n(l) over 0:n(l)
  bincoeff = arrayfun( @nchoosek, nl1, nl0 );       % (1 x 1 x ... x n+1)
  % Calculate necessary central moments 
  C = gauss_centralmoment( n(l)-nvec, stdG(l) );    % (1 x 1 x ... x n+1)
  % Put everything together and sum up 
  E(l) = sum( bincoeff .* C .* muG(l).^nvec, dimS); % (1 x 1)    
end

end

