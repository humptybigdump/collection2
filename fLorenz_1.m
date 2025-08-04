function x_dt = fLorenz(t, x, vParams)
  % Parameters
  nA = vParams(1);
  nB = vParams(2);
  nC = vParams(3);
  % ODE-Zustände
  x_dt    = zeros(12,1);
  x_dt(1) = nA*(x(2) - x(1));
  x_dt(2) = x(1)*(nB - x(3)) - x(2);
  x_dt(3) = x(1)*x(2) - nC*x(3);
  % Jacobi-Matrix
  xJ = [-nA nA 0 ; nB - x(3) -1 -x(1); x(2) x(1) -nC]; 
  % Zustände der Monodromiematrix
  x_dt(4:6,1)   = xJ*x(4:6,1);
  x_dt(7:9,1)   = xJ*x(7:9,1);
  x_dt(10:12,1) = xJ*x(10:12,1);
end
