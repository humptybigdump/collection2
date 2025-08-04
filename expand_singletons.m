function varargout = expand_singletons(varargin)
%expand_singletons Expand singleton dimensions
% Expand singleton dimensions to other argument's size 
% in order to vectorize any function or to pass arguments to arrayfun. 
%
% All input arguments must have compatible sizes:
% https://de.mathworks.com/help/matlab/matlab_prog/compatible-array-sizes-for-basic-operations.html 
%
% Note that if your function to be vectorized has only two inputs 
% (binary function), you might be able to use use the builtin bsxfun() 
% instead as this does not generate an in-memory copy. 
%
% Many native MATLAB operators already support implicit singleton expansion, see also
% https://blogs.mathworks.com/loren/2016/10/24/matlab-arithmetic-expands-in-r2016b/ 
%
% Example: binomial coefficient; nchoosek() doesn't support vectorized comuptation 
%  n = 5:20;  k = (1:5)';          % Inputs 
%  [n,k] = expand_singletons(n,k); % Expand to same size
%  b = NaN(size(n));               % Ouput allocation 
%  % Calculation via for loop
%  for l = 1:numel(n)
%    b(l) = nchoosek(n(l),k(l));
%  end
%  % Alternative calculation via arrayfun
%  b = arrayfun(@nchoosek, n, k);
% 
% TODO: solution where singleton dimensions are not copied (as this causes
%       unnecessary RAM usage) but rather referenced via a function instead. 
%
% Author: Daniel Frisch @ ISAS, KIT, 12.2020
% 

args = varargin;
dims = max(cellfun(@ndims,args));
for d = 1:dims
  % find size of all arguments along current dimension d
  szd = cellfun(@(arg) size(arg,d), args);
  % find non-singleton dimensions
  ind = szd>1;
  nonsingleton = unique(szd(ind));
  assert(length(nonsingleton)<=1, 'Non-singleton dimensions must match')
  if ~isempty(nonsingleton)
    % find singleton dimensions
    singletons = find(szd==1);
    % expand to nonsingleton size
    for k = singletons
      repvec = ones(1,dims);
      repvec(d) = nonsingleton;
      args{k} = repmat(args{k}, repvec);
    end
  end
end
assert(all(diff(cellfun(@numel,args))==0))

% Return expanded arguments
for k = 1:length(args)
  varargout{k} = args{k};
end

end

