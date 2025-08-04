%% Time series analyis, Part 1. Water and Energy Cycles WS 20/21
% We will work in two catchments one is named Colpach the other Schwebich
% create a string containing the path to the data, folder "data" has to
% be in the same location as this MATLAB script! DON'T RENAME ANY FOLDER,
% SCRIPT OR VARIABLE NAME! 
file_path_colpach = fullfile([pwd '/data'], 'Colpach.txt');
file_path_schwebich = fullfile([pwd '/data'], 'Schwebich.txt');

%% import hydrological time series
% table with all given data
colpach_climate = readtable(file_path_colpach,'Delimiter', ',');
schwebich_climate = readtable(file_path_schwebich,'Delimiter', ',');

% assigning observed runoff given in mm/h (= L/m^2*hr) to variable
colpach_runoff = table2array(colpach_climate(:,{'runoff_mm_h_'}));
schwebich_runoff = table2array(schwebich_climate(:,{'runoff_mm_h_'}));

% assigning observed rainfall given in mm/h (= L/m^2*hr) to variable
colpach_precip = table2array(colpach_climate(:,{'precip_mm_h_'}));
schwebich_precip = table2array(schwebich_climate(:,{'precip_mm_h_'}));

% define the date column as data type date 
format_date = 'yyyy-mm-dd HH:MM:SS';
date_vec = table2array(colpach_climate(:,1));
dn = datetime(date_vec,'InputFormat',format_date); % array containing the dates of time series

%% Task 1: Plot entire time series of precipitation and runoff
figure
subplot(2,1,2)
title('runoff')
    plot('INSERT ARRAY CONTAINING DATES','INSERT OBSERVED RUNOFF IN COLPACH')
hold on
    plot('INSERT ARRAY CONTAINING DATES','INSERT OBSERVED RUNOFF IN SCHWEBICH')
title('runoff')
legend('colpach','schwebich')
ylabel('mm')
xlabel('date')
subplot(2,1,1)
    stairs('INSERT ARRAY CONTAINING DATES','INSERT OBSERVED PRECIPITATION IN COLPACH')                 
hold on
    stairs('INSERT ARRAY CONTAINING DATES','INSERT OBSERVED PRECIPITATION IN SCHWEBICH')
title('precipitation')
legend('colpach','schwebich')
ylabel('mm')
xlabel('date')

%% Task 2: Monthly runoff sums for hydrological year 2013
% selecting hydrological year 
year_begin = datetime(2012, 11, 01, 01, 00, 00); % begin of the time period
year_end = datetime(2013, 10, 31, 23, 00, 00);   % end of the time period
year_idx = isbetween(dn, year_begin, year_end);  % logical index; 1 = value within hydrological year, 0 = value not within hydrological year
% "isbetween" checks each line of the date array "dn" if the respective
% date lies between "year_begin" and "year_end".This "year_idx" can be
% used as index for arrays to extract only the respective data for the
% hydrological year from the entire time series, e.g "data_time_series(year_idx)". 
                                                                                                                                                 
% hourly runoff in colpach and schwebich only for the hydrological year
% 2013 by indexing with "year_idx"
    hourly_runoff_Colpach = 'INSERT RUNOFF COLPACH FOR HYDROLOGICAL YEAR BY INDEXING THE RUNOFF ARRAY WITH THE ABOVE YEAR INDEX'; % all hourly runoff values in hydrological year
    hourly_runoff_Schwebich = 'INSERT RUNOFF SCHWEBICH FOR HYDROLOGICAL YEAR BY INDEXING THE RUNOFF ARRAY WITH THE ABOVE YEAR INDEX';
months = month(dn(year_idx)); % number of month of each runoff value in hydrological year

for i = 1:12
    monthly_runoff_sum_Colpach(i) = sum(hourly_runoff_Colpach(months == i)); % calculate monthly runoff sums
    monthly_runoff_sum_Schwebich(i) = sum(hourly_runoff_Schwebich(months == i));
end

% array "monthly_runoff_sum_Schwebich" is still in a wrong sequence/order
% because the 12 months span over 2 years and the months 11 and 12 are from
% the previous year 2012. So, we have to sort the array by putting the
% months 11 and 12 (from year 2012) to the front and subsequently the
% months 1 to 10 (from year 2013)
sorted_monthly_runoff_sum_Colpach = [monthly_runoff_sum_Colpach(11:12),monthly_runoff_sum_Colpach(1:10)]; % sort sequence of months to obtain values from Nov. 2012 to Oct. 2013
sorted_monthly_runoff_sum_Schwebich = [monthly_runoff_sum_Schwebich(11:12),monthly_runoff_sum_Schwebich(1:10)]; % sort sequence of months to obtain values from Nov. 2012 to Oct. 2013


figure
    bar('INSERT SORTED MONTHLY RUNOFF SUM IN COLPACH','hist')
