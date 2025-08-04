function sol = EulerExplicit(ode,tspan,IC,options)
  sol = struct();
  h = options.h;
  sol.x = tspan(1):h:tspan(2);
  sol.x(end) = tspan(2);
  sol.y = zeros(length(IC),length(sol.x));
  sol.y(:,1) = IC;
  for i1=1:(length(sol.x)-1)
      h=sol.x(i1+1)-sol.x(i1);
      sol.y(:,i1+1) = sol.y(:,i1) + h*ode(sol.x(i1),sol.y(:,i1));
  end
end