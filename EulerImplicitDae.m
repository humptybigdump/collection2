function [t,y] = EulerImplicitDae(ode,tspan,IC,options)
  h = options.h;
  index = options.index;
  opts = optimset('Display','off');
  t = tspan(1):h:tspan(2);
  t(end) = tspan(2);
  y = zeros(length(IC),length(t));
  z = zeros(length(IC),length(t));
  y(:,1) = IC;
  M = Mass(options);

   % Consistent Initial Conditions
   G  = Pend_DAE_calcG(t(1),y(:,1),options.par);
   eq_IC = @(x) Pend_DAE_eqDyn(t,y(:,1),G,x,options.par);
   if index == 2
    mu = (G*G.')\(G*y((options.nF+1):(2*options.nF),1));
    y((2*options.nF+options.nZ+1):(2*options.nF+2*options.nZ),1) = mu;
   end

   lambda = fsolve(eq_IC,zeros(options.nZ,1),opts);
   y((2*options.nF+1):(2*options.nF+options.nZ),1) = lambda;

   butcher.c = 1;
   butcher.A = 1;
   butcher.b = 1;

  aeq = @(t,y,z) M*z-ode(t,y);

  % Time loop
  sdYZ = size([y(:,1); z(:,1)]);
  for i1=1:(length(t)-1)
      h=t(i1+1)-t(i1);
      % Calculating the stages
      dYZ = fsolve(@(dYZ) eq_RK(dYZ,t(i1),y(:,i1),z(:,i1),h,aeq,butcher),zeros(sdYZ),opts);
      % Y = y(:,i1)+dYZ((1:length(y(:,1))));
      Z = z(:,i1)+dYZ(((length(y(:,1))+1):2*length(y(:,1))));
      % Calculating the next step
      y(:,i1+1) = y(:,i1)+h*butcher.b*Z;
      z(:,i1+1) = (1-butcher.b/butcher.A)*z(:,i1)+butcher.b/butcher.A*Z;
  end
  y = y.';
end

function F = eq_RK(dYZ,t0,y0,z0,h,aeq,butcher)
 ny = length(y0);
 dY = dYZ(1:ny);
 dZ = dYZ((ny+1):2*ny);
 F = [dY-h*butcher.A*(z0+dZ);
      aeq(t0+butcher.c*h,y0+dY,z0+dZ)]; 
end
function M = Mass(options)
 if options.index == 2
    ni=2;
 else
    ni=1;
 end
 M = eye(2*options.nF+ni*options.nZ,2*options.nF+ni*options.nZ);
 for i1=(2*options.nF+1):(2*options.nF+ni*options.nZ)
    M(i1,i1) = 0;
 end
end