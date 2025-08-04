% Macro compare random field and krigged field from artificial observate

dim=200;
rand('seed',1);

data=load('ks_sphr_0,5_1,5_100.dat'); % structure x y z
dataip=load('interpolation.dat'); % structure x y z
%
threshold=qquantil(data(:,3),0.8);
% transform measurements into indicator values
indi=zeros(length(data(:,3)),1);
ipos=find(data(:,3) > threshold);
indi(ipos)=ones(length(ipos),1);

rand('seed',1);
dd=sqrt(length(data(:,1)));
x=data(1:dd,1);
y=data(1:dd,2);
z=indi(1:dd); %random field
xip=dataip(1:dd,1);
yip=dataip(1:dd,2);
zip=dataip(1:dd,3); %interpolated field

for i=1:dd-1
    x=[x data(i*dd+1:i*dd+dd,1) ];
    y=[y data(i*dd+1:i*dd+dd,2) ];
    z=[z indi(i*dd+1:i*dd+dd) ];
    xip=[xip dataip(i*dd+1:i*dd+dd,1) ];
    yip=[yip dataip(i*dd+1:i*dd+dd,2) ];
    zip=[zip dataip(i*dd+1:i*dd+dd,3) ];
end

figure;
pcolor(x,y,z);
ylabel('y [m]','fontsize',16);
xlabel('x [m]','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
shading flat;
h=colorbar;
title('Original','fontsize',16);
set(h,'fontsize',16,'linewidth',2);
hold on;

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
title('Interp','fontsize',16);
shading flat;
h=colorbar;
set(h,'fontsize',16,'linewidth',2);
hold on;
plot(xm,ym,'k+');
