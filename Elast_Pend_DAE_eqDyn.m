function dy = Elast_Pend_DAE_eqDyn(t,y,G,lambda,par)
  if sqrt(y(1)^2+y(2)^2) > 0
      Fcx = -par.c*(sqrt(y(1)^2+y(2)^2)-par.l0)*y(1)/sqrt(y(1)^2+y(2)^2);
      Fcy = -par.c*(sqrt(y(1)^2+y(2)^2)-par.l0)*y(2)/sqrt(y(1)^2+y(2)^2);
  else
      Fcx = 0;
      Fcy = 0;
  end
  r    = [Fcx;
      Fcy+par.m*par.gamma;
      0;
      par.m*par.gamma];
  M = par.m*eye(4,4);
  dy = M\(r+G.'*lambda);
end