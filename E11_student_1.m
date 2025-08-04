%% Water and Energy Cycles. WS 24/25
% Exercise 11: Calculating evapotranspiration
%% Import data
% Structure of climate data file:
% date (dd.mm.yyyy)	
% LTMI2	mean temperature [°C]
% LT2MAX max temperature [°C]
% LT2MIN min temperature [°C]
% LT14	temperature	at 14:00 o'clock [°C]	
% LF2	air humidity [%] in 2m height	
% LF14	air humidity [%] at 14 o'clock
% GLOBAL global radiation [J/cm²]		
% NIESU	precipitation height [mm]		
% WG2	wind speed [m/s] in 2 m height	
% WG10	wind speed [m/s] in 10 m height

% import climate file
climate = readtable('./data/climate.csv'); % table containing climate data

% Structure of lysimeter data file:
% date (dd.mm.yyyy)		
% Precipitation	[mm] P
% Seepage [mm] / groundwater recharge/runoff Q
% Storage change [mm] S
% Snowheight [mm]
    
% import lysimeter file
lysimeter = readtable('./data/lysimeter.csv'); % table containing lysimeter data

%% Task 1: Calculate actual Evapotranspiration ET from the lysimeter data by closing the water balance (0 = P - Q - S - ET)
% Convert water balance (0 = P - Q - S - ET) to calculate ET from observed data
% Seepage = Runoff = Discharge
    act_ET = 'INSERT YOUR CODE FOLLOWING THE COMMENT'

% if snow on lysimeter, set actual ET to 0.1 mm at these positions
	'INSERT YOUR CODE FOLLOWING THE COMMENT'

% plot actual evapotranspiration time series from lysimeter water balance
figure
plot(lysimeter.('date'),act_ET)
xlabel('time [days]')
ylabel('evapotranspiration [mm]')
ylim([0 max(act_ET)])

%% Task 2: Calculate Evapotranspiration using Haude method
% read in the temperature  and air humidity at 14:00 o'clock in 2 m height on each day and
% assign them to variables
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

% import Haude factors from file and save them to variable (functions "readtable" and
% table2array")
	haude_factor = 'INSERT YOUR CODE FOLLOWING THE COMMENT'

% create an array containing the respective month number of each date/day in the given data
% time series from table column "month" and then create a second array with the
% respective Haude factors for each month number in each line of the first
% array
months = climate.('month');
f = haude_factor(months);

% insert HAUDE equations (Eq. 1 and 2) and calculate ET with the above determined
% parameters and Haude factors
    e_s = 'INSERT YOUR CODE FOLLOWING THE COMMENT (Eq.2)'

    ET_Haude = 'INSERT YOUR CODE FOLLOWING THE COMMENT (Eq.1)'

% plot the evapotranspiration time series of ET lysimeter and ET HAUDE in
% one plot
figure
plot(lysimeter.('date'),act_ET)
xlabel('time [days]')
ylabel('evapotranspiration [mm]')
hold on
plot(lysimeter.('date'), ET_Haude)
ylim([0 max(act_ET)])
legend('act ET','ET Haude')

% calculate RMSE between ET Haude and actual evapotranspiration
    'INSERT YOUR CODE FOLLOWING THE COMMENT'
    
%% Task 3 : Calculate Evapotranspiration using Turc method
% read the global radiation and the mean air temperature in 2 m height and assign them to variables
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

% insert TURC equations (Eq. 3 and 4) and calculate ET Turc with the above
% determined parameters:

% first, determine Turc factors C at each position/date of time series (Eq.
% 4)
C = ones(length(rel_sat),1);
C(rel_sat < 50) = 1 + ((50 - rel_sat(rel_sat < 50)) / 70);

% then, calculate ET Turc with Eq. 3
	ET_Turc = 'INSERT YOUR CODE FOLLOWING THE COMMENT'

% check if there are negative values in the ET Turc time series and replace them with 0
    'INSERT YOUR CODE FOLLOWING THE COMMENT'

% delete outliers over 15 mm in the ET Turc time series
	'INSERT YOUR CODE FOLLOWING THE COMMENT'

% plot the evapotranspiration time series of actual evapotranspiration and ET TURC in
% one plot
figure
plot(lysimeter.('date'),act_ET)
xlabel('time [days]')
ylabel('evapotranspiration [mm]')
hold on
plot(lysimeter.('date'), ET_Turc)
ylim([0 max(act_ET)])
legend('act ET','ET Turc')

% calculate RMSE between ET Turc and actual evapotranspiration
	'INSERT YOUR CODE FOLLOWING THE COMMENT'

