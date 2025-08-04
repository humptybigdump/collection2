% To explore statistical properties of the mean, from a sample
%clear all;
close all;
bla=3; % seed for random number generator
nbin=30;% number of class for histogramm
nbin2=10; % number of class for histogramm
my=20; % mean of population
my2=21;
sigma=10; % standard deviation of populuation
ncol=200; % number of samples of size N
randn('seed',bla)
N=10000; % Size of observation within articifial sample/ sample size
sigma2=sigma/sqrt(N); % theoretical standard deviation of means
data1=sigma*randn(N,ncol)+my*ones(N,ncol); % creates matrix with ncol artifial datatsets
%data2=sigma*randn(N,ncol)+my2*ones(N,ncol); % creates matrix with ncol artifial datatsets

% plot histrogramm and pdf ensemble
x1=[0:0.2:40]';
f=1/(sigma*sqrt(2*pi))*exp(-(x1-my*ones(length(x1),1)).*(x1-my*ones(length(x1),1))/(2*sigma^2));
       
figure;
% histogramm of first sample
subplot(2,1,1);
[h1 x]=hist(data1(:,1),nbin);
bar(x,h1/N,1);
hold on;
% plot pdf
plot(x1,f,'r-','linewidth',2);
xlabel(' Soil water content (%VOL)','fontsize',16);
ylabel('h(-)','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
axis([0 40 0 0.4]);
titel=['average= ', num2str(my), ' standard dev. = ',num2str(std(data1(:,1)))];  
title(titel,'fontsize',16); 

% plot histogramm of means
[h2 x2]=hist(mean(data1),nbin2);

subplot(2,1,2);
bar(x2,h2/ncol,1);
xlabel(' Average soil water content%','fontsize',16);
ylabel('h(-)','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
titel=['average= ', num2str(mean(mean(data1))), ' standard dev. = ',num2str(std(mean(data1)))];  
title(titel,'fontsize',16); 
%[h3 x2]=hist(mean(data2),nbin2);
% subplot(3,1,3);
% bar(x2,h3/ncol,1);
% xlabel(' Average soil water content%','fontsize',16);
% ylabel('h(-)','fontsize',16);
% set(gca,'fontsize',16,'linewidth',2);
% titel=['average= ', num2str(mean(mean(data2))), ' standard dev. = ',num2str(std(mean(data1)))];  
% title(titel,'fontsize',16); 

% compute width of 95 percent quantile around the mean 
display ('0.025 and 0.975 quantile');
display ([num2str(quantile(mean(data1),0.025)),' '  num2str(quantile(mean(data1),0.975))]);

display ('sigma_t_h_e_o and standard deviation average')
display([ num2str(std(mean(data1))) , ' ' num2str(sigma/sqrt(N))]);


figure;
boxplot(data1(:,1:200),'notch','on');

