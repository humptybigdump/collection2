% Macro compare random field and Turning band generated field 

close all;
dim=300;
rand('seed',1);

data=load('ks_sphr_0,5_1,5_100.dat'); % structure x y z
dataip=load('ks_tb_sim_a.dat'); % structure x y z
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

% figure;
% pcolor(x,y,z);
% ylabel('y [m]','fontsize',16);
% xlabel('x [m]','fontsize',16);
% set(gca,'fontsize',16,'linewidth',2);
% title('log(ks)','fontsize',16);
% shading flat;
% h=colorbar;
% titel=sprintf('Original. %f5.2',var1);
% title(titel,'fontsize',16);
% set(h,'fontsize',16,'linewidth',2);
% hold on;
% colormap(jet);
im=floor(100*rand(dim,1)+ones(dim,1));
jm=floor(100*rand(dim,1)+ones(dim,1));
xm=zeros(length(im),1);
ym=zeros(length(im),1);
zm=zeros(length(im),1);
zmip=zeros(length(im),1);

for i=1:length(im);
    xm(i)=x(im(i),jm(i));
    ym(i)=y(im(i),jm(i));
    zm(i)=z(im(i),jm(i));
    zmip(i)=zip(im(i),jm(i));
end 
% plot location of measurements
%plot(xm,ym,'k+');

figure;
pcolor(xip,yip,zip);
ylabel('y [m]','fontsize',16);
xlabel('x [m]','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
title('log(ks)','fontsize',16);
titel=sprintf('Simulated. %f5.2',varip);
title(titel,'fontsize',16);
shading flat;
h=colorbar;
colormap(jet);
set(h,'fontsize',16,'linewidth',2);
% hold on;
% plot(xm,ym,'k+');

%   univariate statistics
figure;
%subplot(3,1,1);
[x y]=hist(dataip(:,3));
bar(y, x/length(dataip(:,3)));
titel= ['TB Simulation mean & var' num2str(mean(dataip(:,3))),', ' num2str(std(dataip(:,3))^2)];
title(titel,'fontsize',16);
ylim([0 0.7]);
xlim([-10 0])
set(gca,'fontsize',16,'linewidth',2);
% subplot(3,1,2);
% [x y]=hist(data(:,3));
% bar(y, x/length(data(:,3)));
% titel= ['Virual realty mean & var' num2str(mean(data(:,3))),', ' num2str(std(data(:,3))^2)];
% title(titel,'fontsize',16);
% set(gca,'fontsize',16,'linewidth',2);
% ylim([0 0.7]);
% xlim([-12 0])
% subplot(3,1,3);
% [x y]=hist(zm);
% bar(y, x/length(zm));
% titel= ['Virual observations mean & var' num2str(mean(zm)),', ' num2str(std(zm)^2)];
% title(titel,'fontsize',16);
% set(gca,'fontsize',16,'linewidth',2);
% ylim([0 0.7]);
% xlim([-12 0]);
% 
% Differences and rmse at observation points
% rmse=0;
% diff=zm-zmip;
% for i=1:length(im)
%         rmse=rmse+ (diff(i))^2;
% end
% rmse=sqrt(rmse/length(im)^2)
% 
% figure;
% hist(diff);
% ylabel('frequency [-]','fontsize',20);
% xlabel('Classes','fontsize',16);
% title(['RMSE at observation locations ',num2str(rmse)],'fontsize',16);
% set(gca,'fontsize',20,'linewidth',2);
% xlim([-6 6]);
