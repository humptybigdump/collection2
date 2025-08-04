%% Conceptual modelling using a HBV model on annual scale and Monte-Carlo calibration, Part 2. Water and Energy Cycles WS 24/25
% We will work in the catchment colpach

% create a string containing the path to the data, folder "data" has to
% be in the same location as this MATLAB script!
file_path_colpach = fullfile([pwd '/data'], 'Colpach.txt');

%% import hydrological time series
% table with all given data
colpach_climate = readtable(file_path_colpach,'Delimiter', ',');

% assigning observed runoff given in mm/h (= L/m^2*hr) to variable
colpach_runoff = table2array(colpach_climate(:,{'runoff_mm_h_'}));

% assigning observed rainfall given in mm/h (= L/m^2*hr) to variable
colpach_precip = table2array(colpach_climate(:,{'precip_mm_h_'}));

% Import of hourly ET values in Colpach for hydrological year 2014 from
% provided "ET_hourly_colpach_2014.mat" file.
% These ET values were previously calculated with the HAUDE method based on temperature und air humidity. Until now, you
% don't have to know this method as we will have an extra exercise on ET
% calculation methods. We just use it here to generate more realistic ET
% values throughout the hydrological year compared to the previous
% assumption of 3 mm each day (cf. exercise 5).

ET_hourly = load('ET_hourly_colpach_2014.mat');
ET_hourly = ET_hourly.ET_hourly;

% define the date column as data type date 
format_date = 'yyyy-mm-dd HH:MM:SS';
date_vec = table2array(colpach_climate(:,1));
dn = datetime(date_vec,'InputFormat',format_date); % array containing only the dates of time series

% select hydrological year 2014 in colpach
    year_begin = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');   % begin runoff year
    year_end = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');     % end runoff year
year_idx = isbetween(dn, year_begin, year_end);  % time range from runoff year

% observed dates, runoff, precipitation , temperature and relative air humidity of selected year
obs_year_runoff = colpach_runoff(year_idx);   
obs_year_precip = colpach_precip(year_idx);
ntime = length(obs_year_runoff);         % length of observed year arrays (each line corresponds to one hour: length of array is duration of year in hours)

%% Task 1: HBV model (beta store and linear reservoir) on annual scale in Colpach. Manual calibration based on NSE and RMSE.

% initializing HBV model
% setting initial values for filling of beta-store Sbeta [mm], the maximum filling of beta-store and the
% beta parameter [-] as input parameters for the HBV model function
% you may use parameter values from the last exercise as initial values for
% calibration
    Sbeta_initial = 'INSERT VALUE FOR INITIAL FILLING OF BETA-STORE Sbeta';           % initial filling of beta-store; can be adjusted!
    Sbeta_max = 0.30 * 1000;          % maximum filling of beta-store (product of soil porosiy and soil depth 1000 mm); stays constant, don't adjust.
    beta =  'INSERT VALUE FOR beta PARAMETER';                   % value of beta parameter; can be adjusted!   

% setting initial values for filling of linear reservoir SLR [mm] and the
% kLR parameter [-] as input parameters for the HBV model function
    SLR_initial = 'INSERT VALUE FOR INITIAL FILLING OF LINEAR RESERVOIR SLR';  % can be adjusted!
    kLR =  'INSERT VALUE FOR kLR PARAMETER';        % can be adjusted!

% The HBV model is now contained in a function, so you just have to select
% the input parameters (mind correct order of input parameters), run the function and you will get the simulated
% runoff out of linear reservoir as output.
% Run HBV model function with the above defined input parameters
% example: function_output = HBV_function(function_input1,
% function_input2,...)
    QLR = HBV_function(ET_hourly, ntime, 'INSERT ARRAY WITH OBSERVED PRECIPITATION IN HYDROLOGICAL YEAR', 'INSERT VALUE OF INITIAL FILLING OF BETA-STORE', 'INSERT MAXIMUM FILLING OF BETA-STORE', 'INSERT BETA PARAMETER', 'INSERT INITIAL FILLING OF LINEAR RESERVOIR', 'INSERT kLR PARAMETER');

