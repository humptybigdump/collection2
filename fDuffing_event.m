function [value, isterminal, direction] = fDuffing_event(t, x)
  % Poincaré Bedingung
  nBed = cos(x(3));
  % Ouput
  value      = nBed;
  isterminal =    0;   % 1 (yes)     |  0 (no)
  direction  =    1;   % 1 (rising)  |  0 (all)  |  -1 (declining)
end