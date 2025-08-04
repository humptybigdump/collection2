%BEGINN DATEI „F.m“
function res = F(X_Var, X_Para)
 
%Rückbenennung der zu bestimmenden Prozessgrößen X_Var
G = X_Var(1);
L = X_Var(2);
y_MeOH = X_Var(3);
y_H2O = X_Var(4);
x_MeOH = X_Var(5);
x_H2O = X_Var(6);
h_G = X_Var(7);
h_L = X_Var(8);
Q = X_Var(9);
 
%Rückbenennung der Prozessgrößen X_Para
F = X_Para(1);
z_MeOH = X_Para(2);
z_H2O = X_Para(3);
 
h_F = X_Para(4);
h_MeOH_L = X_Para(5);
h_H2O_L = X_Para(6);
h_MeOH_G = X_Para(7);
h_H2O_G = X_Para(8);
 
p_MeOH_sat = X_Para(9);
p_H2O_sat = X_Para(10);
p = X_Para(11);
 
%Modellgleichungen
%Stoffmengenbilanz Methanol
res(1) = F*z_MeOH - G*y_MeOH - L*x_MeOH;
%Stoffmengenbilanz Wasser
res(2) = F*z_H2O - G*y_H2O - L*x_H2O;
%Energiebilanz
res(3) = F*h_F - G*h_G - L*h_L + Q;
 
%Definition der Gemischenthalpie der Dampfphase
res(4) = h_G - y_MeOH*h_MeOH_G - y_H2O*h_H2O_G;
%Definition der Gemischenthaloie der Flüssigkeitsphase
res(5) = h_L - x_MeOH*h_MeOH_L - x_H2O*h_H2O_L;
%Definition des VLE für Methanol
res(6) = p*y_MeOH - x_MeOH*p_MeOH_sat;
%Definition des VLE für Wasser
res(7) = p*y_H2O - x_H2O*p_H2O_sat;
%Schließbedingung x_i
res(8) = 1 - (x_MeOH + x_H2O);
%schließbedingung y_i
res(9) = 1 - (y_MeOH + y_H2O);

end
%ENDE DATEI „F.m“