% Calculation of NSE and RMSE with Eq. 1 and 2. Check the values of both
% model quality coefficients. Do you have a good match? If not, adjust
% parameters and run the model again!
% NSE
    NSE = 'INSERT CALCULATION OF NSE WITH Eq.1'

%RMSE
    RMSE = 'INSERT CALCULATION OF RMSE WITH Eq.2'

% plot the simulated (QLR) and observed runoff time series
figure
plot(dn(year_idx), obs_year_runoff);              % observed runoff time series
hold on
plot(dn(year_idx), QLR)        % simulated runoff time series
ylim([0, max(obs_year_runoff)*1.4])
title('Comparison of simulated and observed runoff for selected year in colpach (HBV model with beta-store above linear reservoir')
legend('observed','simulated')
xlabel('Date')
ylabel('runoff [mm/h])')

%% Task 2: HBV model (beta store and linear reservoir) on annual scale in Colpach. Automatic calibration with Monte-Carlo (MC) based on NSE and RMSE
% initializing HBV model with Monte-Carlo calibration
% Monte carlo parameters
MC_N = 10000;      % number of total Monte-Carlo iterations

% Step 1: defining arrays containing random values of the respective parameters in
% a predefined range between a lower and upper value limt,
% e.g. "parameter_range = lower_limit + (upper_limit -lower_limit) * rand(1,MC_N)". 
% "rand(1,MC_N)" thereby generates an amount of MC_N
% numbers randomly distributed between 0 and 1. The limits of the parameter
% ranges can be adjusted! Make useful assumptions for the parameter ranges
% based on the values you used in the HBV model of Task 1.
    kLR_range = 'INSERT DEFINITION OF ARRAY CONTAINING RANDOM VALUES OF kLR IN A PREDEFINED RANGE';
    beta_range = 'INSERT DEFINITION OF ARRAY CONTAINING RANDOM VALUES OF beta IN A PREDEFINED RANGE';
    Sbeta_initial_range = 'INSERT DEFINITION OF ARRAY CONTAINING RANDOM VALUES OF Sbeta_initial IN A PREDEFINED RANGE';
    SLR_initial_range = 'INSERT DEFINITION OF ARRAY CONTAINING RANDOM VALUES OF SLR_initial IN A PREDEFINED RANGE';
Sbeta_max = 0.30 * 1000;          % maximum filling of beta-store (product of soil porosiy and soil depth 1000 mm); stays constant, don't adjust!

% defining and preallocating arrays to store the NSE and RMSE and QLR timeseries of each
% Monte-Carlo run
NSE_runs = zeros(1,MC_N);
RMSE_runs = zeros(1,MC_N);
QLR_runs = zeros(length(obs_year_runoff),MC_N);

for MC_run = 1:MC_N % Step 2: start of Monte Carlo loop; the HBV model runs MC_N times

% select new value out of randomly generated arrays for each parameter in
% each Monte-Carlo iteration
    kLR = 'INSERT SELECTION OF A VALUE FOR kLR OUT OF RANDOMLY GENERATED PARAMETER RANGE ARRAY BY INDEXING WITH "MC_N"';
    beta = 'INSERT SELECTION OF A VALUE FOR beta OUT OF RANDOMLY GENERATED PARAMETER RANGE ARRAY BY INDEXING WITH "MC_N"';   
    Sbeta_initial = 'INSERT SELECTION OF A VALUE FOR Sbeta_initial OUT OF RANDOMLY GENERATED PARAMETER RANGE ARRAY BY INDEXING WITH "MC_N"';
    SLR_initial = 'INSERT SELECTION OF A VALUE FOR SLR_initial OUT OF RANDOMLY GENERATED PARAMETER RANGE ARRAY BY INDEXING WITH "MC_N"';

% Run HBV model function with the above defined input parameters
    QLR = HBV_function(ET_hourly, ntime, 'INSERT ARRAY WITH OBSERVED PRECIPITATION IN HYDROLOGICAL YEAR', 'INSERT VALUE OF INITIAL FILLING OF BETA-STORE', 'INSERT MAXIMUM FILLING OF BETA-STORE', 'INSERT BETA PARAMETER', 'INSERT INITIAL FILLING OF LINEAR RESERVOIR', 'INSERT kLR PARAMETER');


