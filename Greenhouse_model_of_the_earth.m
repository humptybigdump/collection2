% Calculates radiation temperature of the earth using a two level glas
% house model (according to Kraus die Atmosphäre der Erde)
% We assume the earth acting as a perfect black body and the athmosphere as
% light grey
% S = solar constant 
% Sigma= Stefan Boltzman constant
% Epsilon_atm= near infrared emmissivity of the atmospher, to be changed
% albedo= globale average short wave albedo of the earh
%
% Parameter settings
epsilon_atm=0.807; % Changes assume different concentrations of green house gases 
albedo=0.3; % from textbook
sigma=5.6e-8; % from textbook
S=1361; % from textbook

% Calculations (see Kraus for derivation)
Tb=(S/(4*sigma)*(1-albedo)/(1-epsilon_atm/2))^0.25;
Tatm=(0.5*Tb^4)^0.25;
display('Assumed long wave emmissivity of the atmosphere:');
display(num2str(epsilon_atm));
display('Corresponding radiation temperature of the earth in K:');
display(num2str(Tb));