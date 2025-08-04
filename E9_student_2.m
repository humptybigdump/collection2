%% Water and Energy Cycles. WS 23/24
%% Exercise 9: Water movement in unsaturated soils
% Code to calculate soil water flux and change in soil moisture in a vertical 1-D soil column using
% Darcy-Richards law

%% Initialisation (setting parameters and defining variables)
% 
thr = 0.065; 
ths = 0.41; 
alpha = 7.50; 
n_vg = 1.89; 
ks = 1.23e-5;

% 
z = -[0.025:0.025:1]'; 
dz = (diff(z));
dim = length(z);

% 
theta_topsoil = 0.35;  % initial soil mositure in upper soil/topsoil
theta_subsoil = 0.15;    % initial soil moisture in lower soil/subsoil
ip = find(z >= -0.2); % 

d_theta = (theta_topsoil - theta_subsoil) / length(ip); % 
theta = theta_subsoil * ones(dim,1);    % 
theta(ip) = [theta_topsoil : -d_theta : theta_subsoil+d_theta]; % 

% 
psi = zeros(dim,1); 
k = zeros(dim,1); 
q = zeros(dim-1,1); 

% time setting
t_start = 0; % 
time = t_start; % 
t_max = 30000; % 
dt = 100; % 
i_time = 1; % 

%% Main routine (solving Darcy-Richards law and plotting)
figure;

%
while time < t_max
    
% 
for i = 1:dim
    [k(i), psi(i)]=k_psi_theta(theta(i),thr,ths,alpha,n_vg,ks);
end

% 
for i = 1:dim-1 
    q(i) = (-0.5 * (k(i) + k(i+1))) * ((psi(i+1) - psi(i)) / dz(1) + 1);     
end

% Why does the loop start at position 2, what does this mean for the upper boundary condition?
for i = 2:dim-1
    theta(i) = theta(i) - dt * ((q(i-1)-q(i)) / abs(dz(1)));
end

time = time + dt;  % 

% 
subplot(2,2,1);
plot(theta,z,'b-','linewidth',2);
xlabel('Soil water content [-]','fontsize',16);
ylabel(' z [m]','fontsize',16);
set(gca,'linewidth',2, 'fontsize',16);
axis([thr ths 1.1*min(z) 0.9*max(z) ]);
title([ num2str(time) ' s'], 'fontsize', 16);

% 
subplot(2,2,2);
plot(psi,z,'g-','linewidth',2);
xlabel('Matric potential [m]','fontsize',16);
axis([1.1*min(psi) 0.9*max(psi)  1.1*min(z) 0.9*max(z) ]);
ylabel(' z[m]','fontsize',16);
set(gca,'linewidth',2, 'fontsize',16);

% 
subplot(2,2,3);
plot(q(1:dim-1),z(1:dim-1),'r-','linewidth',2);
ylim([1.1*min(z) 0.9*max(z)]);
xlabel('Darcy flux [m/s]','fontsize',16);
ylabel('z[m]','fontsize',16);
set(gca,'linewidth',2, 'fontsize',16);

% 
subplot(2,2,4);
plot(q(1:dim-1)./theta(1:dim-1),z(1:dim-1),'r-','linewidth',2);
ylim([1.1*min(z) 0.9*max(z)]);
xlabel('v [m/s]','fontsize',16);
ylabel('z[m]','fontsize',16);
set(gca,'linewidth',2, 'fontsize',16);


MM(i_time)=getframe; % 
i_time=i_time+1; % 

end
