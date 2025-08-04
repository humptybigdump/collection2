function [dC_FeSulfatedt, dC_NaOHdt, dC_FeOHdt, dC_NaSulfatedt, dXdt, dV_Cdt] = func_CSTR_instat(C_FeSulfate_0_inlet,C_FeSulfate,C_NaOH_0_inlet,C_NaOH, C_FeOH, C_NaSulfate, Vdot_Feed_FeSulfate,Vdot_Outlet,Vdot_Feed_NaOH,V_C)
 
Vdot_in_FeSulfate = Vdot_Feed_FeSulfate;
Vdot_in_NaOH = Vdot_Feed_NaOH;

% Aenderungsrate des Reaktionsvolumens
dV_Cdt = Vdot_in_FeSulfate + Vdot_in_NaOH - Vdot_Outlet;

% Aenderungsraten der Molkonzentrationen
r_FeSulfate = (-1)*10*C_FeSulfate*C_NaOH*V_C;
dC_FeSulfatedt = Vdot_Outlet*C_FeSulfate_0_inlet/V_C - Vdot_Outlet*C_FeSulfate/V_C + r_FeSulfate;
dC_NaOHdt = Vdot_Outlet*C_NaOH_0_inlet/V_C - Vdot_Outlet*C_NaOH/V_C + 6*r_FeSulfate;
dC_FeOHdt = (-1)* Vdot_Outlet*C_FeOH/V_C - 2*r_FeSulfate;
dC_NaSulfatedt = (-1)* Vdot_Outlet*C_NaSulfate/V_C - 3*r_FeSulfate;

% Aktueller Umsatz X(t) [%]
% X = (C_FeSulfate_0_inlet - C_FeSulfate) / C_FeSulfate_0_inlet *100;

% Aenderungsrate des Umsatzes [%]
dXdt = (-1)*dC_FeSulfatedt/ C_FeSulfate_0_inlet *100;

end