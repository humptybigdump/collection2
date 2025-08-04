function G = Elast_Pend_DAE_calcG(t,y,par)
  G = [-2*(y(3)-y(1)) -2*(y(4)-y(2)) 2*(y(3)-y(1)) 2*(y(4)-y(2))];
end