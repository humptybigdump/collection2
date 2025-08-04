function sigma = eval_shape_functions(space_type, t)
%
% evaluate the space functions for the specified space type in the values in the column vector t.
% This vector contains values from the reference interval [0, 1].
%
% Valid values for space_type are
%
%  'pw_const'  The function returns a column vector of the same size as t, containing the constant 1
%              in all entries.
%
% 'pw_linear'  The function returns a length(t) x 2 matrix. The first column has the values of 1-t,
%              the second column the values of t.
%


if strcmp(space_type, 'pw_const')
    
    sigma = ones(size(t));    

elseif strcmp(space_type, 'pw_linear')

    sigma = [1-t, t];

else
    error('Unknown space type: %s\n', space_type);
end

end