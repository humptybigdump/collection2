function [t_j, t_m] = elements_connected(mesh, j, m)
%
% check whether the elements j and m have a point in common. If so, the
% function returns the parameter values of such a point with respect to the 
% parametrization of each elemenet, i.e. eta_j(t_j) = eta_m(t_m).
%
% If there are no common points, return t_j = t_m = -1.
%
% The function is used to check whether two elements, that are not
% identical are connected. This is the case if the elements have a common
% end point, so the function checks all possible combinations of end
% points.
%

nodes_j = mesh.elements(j, :);
nodes_m = mesh.elements(m, :);

if (nodes_j(1) == nodes_m(1))
    t_j = 0.0;
    t_m = 0.0;
elseif (nodes_j(1) == nodes_m(2))
    t_j = 0.0;
    t_m = 1.0;
elseif (nodes_j(2) == nodes_m(1))
    t_j = 1.0;
    t_m = 0.0;
elseif (nodes_j(2) == nodes_m(2))
    t_j = 1.0;
    t_m = 1.0;
else
    t_j = -1.0;
    t_m = -1.0;
end

end