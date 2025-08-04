%% Water and Energy Cycles. WS 24/25
%% Exercise 5: Soil hydraulic functions
%% Task 1: Generating soil water retention and soil hydraulic conductivity curves of three soils
% select three soil types of your choice from Table 1. Insert the
% respective letter (in first column) into the follwoing array "soil". IMPORTANT: The letters
% must be written into quotation marks as we want to use them as "string"
% values for plotting.
soil = {'INSERT LETTER OF FIRST SOIL TYPE INSIDE QUOTATION MARKS','INSERT LETTER OF FIRST SOIL TYPE INSIDE QUOTATION MARKS','INSERT LETTER OF FIRST SOIL TYPE INSIDE QUOTATION MARKS'};

% select soil hydraulic parameters from Table 1. This time without
% quotation marks as we now again want to use them as "double" values
% (numbers)
thr = ['INSERT thr OF FIRST SOIL TYPE','INSERT thr OF SECOND SOIL TYPE','INSERT thr OF THIRD SOIL TYPE']; % thr = residual water content of the soil
ths = ['INSERT SAME SYNTAX THAN BEFORE FOR ths OF THREE SOIL TYPES'];   % ths = Porosity of the soil, water content at saturation
alpha = 'INSERT SAME SYNTAX THAN BEFORE FOR alpha OF THREE SOIL TYPES';  % alpha = Air entry value in 1/m (inverted)
n_vg = 'INSERT SAME SYNTAX THAN BEFORE FOR n_vg OF THREE SOIL TYPES';  % n_vg = width of the pore size distribution
ks= 'INSERT SAME SYNTAX THAN BEFORE FOR ks OF THREE SOIL TYPES'; % ks = saturated hydraulic conductivity, in m/s
m_vg = 1 - 1./n_vg;

% open figure
figure
p1=[];
p2=[];

% starting for-loop to repeat calculations for each of the three soil types.
% IMPORTANT: remember to use the "i" to index each of the soil hydraulic
% parameters in the calculations, e.g, "thr(i)", "ths(i)" etc.
for i = 1:3
    
% define array with soil water content from thr to ths with delt_theta step
% size of 10^-7. For the theta values in this array, you subsequently
% calculate the corresponding k(theta) and psi(theta) values
theta=[thr(i):10e-7:ths(i)];   

% Calculate S and psi with converted Eq. 1
S = 'INSERT CALCULATION OF S FOR EACH theta VALUE WITH EQ. 1' ;% relative saturation
psi = 'INSERT CALCULATION OF psi FOR EACH PREVIOUSLY CALCULATED S VALUE USING CONVERTED EQ. 1';

% Calculate K(S) with Eq. 2
k = 'INSERT CALCULATION OF K FOR EACH PREVIOUSLY CALCULATED S VALUE USING EQ. 2' ;

% Calculation of effetive field capacity of soil:
% definition of psi (m) at PWP and FC
psi_PWP = -150;
psi_FC = -0.68;

% 1: calculate relative saturation S at PWP with Eq. 1 and psi_PWP(in
% absolute values)
S_PWP = 'INSERT CALCULATION OF S_PWP BY USING psi_PWP AND EQ.1';

% 2: % 2: calculate soil water content theta at PWP with S_PWP and Eq.1
theta_PWP = 'INSERT CALCULATION OF theta_PWP BY USING S_PWP AND CONVERTED EQ. 1';

% 3: calculate relative saturation S at FC with Eq. 1 and psi_FC (in
% absolute values)
S_FC = 'INSERT CALCULATION OF S_FC BY USING psi_FC AND EQ.1';

% 4: calculate soil water content theta at FC with S_FC and Eq.1
theta_FC = 'INSERT CALCULATION OF theta_FC BY USING S_FC AND CONVERTED EQ. 1';

% 5: calculate effective field capacity with Eq. 3
eff_FC = 'INSERT CALCULATION OF EFFECTIVE FIELD CAPACITY BY USING EQ. 3'

% plot of soil water retention curve and soil hydraulic conductivity curve
subplot(2,1,1);
p1 = [p1;semilogy(theta,abs(psi),'-','linewidth',2,'DisplayName',soil{1,i})];
hold on
semilogy(theta_PWP,abs(psi_PWP),'go','linewidth',2);
semilogy(theta_FC,abs(psi_FC),'go','linewidth',2);
xlabel('Soil water content [-]','fontsize',16);
ylabel('Psi [m]','fontsize',16);
set(gca,'linewidth',2, 'fontsize',16);
ylim([10^-2 10^7])
title('soil water retention curves')
legend([p1],'location', 'best')

subplot(2,1,2);
p2 = [p2;semilogy(theta,k,'-','linewidth',2,'DisplayName',soil{1,i})];
hold on
xlabel('Soil water content [-]','fontsize',16);
ylabel('k [m/s]','fontsize',16);
set(gca,'linewidth',2, 'fontsize',16);
ylim([10^-20 10^-4])
title('soil hydraulic conductivity curve')
legend([p2],'location', 'best')

end

%% Task 2: Sensitivity of soil water retention curves of different soils to alpha
% Use your code from Task 1, play around with the parameter alpha (e.g., try equally high and low values for all soil types) and run the code again.  
% for example: try alpha = 0.5, or alpha = 14.50 for all three soil types.
% What can you see compared to the previous soil water retention curves of
% the three soil types from Task 1?