function [value, isterminal, direction] = fRoessler_event(t,x)
  % Poincaré Bedingung
  nBed = x(1)+5;
  % Ouput
  value      = nBed;
  isterminal =    0;   % 1 (yes)     |  0 (no)
  direction  =    0;   % 1 (rising)  |  0 (all)  |  -1 (declining)
end