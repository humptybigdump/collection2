function [t,y]=engine_simple

% define engine parameters
rpm=1e3; % engine speed revolutions per minute min-1
eps=10;  % compression ratio (max. Volume/min. Volume)

% Define "heat release" to model combustion. 
%   Temporal development of heat release is modeled as a Gaussian with 
%   peak-value P0 (J/(kg*s)), center t0 (s), and width dt (s). 
%   A narrow peak at top dead center leads to near-constant volume combustion. 
P0=1e11/1e3;  % peak specific power 
t0=60/(2*rpm); % peak center
dt=1e3*.015/(2*rpm); % temporal width of peak  
% intial state vector 
V0=engvol(0,rpm,eps); % initial volume (m3)
T0=298;               % initial temperature (K)
p0=1e5;               % initial pressure (Pa)
u0=0;                 % initial specific internal energy (J/kg)
MM=30e-3;             % molar mass (kg/mol)
Rgas = 8.3145;        % molar gas constant (J/(mol*K))
cv = Rgas*2.5;        % molar heat capacity at constant volume (J/(mol*K))
m=p0*V0*MM/(Rgas*T0); % mass in cylinder (kg)
y0=[V0,u0,T0,p0]';    % initial state vector 
opts=odeset('reltol',1e-5,'abstol',1e-10);
[t,y]=ode23tb(@eng_ode,[0,60/rpm],y0,opts); % call MATLAB's ODE solver to solve problem 

plot(t,y(:,3),'.-');

	function yp=eng_ode(t,y)
		% y=[V,u,T,p]
		V=y(1);u=y(2);T=y(3);p=y(4);
		[x,Vp]=engvol(t,rpm,eps);
		yp=zeros(size(y));
		yp(1) = Vp;
		yp(2) = -p*yp(1)/m + hrl(t,P0,t0,dt); 
		yp(3) = yp(2)/(cv/MM);
		yp(4) = (m*Rgas/MM*yp(3)-p*yp(1))/V;
	end
	function [V,Vp]=engvol(t,rpm,eps)
		% return the volume of an engine running at rpm revs per minute, 
		% with compression ratio eps, at time t. 
		% t=0 corresponds to top dead center (max. volume). 
		hlp=2*pi*rpm/60;
		V = 1 + 2/(eps-1) + cos(hlp*t);
		Vp = -hlp*sin(hlp*t);
	end
	function Qp = hrl(t,Q0,t0,dt)
		% "heat release" (specific power, J/(kg*s)) to model
		% the effect of combustion. 
		% P0: max. specific power
		% t0: time where max. occurs 
		Qp = Q0*exp(-((t-t0)/dt).^2);
	end
end