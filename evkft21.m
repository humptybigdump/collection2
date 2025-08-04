function [kraft] = evkft1(xqi, t)

%***************************************************
%
% Aufruf durch bwdgl1.m
%
% Unterprogramm zur Berechnung der Kraftfunktion
% "Evaluation der Kraftfunktion"
% (rechte Seite der Bewegungs-DGL)
%
% bis jetzt beruecksichtigte Kraefte, die auf den
% Satelliten einwirken :
%
%   - Gravitationskraft der Erde unter Berucksich-
%     tigung der Anisotropie des Gravitationsfeldes
%     der Erde
%
%
%***************************************************


% Berechnung der Gravitationsbeschleunigung aufgrund der
% von der Erde ausgeuebten Gravitationskraft ( grad(V) ):
fgerde = evgrv1(xqi, t);

%======================
global K
global TINT

TINT(K)= t;
%======================


%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Berechnung der resultierenden Beschleunigung,
% die der Satellit erfaehrt :

kraft = fgerde;
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


%==============================================


%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Kontrollausgabe von K, t, t/per in Datei ktraus :

global K
global PERD TENDE
global KTRID

tms = clock;

anzaus1 = fprintf(KTRID, '%i %g %5.3g', [K; t; t/TENDE]);
%anzaus1 = fprintf(KTRID, '%i %g %5.3g\n', [K; t; t/TENDE]);

anzaus2 = fprintf(KTRID, '%s', '    Zeitmessung : ');
anzaus3 = fprintf(KTRID, '%g %g %g %g\n', ...
			[tms(3); tms(4); tms(5); tms(6); ]);
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
