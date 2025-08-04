%calculation the freundlich isotherm and retardation coefficient
% speficy bulk density and soil moisture at experimental site
% Bromoxynil
rho=1.500;   % kg/L
theta=0.4;  % m3/m3

% KF and beta values taken from footprint database
kf_mean=7.05;
kf_low=1.6;
kf_high=12.5;                       % dimension here mg^(1-beta) * L^beta / kg;  

beta=0.7;

% Specify maximum concentration in the water phase
CWmax=90 %Cw dimension is g/m3 = mg/L
dCw=0.1; %stept

%%% to be completed Cw=[0: dCw :??]; %Cw dimension is kg/m3

% Equilibrium concentrations in solid phase [mg / kg] using the Freundlich
% isotherme
Ct_mean =???;
Ct_low = ??;
Ct_high = ???;

figure;
h1=plot(Cw,Ct_mean,'r+-','linewidth',2);
hold on;
h2=plot(Cw,Ct_low,'b+-','linewidth',2);
hold on;
h3=plot(Cw,Ct_high,'g-','linewidth',2);

legend([h1 h2 h3],'kf-mean','kf-low','kf-high');
xlabel(' Concentration in water phase [mg/L]','fontsize',14);
ylabel(' Concentration in absorbed phase  [mg/kg]','fontsize',14);
set(gca,'fontsize',14,'linewidth',2);

% Retardation coefficients
% to be completed
%Rcw_mean=1+rho/theta*????;
%Rcw_low=;
%Rcw_high=;

figure;
h4=plot(Cw,Rcw_mean,'r-','linewidth',2);
hold on;
h5=plot(Cw,Rcw_low,'b-','linewidth',2);
hold on;
h6=plot(Cw,Rcw_high,'g-','linewidth',2);
legend([h4 h5 h6],'kf-mean','kf-low','kf-high');
xlabel(' Concentration in water phase [g/m^3]','fontsize',14);
ylabel(' Retardation coefficient','fontsize',14);
set(gca,'fontsize',14,'linewidth',2);

%calculate the Kd value and R at low concentrations
Cw_low=CWmax /100;
% mean value
Ct_low_mean = kf_mean*Cw_low^beta;
Kd_mean=Ct_low_mean/Cw_low
R_mean=1+rho*Kd_mean/theta
% minimum value
Ct_low_low=kf_low*Cw_low^beta;
Kd_low=Ct_low_low/Cw_low
R_low=1+rho*Kd_low/theta

% maximum value
Ct_low_high=kf_high*Cw_low^beta;
Kd_high=Ct_low_high/Cw_low
R_high=1+rho*Kd_high/theta

