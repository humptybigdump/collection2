% Uebung zum Gebietsniederschlag


close all;
clear all;
precdata=dlmread('PREC_GAUGE_COOR.csv', ' ');

punkt_x=1000;
punkt_y=1000;

%Plot Nsummen
figure;
subplot(2,1,1);
h1=bar(precdata(:,1),precdata(:,4));
hold on;
xlabel('Regenschreiber Nummer ','fontsize',16);
ylabel('N_summe [mm]','fontsize',16);
title('Gewitter 27.6.1994 4h ', 'fontsize',16);
set(gca,'fontsize',16,'linewidth',2); 
subplot(2,1,2);
plot(precdata(:,2),precdata(:,3),'bo','linewidth',2);
hold on;
plot(punkt_x,punkt_y,'ro','linewidth',2);

title('Lage der Schreiber', 'fontsize',16);
xlabel('lokale x Koordinate (m)','fontsize',16);
ylabel('lokale y Koordinate (m)','fontsize',16);
set(gca,'fontsize',16,'linewidth',2); 

% gebietsniederschlag aritmetisches Mittel
N_gebiet=mean(precdata(:,4));
N_punkt_ari=mean(precdata(:,4))

% calculate distance
d=zeros(length(precdata(:,1)),1);
for i=1:length(precdata(:,1))
    d(i)=(punkt_x-precdata(i,2))^2+(punkt_y-precdata(i,3))^2;
end
index=sortrows([d precdata(:,1)],1);
weights=index(1:4,:);
norm=0;
for i=1:4
    norm=norm+1/weights(i,1); 
end
N_punkt_idw=0;
for i=1:4
    N_punkt_idw=N_punkt_idw+(1/weights(i,1))*precdata(weights(i,2),4)/norm; 
end
N_punkt_idw


% invers distanze on mesh grid 100 m resolution 
[x, y]=meshgrid(-1000:50:1000, -3000:50:2000);

[m n]=size(x);
N_map_idw=zeros(m ,n);

for i=1:m
    for j=1:n
        d=zeros(length(precdata(:,1)),1);
        for ii=1:length(precdata(:,1))
            d(ii)=(x(i,j)-precdata(ii,2))^2+(y(i,j)-precdata(ii,3))^2;
        end
        index=sortrows([d precdata(:,1)],1);
        weights=index(1:4,:);
        norm=0;
        for i3=1:4
            norm=norm+1/weights(i3,1); 
        end
        for i4=1:4
            N_map_idw(i,j)=N_map_idw(i,j)+(1/weights(i4,1))*precdata(weights(i4,2),4)/norm; 
        end
    end
end


figure;
pcolor(x,y,N_map_idw);
h=colorbar;
set(h, 'fontsize',16);
xlabel('lokale x Koordinate (m)','fontsize',16);
ylabel('lokale y Koordinate (m)','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
shading flat;
title('Interpolierte Niederschlagskarte in mm', 'fontsize',16);
hold on;
plot(precdata(:,2),precdata(:,3),'ko','linewidth',2);

mean_idw=mean(mean(N_map_idw))
var_idw=0;
for i=1:m
    for j=1:n
    var_idw=var_idw+( N_map_idw(i,j)- mean_idw)^2/(m*n-1);
    end
end
var_idw

% dumpx y in coordinate file for kriging
xc=[];
yc=[];
for i=1:n
    xc=[xc;x(:,i)];
    yc=[yc;y(:,i)];
end    
dummy=ones(m*n,1);
np=[1:1:n*m]';

dlmwrite('raster_prec.dat', [np xc yc dummy dummy],' ');

