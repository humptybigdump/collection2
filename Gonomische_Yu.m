% gnomonischen Projektion
clear all
clc

R=637100000; % Erdradius in cm
rho=180/pi;
M= 10000000;
% Geographische Länge und Breite in eine Matrix schreiben
geogra=xlsread('Geograkoordinaten.xlsx');
Staedte = {'London';' Dublin';' Kopenhagen';' Berlin';' Warschau';' Wien';' Bologna';' Marseille';' Madrid';' Santiage de Compostela';'KA'}; % ohne Nordpol
lambda = geogra(1:11,1);  % geographische Länge
phi = geogra(1:11,2);     % geographische Breite

lambda_rad=lambda/rho; % geographische Länge in Radien
phi_rad=phi/rho; % geographische Breite in Radien

% Cos Funktion um delta zu berechnen
cosdelta=cos(pi/2-phi_rad(11))*cos(pi/2-phi_rad)+sin(pi/2-phi_rad(11)).*sin(pi/2-phi_rad).*cos(lambda_rad-lambda_rad(11));
delta=acos(cosdelta);

%Sinus satz Benutzen um alpha zu berechnen

sinalpha=sin(lambda_rad-lambda_rad(11)).*sin(pi/2-phi_rad)./sin(delta);
for i = 1:length(sinalpha)
    if (phi_rad(i) >= phi_rad(11)) %&& (laengenRad(i) >= lambdaH)    % Quadrant 1 ok
            alpha(i,1) = asin(sinalpha(i));
            disp('case 1');
    elseif (phi_rad(i) < phi_rad(11)) %&& (laengenRad(i) >= lambdaH) % Quadrant 2
            alpha(i,1) = pi - asin(sinalpha(i));  
            disp('case 2');
    end
end

%Koordinaten berechnen
x=1/M*R*tan(delta).*cos(alpha); % in cm
y=1/M*R*tan(delta).*sin(alpha); % in cm

x(end) = 0; % Karlsruhe
y(end) = 0;

figure('Name','Städte')
hold on
plot(y,x,'o')
title('gnomonischen Projektion mit Karlsruhe als Berührpunkt');

for i=1:length(y)
text(y(i),x(i),Staedte(i))
end

%% Orthodrome zwischen Karlsruhe und Kopenhagen
lambda1=lambda_rad(11); % Länge in KA
phi1=phi_rad(11);% Breite in KA

lambda2=lambda_rad(3); % Länge in Kopenhagen
phi2=phi_rad(3);  % Breite in Kopenhagen

lambda_vec = linspace(lambda1,lambda2,100);               
%phi_Orthodrom=atan((tan(phi_KA)*sin(phi_Kopenhagen-lambda_vec) + tan(phi_Kopenhagen)*sin(lambda_vec-lambda_KA)) / sin(lambda_Kopenhagen-lambda_KA));

s = acos(sin(phi1).*sin(phi2) + cos(phi1).*cos(phi2).*cos(lambda2-lambda1));
%s_o = R*s;
A1 = acos((sin(phi2)-sin(phi1).*cos(s))./(cos(phi1)*sin(s))); % Azimut
%phi_o = atan((tan(phi1).*sin(lambda2-lambda_vec) + tan(phi2).*sin(lambda_vec-lambda1))./sin(lambda2-lambda1));

delta_o=linspace(0,delta(3),100);
x_Orthodrom=1/M*R*tan(delta_o).*cos(A1); % in cm
y_Orthodrom=1/M*R*tan(delta_o).*sin(A1); % in cm

plot(y_Orthodrom,x_Orthodrom)
%% Loxodrom zwischen Karlsruhe und Kopenhagen
%beta = atan((lambda2-lambda1)./(log(tan(pi/4 + phi2/2))-log(tan(pi/4 + phi1/2))));%Kurswinkel berechnen

beta = atan((lambda2-lambda1)./(log(tan(pi/4 + (phi2-phi1)/2))-log(tan(pi/4 ))));%Kurswinkel berechnen
s=((R./cos(beta)).*(phi2-phi1));

ds =linspace(0,s,100);                  
phi_loxodrom =cos(beta).*ds/R;         
lambda_loxodrom =  sin(beta).*ds/R./cos(phi_loxodrom);
 
% x_LO=1/M*R*tan(phi_l).*cos(lambda_l); % in cm
% y_LO=1/M*R*tan(phi_l).*sin(lambda_l); % in cm
 [x_Loxodrom,y_Loxodrom] = Loxodrom(lambda_loxodrom, phi_loxodrom);
plot(y_Loxodrom,x_Loxodrom)
%% Verzerrungsellipsen fur die Stadte Berlin und Warschau

delta_Berlin=delta(4);
delta_Warschau=delta(5);


x_Berlin=x(4);
y_Berlin=y(4);

x_Warsch=x(5);
y_Warschau=y(5);

mu_Berlin = [x_Berlin, y_Berlin]; % Mittelpunkt
a_Berlin=1/cos(delta_Berlin)^2; % Halbmajorachse
b_Berlin=1/cos(delta_Berlin); % Halbminorachse
phi = pi/4; % Rotation der Elipse

% Verzerrungselipse berechnen
t_Berlin = linspace(0, 2*pi, 100);
x_b = a_Berlin * cos(t_Berlin);
y_b = b_Berlin * sin(t_Berlin);
X_Berlin = x_b * cos(phi) - y_b * sin(phi) + mu_Berlin(1);
Y_Berlin = x_b * sin(phi) + y_b * cos(phi) + mu_Berlin(2);


mu_Warschau = [x_Warsch, y_Warschau]; % Mittelpunkt 
a_Warschau=1/cos(delta_Warschau)^2;
b_Warschau=1/cos(delta_Warschau);



% Verzerrungselipse berechnen
t_Warschau = linspace(0, 2*pi, 100);
x_w = a_Warschau * cos(t_Warschau);
y_w = b_Warschau * sin(t_Warschau);
X_Warschau = x_w * cos(phi) - y_w * sin(phi) + mu_Warschau(1);
Y_Warschau = x_w* sin(phi) + y_w * cos(phi) + mu_Warschau(2);

% Visualiesierung des Verzerrungselipse
plot(Y_Berlin,X_Berlin, 'b-');
plot(Y_Warschau,X_Warschau, 'b-');
% Beschriftung von a und b für Stadt Berlin und Warschau in die Karte

text(y_Berlin-1,y_Berlin-1,'a_B=1.0058,b_B=1.0029','FontSize',8);
text(y_Warschau-2.5,x_Warsch+1,'a_W=1.0239,b_W=1.0119','FontSize',8);
%% Funktion
function [x, y] = Loxodrom(lambda, phi)
    R=637100000;
   M= 10000000;
   lambda_rad=lambda; 
   phi_rad=phi; 
    x=1/M*R*tan(phi_rad).*cos(lambda_rad); % in cm
    y=1/M*R*tan(phi_rad).*sin(lambda_rad); % in cm

end
