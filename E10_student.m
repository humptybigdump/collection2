%% Water and Energy Cycles. WS 21/22
% Exercise 10: Calculating evapotranspiration
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
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Structure of lysimeter data file:
% date (dd.mm.yyyy)		
% Precipitation	[mm] P
% Seepage [mm] / groundwater recharge Q
% Storage change [mm] S
% Snowheight [mm]
    
% import lysimeter file
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

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

%% Task 4: Monte Carlo algorithm to calibrate Haude factors 
% number of MC runs
MC_N = 1000;

% define range with randomly distributed scaling factors between an upper and
% lower limit(again, use trial and error to determine suitable upper and
% lower limits)
	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% initialize array for saving RMSE of each MC run
RMSE_runs = zeros(MC_N,1);

for MC_run = 1:MC_N %start of MC loop
    
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
    
    % select next scaling factor out of random distribution (by indexing with "MC_run") and multiply it with the Haude factors
    	'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

    % insert HAUDE equations (Eq. 1 and 2) and calculate ET with the above determined
    % parameters and scaled Haude factors
        'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
    
    % save the RMSE value of each MC run 
        'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
end

% Analyze the MC runs and find the RMSE value and position of the run with lowest RMSE
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'    

% determine the new, calibrated/scaled Haude factors with the scaling factors at the position of the run with lowest RMSE
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

