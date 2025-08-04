%% Water and Energy Cycles. WS 22/23
% Exercise 9: Calculating evapotranspiration
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
% Seepage [mm] / groundwater recharge Q
% Storage change [mm] S
% Snowheight [mm]
    
% import lysimeter file
lysimeter = readtable('./data/lysimeter.csv'); % table containing lysimeter data

%% Task 1: Calculate actual Evapotranspiration ET from the lysimeter data by closing the water balance (0 = P - Q - S - ET)
% Convert water balance (0 = P - Q - S - ET) to calculate ET from observed data
% Seepage = Runoff = Discharge
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% if snow on lysimeter, set actual ET to 0.1 mm at these positions
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% plot actual evapotranspiration time series from lysimeter water balance
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

%% Task 2: Calculate Evapotranspiration using Haude method
% read in the temperature at 14:00 o'clock and air humidity in 2 m height on each day and
% assign them to variables
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% import Haude factors from file and save them to variable (functions "readtable" and
% table2array")
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% create an array containing the respective month number of each date/day in the given data
% time series from table column "month" and then create a second array with the
% respective Haude factors for each month number in each line of the first
% array
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% insert HAUDE equations (Eq. 1 and 2) and calculate ET with the above determined
% parameters and Haude factors
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% plot the evapotranspiration time series of ET lysimeter and ET HAUDE in
% one plot
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% calculate RMSE between ET Haude and actual evapotranspiration
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
    
%% Task 3 : Calculate Evapotranspiration using Turc method
% read the global radiation and the mean air temperature in 2 m height and assign them to variables
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% insert TURC equations (Eq. 3 and 4) and calculate ET Turc with the above
% determined parameters:

% first, determine Turc factors C at each position/date of time series (Eq.
% 4)
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% then, calculate ET Turc with Eq. 3
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% check if there are negative values in the ET Turc time series and replace them with 0
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% delete outliers over 15 mm in the ET Turc time series
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% plot the evapotranspiration time series of actual evapotranspiration and ET TURC in
% one plot
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% calculate RMSE between ET Turc and actual evapotranspiration
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

