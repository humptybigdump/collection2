function x_dt = fRoessler(t,x,vParams)
  % Parameters
  nA = vParams(1);
  nB = vParams(2);
  nC = vParams(3);
  % ODE-Zustände 
  x_dt    = zeros(12,1);
  x_dt(1) = -x(2) - x(3);
  x_dt(2) = x(1) + nA*x(2) ;
  x_dt(3) = nB + x(3)*(x(1) - nC);
  % Jacobi-Matrix
  xJ = [0 -1 -1 ; 1 nA 0; x(3) 0 -nC+x(1)]; 
  % Zustände der Monodromiematrix
  x_dt(4:6,1)   = xJ*x(4:6,1);
  x_dt(7:9,1)   = xJ*x(7:9,1);
  x_dt(10:12,1) = xJ*x(10:12,1);
end