% Macro compare random field and krigged field from artificial observate

dim=200;
rand('seed',10);
close all;

data=load('ks_sphr_0,5_1,5_100_aniso.dat'); % structure x y z
dataip=load('ks_salami_aniso.dat'); % structure x y z
%
var1=var(data(:,3));
varip=var(dataip(:,3));
rand('seed',1);
dd=sqrt(length(data(:,1)));
x=data(1:dd,1);
y=data(1:dd,2);
z=data(1:dd,3); %random field
xip=dataip(1:dd,1);
yip=dataip(1:dd,2);
zip=dataip(1:dd,3); %interpolated field

for i=1:dd-1
    x=[x data(i*dd+1:i*dd+dd,1) ];
    y=[y data(i*dd+1:i*dd+dd,2) ];
    z=[z data(i*dd+1:i*dd+dd,3) ];
    xip=[xip dataip(i*dd+1:i*dd+dd,1) ];
    yip=[yip dataip(i*dd+1:i*dd+dd,2) ];
    zip=[zip dataip(i*dd+1:i*dd+dd,3) ];
end

figure;
pcolor(x,y,z);
ylabel('y [m]','fontsize',16);
xlabel('x [m]','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
title('log(ks)','fontsize',16);
shading flat;
h=colorbar;
titel=sprintf('Original. %f5.2',var1);
title(titel,'fontsize',16);
set(h,'fontsize',16,'linewidth',2);
hold on;
colormap jet;

im=floor(100*rand(dim,1)+ones(dim,1));
jm=floor(100*rand(dim,1)+ones(dim,1));
xm=zeros(length(im),1);
ym=zeros(length(im),1);
zm=zeros(length(im),1);
for i=1:length(im);
    xm(i)=x(im(i),jm(i));
    ym(i)=y(im(i),jm(i));
    zm(i)=z(im(i),jm(i));
end 
% plot location of measurements
plot(xm,ym,'k+');

figure;
pcolor(xip,yip,zip);
ylabel('y [m]','fontsize',16);
xlabel('x [m]','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
title('log(ks)','fontsize',16);
titel=sprintf('Interp. %f5.2',varip);
title(titel,'fontsize',16);
shading flat;
h=colorbar;
set(h,'fontsize',16,'linewidth',2);
hold on;
plot(xm,ym,'k+');
colormap jet;
