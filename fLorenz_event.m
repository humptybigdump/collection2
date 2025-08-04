function [value, isterminal, direction] = fLorenz_event(t, x)
  % Poincaré Bedingung
  nBed = x(2);
  % Ouput
  value      = nBed;
  isterminal =    0;   % 1 (yes)     |  0 (no)
  direction  =    0;   % 1 (rising)  |  0 (all)  |  -1 (declining)
end
