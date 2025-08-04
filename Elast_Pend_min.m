function dy = Elast_Pend_min(t,y,par)
  M = par.m*[2                 0               par.l*cos(y(3));
             0                 2              -par.l*sin(y(3));
             par.l*cos(y(3)) -par.l*sin(y(3))  par.l^2];
  if sqrt(y(1)^2+y(2)^2) > 0
      Fcx = -par.c*(sqrt(y(1)^2+y(2)^2)-par.l0)*y(1)/sqrt(y(1)^2+y(2)^2);
      Fcy = -par.c*(sqrt(y(1)^2+y(2)^2)-par.l0)*y(2)/sqrt(y(1)^2+y(2)^2);
  else
      Fcx = 0;
      Fcy = 0;
  end
  r    = [Fcx+par.m*par.l*y(6)^2*sin(y(3));
          Fcy+2*par.m*par.gamma+par.m*par.l*y(6)^2*cos(y(3));
          -par.m*par.gamma*par.l*sin(y(3))];
  dy   = [y(4:6);
          M\r];
end