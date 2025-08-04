function [grvqi] = evgrv0(xqi, t)

%************************************************
% evgrv : Unterprogramm zur Berechnung von grad(V)
%
%
% Aufruf durch evkft0.m
%
% hier zunaechst : V = V0 (Keplerterm)
%
%
% xqi	: Ortsvektor im qiS
% t	: aktueller Zeitpunkt
% grvqi	: grad(V) bzgl. des qiS
%
%************************************************

format long g

global RHO K MUE AMOD 



%--------------------------------------
grvqi= zeros(3,1);


%------------------------------------------------------------------------
% 1.) Berechnung von grad(V0) mit raumfesten kartes. Koordinaten

grvqi= -(MUE/ (sqrt(xqi(1)^2 + xqi(2)^2 + xqi(3)^2) )^3 ) * xqi(1:3);

%------------------------------------------------------------------------
