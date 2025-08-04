function [loc_to_glob, eta] = element_data(mesh, space_type, element_num)
%
% obtain local-to-global DOF map and parametrization for an element
%
% Supported space types:
%
%  'pw_const'  The trial space consists of piecewise constant functions. Each element is associated
%              with one degree of freedom. The global DOF numbering corresponds to the element
%              numbering. The shape function is just the constant function 1.
%
% 'pw_linear'  The trial space consists of piecewise linear functions. Each element is associated
%              with two degree of freedom. The global DOF numbering corresponds to the node 
%              numbering in the mesh. The shape functions are 1-t and t.
%
% Output:
%
% loc_to_glob  The local to global map for this element. It is a row vector of length m, where m is
%              the number of local degrees of freedom. Each entry is the global DOF corresponding to
%              this local DOF. 
%
%         eta  The parametrization of this element. The function will take a column vector t with 
%              values from [0, 1] and return a length(t) x 2 matrix containing the coordinates of 
%              the corresponding points.
%

eta = @(t) affine_param(mesh, element_num, t);

if strcmp(space_type, 'pw_const')
    
    loc_to_glob = element_num;    

elseif strcmp(space_type, 'pw_linear')

    loc_to_glob = mesh.elements(element_num, :);

else
    error('Unknown space type: %s\n', space_type);
end


end


function x = affine_param(mesh, element_num, t)
%
% An element is always parametrized as a straight line: x = p + t (q -p), t \in [0, 1].
% Here p is the start node, q the end node.
%

start_node = mesh.nodes(mesh.elements(element_num, 1), :);
end_node = mesh.nodes(mesh.elements(element_num, 2), :);

x = start_node + t * (end_node - start_node);

end