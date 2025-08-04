function x_dt = fDuffing(t, x, vParams)
  % Paramter
  nBeta = vParams(1);
  nP    = vParams(2);
  nOm   = vParams(3);
  % ODE-Zustände
  x_dt    = zeros(12,1);
  x_dt(1) = x(2);
  x_dt(2) = 0.5*(x(1) - x(1)^3) - nBeta*x(2) + nP*cos(x(3));
  x_dt(3) = nOm;
  % Jacobi-Matrix
  xJ = [0 1 0 ; 0.5*(1 - 3*x(1)^2) -nBeta -nP*sin(x(3)); 0 0 0]; 
  % Zustände der Monodromiematrix
  x_dt(4:6,1)   = xJ*x(4:6,1);
  x_dt(7:9,1)   = xJ*x(7:9,1);
  x_dt(10:12,1) = xJ*x(10:12,1);
end