hold on 
    bar('INSERT SORTED MONTHLY RUNOFF SUM IN SCHWEBICH','r')
title('Monthly runoff sums')
ylabel('runoff sum [mm]')
xlabel('months')
legend('Colpach','Schwebich')
set(gca,'xticklabel',{'Nov. 2012','Dez. 2012','Jan. 2013','Feb. 2013','Mar. 2013','Apr. 2013','May. 2013','Jun. 2013','Jul. 2013','Aug. 2013','Sep. 2013','Oct. 2013'})

%% Task 3: Runoff coefficient
% annual runoff coefficient Colpach and Schwebich 2012/2013; function "sum"
% calculate the yearly sum of runoff and precipitation
    RC_Colpach_2013 = sum('INSERT RUNOFF COLPACH FOR HYDROLOGICAL YEAR BY INDEXING WITH THE ABOVE YEAR INDEX') / sum('INSERT PRECIPITATION COLPACH FOR HYDROLOGICAL YEAR BY INDEXING WITH THE ABOVE YEAR INDEX')
    RC_Schwebich_2013 = sum('INSERT RUNOFF SCHWEBICH FOR HYDROLOGICAL YEAR BY INDEXING WITH THE ABOVE YEAR INDEX') / sum('INSERT PRECIPITATION SCHWEBICH FOR HYDROLOGICAL YEAR BY INDEXING WITH THE ABOVE YEAR INDEX') 

%% Task 4: Water balance and calculation of evapotranspiration ET (0 = P - Q - ET) 
    ET_Colpach_2013 = 'INSERT CALCULATION OF ET FOR THE HYDROLOGICAL YEAR IN COLPACH'
    ET_Schwebich_2013 = 'INSERT CALCULATION OF ET FOR THE HYDROLOGICAL YEAR IN SCHWEBICH'

%% Task 5: Flow duration curve
% sort the runoff data from highest to lowest value ('descend') as well as
% extract the corresponding ranks R of the values.The rank shows for each sorted runoff value its position/index which it had in the "original"
% unsorted array "colpach_runoff(year_idx)".
    [sorted_runoff_colpach, ranks_colpach] = 'INSERT "SORT" FUNCTION IN DESCENDING ORDER WITH RUNOFF IN COLPACH FOR HYDROLOGICAL YEAR';
    [sorted_runoff_schwebich, ranks_schwebich] = 'INSERT "SORT" FUNCTION IN DESCENDING ORDER WITH RUNOFF IN SCHWEBICH FOR HYDROLOGICAL YEAR';

% calculate the exceedance probability (function "length" gives your N = number of observations = length of ranks array)
prob_colpach = 'INSERT EQ.3 FOR COLPACH FROM EXERCISE SHEET'; % calculate exceedance probablity with Eq.3
prob_schwebich = 'INSERT EQ.3 FOR SCHWEBICH FROM EXERCISE SHEET';

sorted_prob_colpach = sort(prob_colpach); % sort the calculated probabilities
sorted_prob_schwebich = sort(prob_schwebich);

% plot flow duration curves
figure
semilogy(sorted_prob_colpach, sorted_runoff_colpach)
hold on 
semilogy(sorted_prob_schwebich, sorted_runoff_schwebich)
xlabel('exceedance probability')
ylabel('runoff [mm/h]')
legend('colpach','schwebich')
title('Flow duration curves hydrological year 2013')

%% Task 6: Double mass curves Eq. 4 and 5
colpach_cumsum_precipitation = 'INSERT EQ.4 USING FUNCTION "CUMSUM" AND "SUM" TO CALCULATE NORMALIZED, CUMULATED SUM OF PRECIPITATION IN COLPACH FOR HYDROLOGICAL YEAR';
colpach_cumsum_runoff = 'INSERT EQ.5 USING FUNCTION "CUMSUM" AND "SUM" TO CALCULATE NORMALIZED, CUMULATED SUM OF RUNOFF IN COLPACH FOR HYDROLOGICAL YEAR';

schwebich_cumsum_precipitation = 'INSERT EQ.4 USING FUNCTION "CUMSUM" AND "SUM" TO CALCULATE NORMALIZED, CUMULATED SUM OF PRECIPITATION IN SCHWEBICH FOR HYDROLOGICAL YEAR';
schwebich_cumsum_runoff = 'INSERT EQ.5 USING FUNCTION "CUMSUM" AND "SUM" TO CALCULATE NORMALIZED, CUMULATED SUM OF RUNOFF IN SCHWEBICH FOR HYDROLOGICAL YEAR';


figure
plot(colpach_cumsum_precipitation, colpach_cumsum_runoff)
hold on
plot(schwebich_cumsum_precipitation,schwebich_cumsum_runoff)
xlim([0 1])
ylim([0 1])
xlabel('normalized, cumulated precipitation')
ylabel('normalized, cumulated runoff')
legend('colpach','schwebich')
title('Double mass curves hydrological year 2013')
