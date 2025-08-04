% Routine to analyse extreme values statistics
% Input Anual discharge maxima at gauge sonthofen
% Jahr;HQ;Rang;HQ sortiert
% To explore statistical properties of the mean, from a sampel
close all;
clear all;
% input discharge time series/designflood 
data= readtable('Iller_Extreme_no_header.csv','Delimiter', ';');
% define the runoff column as vector
time= table2array(data(:,{'Year'}));
Q_peak= table2array(data(:,{'Q'}));
Rank= table2array(data(:,{'Rank'}));
Q_sort= table2array(data(:,{'Q_sort'}));


[nline ncol]=size(data);

figure;
subplot(2,1,1);
%plot(time,Q_peak,'r --', 'linewidth',2);
bar(time,Q_peak,'r ');
xlabel( 'Year [-]','fontsize',16);
ylabel( 'Peak discharge [m^3/s]','fontsize',16);
set(gca,'fontsize',16);
title('Annual peak discharge maxima Sonthofen Iller');
subplot(2,1,2);
%plot(Rank,Q_sort,'r --', 'linewidth',2);
bar(Rank,Q_sort,'r ');
xlabel( 'Rank m [-]','fontsize',16);
ylabel( 'Peak discharge sorted [m^3/s]','fontsize',16);
set(gca,'fontsize',16);


c=0;
% compute plotting positions
PP_emp=(Rank-c)/(nline+1-2*c);
RP_emp=1./(1-PP_emp);

%Compute parameter of gumbel distribution
HQ_ave=mean(Q_sort);
HQ_std=std(Q_sort);
% HQ_ave=100;
% HQ_std=5;

Gumbel_a=pi()/(HQ_std*sqrt(6));
Gumbel_b=HQ_ave-0.5772/Gumbel_a;
PP_theo=exp(-exp(-Gumbel_a*(Q_sort-Gumbel_b*ones(nline,1))));
RP_theo=1./(1-PP_theo);

figure;
% histogramm of first sample
subplot(2,1,1);
plot(Q_sort,PP_emp,'o-','linewidth',2);
hold on;
plot(Q_sort,PP_theo,'-','linewidth',2);
xlabel(' HQ [m^3/s]','fontsize',16);
ylabel('Empirical probability ','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
ylim([0 1.1]);
subplot(2,1,2);
plot(Q_sort,RP_emp,'o-','linewidth',2);
hold on;
semilogy(Q_sort,RP_theo,'-','linewidth',2);
xlabel(' HQ [m^3/s]','fontsize',16);
ylabel('Return period','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);
semilogy([0 Q_sort(nline)],[100 100], 'g-','linewidth',2);


figure;
% Perform chi-squared test
% classes
Class_low=[50:50:500]';
Class_high=[100:50:550]';
% Classes for empirical histogramm
subplot(2,1,2);
Class_emp=[75:50:525];
[h_emp x]=hist(Q_sort,Class_emp);
bar(Class_emp,h_emp);
xlabel(' HQ [m^3/s]','fontsize',16);
ylabel('empirical frequency ','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);

% Classes for theoretical histogram
hist1_theo=exp(-exp(-Gumbel_a*(Class_low-Gumbel_b*ones(length(Class_low),1))));
hist2_theo=exp(-exp(-Gumbel_a*(Class_high-Gumbel_b*ones(length(Class_low),1))));
hist_theo=(hist2_theo-hist1_theo)*length(Q_sort);
subplot(2,1,1);
bar(Class_emp,hist_theo);
xlabel(' HQ [m^3/s]','fontsize',16);
ylabel('Theoretical frequency ','fontsize',16);
set(gca,'fontsize',16,'linewidth',2);

% Calculate Chi-square value
Chi_square_emp=sum((hist_theo-h_emp').*(hist_theo-h_emp')./hist_theo);
% Theoretical value for 7 degrees of freedom F= number of classes - number of estimated parameters -1 
Chi_square_theo=chi2inv(0.05,7);

if Chi_square_emp > Chi_square_theo
    title(['Chisquare test not passed ', num2str(Chi_square_emp), ' > ', num2str(Chi_square_theo)]);
elseif Chi_square_emp <= Chi_square_theo
    title(['Chisquare test passed ', num2str(Chi_square_emp), ' < ', num2str(Chi_square_theo)]);
end
bla=1;