% Saving QLR timeseries
QLR_runs(:,MC_run) = QLR;

% Calculation of NSE and RMSE of each Monte-Carlo run with Eq. 1 and 2.
% NSE
NSE_runs(MC_run) = 'INSERT CALCULATION OF NSE WITH Eq.1'

%RMSE
RMSE_runs(MC_run) = 'INSERT CALCULATION OF NSE WITH Eq.2'
end

% Step 3: Analysis of all Monte-Carlo runs. function "max" gives the highest NSE
% value and its position/index in the array "NSE_runs". You already used
% the "max" function in exercise 2.
    'INSERT "max" FUNCTION TO FIND HIGHEST NSE VALUE AND ITS POSITION/INDEX IN ARRAY. ASSIGN THEM TO VARIABLES CALLED "highest_NSE" and "highest_NSE_pos"';

% with this position/index we can now find the corresponding values of the
% calibrated parameters, which produced the best NSE value.
    'INSERT INDEXING OF "kLR_range" ARRAY BY ABOVE DEFINED "highest_NSE_pos" INDEX TO FIND RESPECTIVELY BEST "kLR" value'
    'INSERT INDEXING OF "beta_range" ARRAY BY ABOVE DEFINED "highest_NSE_pos" INDEX TO FIND RESPECTIVELY BEST "beta" value'
    'INSERT INDEXING OF "Sbeta_initial_range" ARRAY BY ABOVE DEFINED "highest_NSE_pos" INDEX TO FIND RESPECTIVELY BEST "Sbeta_initial" value'
    'INSERT INDEXING OF "SLR_initial_range" ARRAY BY ABOVE DEFINED "highest_NSE_pos" INDEX TO FIND RESPECTIVELY BEST "SLR_initial" value'

QLR = QLR_runs(:,highest_NSE_pos);

% plot the best simulated (QLR) and observed runoff time series
figure
plot(dn(year_idx), obs_year_runoff);              % observed runoff time series
hold on
plot(dn(year_idx), QLR)        % simulated runoff time series
ylim([0, max(obs_year_runoff)*1.4])
title('Comparison of best simulated and observed runoff for selected year in colpach (HBV model with beta-store above linear reservoir')
legend('observed','simulated')
xlabel('Date')
ylabel('runoff [mm/h])')
    
% Step 4: Dotty plots for each calibrated parameter. Show the resulting NSE for each randomly generated parameter values.
% One dot for each Monte-Carlo run.
figure
%kLR
subplot(2,2,1)
scatter(kLR_range,NSE_runs)
ylim([0 1])
ylabel('NSE')
xlabel('kLR (-)')

%beta
subplot(2,2,3)
scatter(beta_range,NSE_runs)
ylim([0 1])
ylabel('NSE')
xlabel('beta (-)')

%Sbeta_initial
subplot(2,2,2)
scatter(Sbeta_initial_range,NSE_runs)
ylim([0 1])
ylabel('NSE')
xlabel('initial filling Sbeta (mm)')

%SLR_initial
subplot(2,2,4)
scatter(SLR_initial_range,NSE_runs)
ylim([0 1])
ylabel('NSE')
xlabel('initial filling SLR (mm)')

%% Task 3: Simulation uncertainty
% finding/selecting of all previous Monte-Carlo runs with NSE > 0.80 and saving their
% position/index (function: find)
pos_MC_above_NSE = 'INSERT FINDING OF POSITION OF NSE_runs WITH NSE > 0.8'

% respective NSE values
NSE_runs(pos_MC_above_NSE)

% plotting the respective QLR timeseries of the selected Monte-Carlo runs
% with these positions/index 'pos_MC_above_NSE'. Hint: You may use the
% previous plotting routines and a for-loop.
figure
plot(dn(year_idx), obs_year_runoff);              % observed runoff time series
hold on

   'INSERT FOR-LOOP FOR PLOTTING THESE SIMULATED HYDROGRAPHS IN QLR_runs WITH NSE > 0.8 IN ONE PLOT'
 
ylim([0, max(obs_year_runoff)*1.4])
title('Comparison of simulated hydrographs with NSE > 0.8')
xlabel('Date')
ylabel('runoff [mm/h])')
