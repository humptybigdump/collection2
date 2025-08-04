function dy = Elast_Pend_DAE2(t,y,par)
  % Solution vector
  % y(1)  = x_1
  % y(2)  = y_1
  % y(3)  = x_2
  % y(4)  = y_2
  % y(5)  = vx_1
  % y(6)  = vy_1
  % y(7)  = vx_2
  % y(8)  = vy_2
  % y(9)  = lambda
  % y(10) = mu
  
  g  = (y(1)-y(3))^2+(y(2)-y(4))^2-par.l^2;
  G = Elast_Pend_DAE_calcG(t,y,par);
  v  = [y(5);
        y(6);
        y(7);
        y(8)];
  lambda = y(9);
  mu     = y(10);
  
  dy   = [y(5:8) + G.'*mu;
          Elast_Pend_DAE_eqDyn(t,y,G,lambda,par)
          g;
          G*v];
end