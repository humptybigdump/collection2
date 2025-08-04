function x_dt = fLinSys(t, x, xA)
  % Parameters
  % ODE-Zustände
  x_dt      = zeros(12,1);
  x_dt(1:3) = xA*x(1:3, 1);
  % Jacobi-Matrix
  xJ = xA; 
  % Zustände der Monodromiematrix
  x_dt(4:6, 1)   = xJ*x(4:6, 1);
  x_dt(7:9, 1)   = xJ*x(7:9, 1);
  x_dt(10:12, 1) = xJ*x(10:12, 1);
end