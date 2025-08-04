clear
close all
clc

alpha = pi/4;

lambda0 = 1;
lambday = lambda0/cos(alpha);
lambdaz = lambda0/sin(alpha);

w = 4*lambda0;
% this way we can also visualize the plane wave case (TEM)
if alpha == pi/2
    d = w/2;
else
    d = 2*lambday/2;
end

y = linspace(0,d,101);
z = linspace(0,w,101);
[Z,Y] = meshgrid(z,y);

omegat = (0:0.01:1)*4*pi;


h = figure;
% set(h, 'WindowState', 'maximized');
ax = gca(h);
E = cos(2*pi*Y/lambday).*sin(omegat(1)-2*pi*Z/lambdaz);
[~,c] = contourf(ax,z,y,E);

colormap(ax,colorcet('D1A'));
colorbar(ax);
set(ax,'CLim',[-1 1]);
axis(ax,'equal');

yline(0,'Color','black','LineWidth',1.5)
yline(d,'Color','black','LineWidth',1.5)

ylim(ax,[-0.1*d 1.1*d]);
set(ax,'XTick',linspace(0,1,5)*w,'XTickLabel',linspace(0,1,5)*w/lambda0);
set(ax,'YTick',0:lambday/2:d,'YTickLabel',(0:lambday/2:d)/lambday);

xlabel(ax,'z/\lambda_0');
ylabel(ax,'y/\lambda_y');

title(ax,"Einfallswinkel \alpha=" + round(rad2deg(alpha),1) + "°");

for k=2:length(omegat)
    c.ZData = cos(2*pi*Y/lambday).*sin(omegat(k)-2*pi*Z/lambdaz);
    drawnow;
end