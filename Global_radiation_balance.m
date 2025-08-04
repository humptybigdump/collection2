% Calculates Global radiation balance of the earth
% Rns = global average net short wave radiation
% RLup = global average emmission of thermal radiation by the earth
% RLdown = global average emmission of thermal radiation by the athmosphere
% (due to natural and antrophogene green house effect

Rns= 163.3 % W/m2
RLdown= 340.3 % W/m2
RLup= 398.2 % W/m2

%Net radiation balance Rn
Rn=Rns+ RLdown -RLup;

 display ('Global average radiation balance in W/m^2');
 display (Rn);

