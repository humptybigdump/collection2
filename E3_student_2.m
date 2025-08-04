%% Constant-k method and recession analysis. Water and Energy Cycles WS 23/24
% We will work in two catchments: one is named Colpach, the other Schwebich

% create a string containing the path to the data, folder "data" has to
% be in the same location as this MATLAB script!
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
dn = datetime(date_vec,'InputFormat',format_date); % array containing only the dates of time series
%% Task 1: Constant-k method
% select runoff event period in Schwebich
event_begin = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');   % begin runoff event
event_end = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');     % end runoff event
event_idx = isbetween(dn, event_begin, event_end);  % time range from runoff event

% plot selected runoff event to have a look on it.
figure
subplot(2,1,2)
plot(dn(event_idx), schwebich_runoff(event_idx));              
title('runoff')
xlabel('date')
ylabel('runoff [mm/h]')
subplot(2,1,1)
stairs(dn(event_idx), schwebich_precip(event_idx))              
title('precipitation')
xlabel('date')
ylabel('precipitation [mm/h]')

% Step 1: time derivative of Q (=runoff) (change of Q with time) 
% (hint: use "diff" function; add a zero at the end of the resulting array 
% to maintain original length with "result_array = [diff(event_runoff_values); 0]")
dQ_dt = 'INSERT CALCULATION OF RUNOFF CHANGE BETWEEN TIME STEPS';

% Step 2: conversion of Eq.1 and calculation of k (slope factor describig rate of flow recession after peak [1/h])
k = 'INSERT CALCULATION OF k WITH Eq.1';

% Step 3: smoothing of k values with "movmean" function (hint: use a movmean window
% of 12 hours)
k_movmean = 'INSERT SMMOTHING OF k VALUES';

% Step 4: plot smoothed k values (negative) and event runoff values in one plot
figure
plot(dn(event_idx),k_movmean, 'o')
hold on;
plot(dn(event_idx), schwebich_runoff(event_idx))
line(dn(event_idx), zeros(length(dn(event_idx)),1), 'Color','black')
xlabel('date')
ylabel('runoff/recession rate')
legend('smoothed k values (=recession rate)','runoff')

% Step 5: calculation of gradients between time steps of smoothed k curve in absolute values
%(hint: use "abs" and "diff" function)
k_gradient = 'INSERT CALCULATION OF k GRADIENTS BETWEEN TIME STEPS';

% Step 6: analyzing the slopes of the k curve with the question: On which position
% and date is the gradient of a time step for at least 3 hours close to zero (< 1*10-3) for the first time. 
% At this date, we assume that k becomes constant and hence the runoff event has ended.
% method 1: visual examination of your array "k_gradient"
% method 2: analytical examination (hint: use logical indexing and "movsum"
%           and "find" function), explained in the following:

% use logical indexing to find the k_gradient values smaller than 0.001 (=
% constant gradient)
constant_k_gradient = 'INSERT LOGICAL INDEXING TO FIND k_gradient < 0.001';  

% use function "movsum" to calculate the moving sum of the constant_k_gradient values with a window size of 3
% and then use function "find" to find the positions in this array where the
% moving sum equals 3 (operator: "==") (the first position where the array
% has three ones in a row)
idx_event_end = 'INSERT CALCULATION OF MOVING SUM OF constant_k_gradient AND FIND POSITION WHERE MOVSUM VALUE IS EQUAL TO 3';

% array containing dates of runoff event                                                    
dates_event = dn(event_idx);   

% determine the date within the runoff event (dates_event) at which the
% above condition of constant k gradient appears for the first time (indexing with
% first position of idx_event_end)
end_event_flow = 'INSERT INDEXING OF ARRAY dates_event TO FIND FIRST DATE WHERE k GRADIENT IS CONSTANT'

% plot end point of event runoff
figure
subplot(2,1,2)
plot(dn(event_idx), schwebich_runoff(event_idx));  
hold on;
plot(end_event_flow, schwebich_runoff(schwebich_climate.date == end_event_flow), 'o')
% determine start of event flow (assumption: start when runoff is the first
% time larger than 0.04, really just an assumption for this specific
% example)
start_event_flow = find(schwebich_runoff(event_idx) > 0.04);
% draws line between start and end of event runoff; separates event flow
% and base flow
plot([dates_event(start_event_flow(1)),end_event_flow],[schwebich_runoff(schwebich_climate.date == dates_event(start_event_flow(1))),schwebich_runoff(schwebich_climate.date == end_event_flow)])
title('runoff')
xlabel('date')
ylabel('runoff [mm/hr]')
subplot(2,1,1)
stairs(dn(event_idx), schwebich_precip(event_idx))              
title('precipitation')
xlabel('date')
ylabel('precipitation [mm]')

%% Task 2: Flow recession analysis
% select 3 flow recession periods in Schwebich
% 1. recession phase
recession1_begin_schwebich = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');   % begin flow recession
recession1_end_schwebich = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');     % end flow recession
recession1_idx_schwebich = isbetween(dn, recession1_begin_schwebich, recession1_end_schwebich);  % time range from flow recession

% duration in hours of recession flow (create array from 1 to length of
% recession1_idx_schwebich)
recession1_duration_schwebich = 'INSERT ARRAY FROM 1 TO LENGTH OF dn(recession1_idx_schwebich)';

% 2. recession phase
recession2_begin_schwebich = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');   % begin flow recession
recession2_end_schwebich = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');     % end flow recession
recession2_idx_schwebich = isbetween(dn, recession2_begin_schwebich, recession2_end_schwebich);  % time range from flow recession

% duration in hours of recession flow (array from 1 to length of
% recession2_idx_schwebich)
recession2_duration_schwebich = 'INSERT ARRAY FROM 1 TO LENGTH OF dn(recession2_idx_schwebich)';

% 3. recession phase
recession3_begin_schwebich = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');   % begin flow recession
recession3_end_schwebich = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');     % end flow recession
recession3_idx_schwebich = isbetween(dn, recession3_begin_schwebich, recession3_end_schwebich);  % time range from flow recession

% duration in hours of recession flow (array from 1 to length of
% recession3_idx_schwebich)
recession3_duration_schwebich = 'INSERT ARRAY FROM 1 TO LENGTH OF dn(recession3_idx_schwebich)';

% plot all three recession curves of schwebich in one plot
figure
plot(recession1_duration_schwebich,schwebich_runoff(recession1_idx_schwebich))
hold on
plot(recession2_duration_schwebich,schwebich_runoff(recession2_idx_schwebich))
plot(recession3_duration_schwebich,schwebich_runoff(recession3_idx_schwebich))
legend('recession 1','recession 2','recession 3')
title('Recession flow in Schwebich')
xlabel('duration [h]')
xticks([0:1:24])
ylabel('runoff [mm/h]')
ylim([0 1])

% select 3 flow recession periods in Colpach
% 1. recession phase
recession1_begin_colpach = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');   % begin flow recession
recession1_end_colpach = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');     % end flow recession
recession1_idx_colpach = isbetween(dn, recession1_begin_colpach, recession1_end_colpach);  % time range from flow recession

% duration in hours of recession flow (array from 1 to length of
% recession1_idx_colpach)
recession1_duration_colpach = 'INSERT ARRAY FROM 1 TO LENGTH OF dn(recession1_idx_colpach)';

% 2. recession phase
recession2_begin_colpach = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');   % begin flow recession
recession2_end_colpach = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');     % end flow recession
recession2_idx_colpach = isbetween(dn, recession2_begin_colpach, recession2_end_colpach);  % time range from flow recession

% duration in hours of recession flow (array from 1 to length of
% recession2_idx_colpach)
recession2_duration_colpach = 'INSERT ARRAY FROM 1 TO LENGTH OF dn(recession2_idx_colpach)';

% 3. recession phase
recession3_begin_colpach = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');   % begin flow recession
recession3_end_colpach = datetime('INSERT YEAR', 'INSERT MONTH', 'INSERT DAY', 'INSERT HOUR', 'INSERT MINUTE', 'INSERT SECONDS');     % end flow recession
recession3_idx_colpach = isbetween(dn, recession3_begin_colpach, recession3_end_colpach);  % time range from flow recession

% duration in hours of recession flow (array from 1 to length of
% recession3_idx_colpach)
recession3_duration_colpach = 'INSERT ARRAY FROM 1 TO LENGTH OF dn(recession3_idx_colpach)';

% plot all three recession curves in one plot
figure
plot(recession1_duration_colpach,colpach_runoff(recession1_idx_colpach))
hold on
plot(recession2_duration_colpach,colpach_runoff(recession2_idx_colpach))
plot(recession3_duration_colpach,colpach_runoff(recession3_idx_colpach))
legend('recession 1','recession 2','recession 3')
title('Recession flow in Colpach')
xlabel('duration [h]')
xticks([0:12:144])
ylabel('runoff [mm/h]')

% plot of flow recession curves of both catchments in one figure with same
% scales for comparison
figure
subplot(2,1,1)
hold on;
% Schwebich
plot([1:length(dn(recession1_idx_schwebich))],schwebich_runoff(recession1_idx_schwebich),'-','LineWidth',1.5)
plot([1:length(dn(recession2_idx_schwebich))],schwebich_runoff(recession2_idx_schwebich),'-','LineWidth',1.5)
plot([1:length(dn(recession3_idx_schwebich))],schwebich_runoff(recession3_idx_schwebich),'-','LineWidth',1.5)
legend('recession 1 schwebich','recession 2 schwebich','recession 3 schwebich')
title('Recession flow in Schwebich')
xlabel('duration [h]')
xlim([0 80])
xticks([0:12:80])
ylabel('runoff [mm/h]')
ylim([0 1.4])
subplot(2,1,2)
hold on;
% Colpach
plot([1:length(dn(recession1_idx_colpach))],colpach_runoff(recession1_idx_colpach),'--','LineWidth',1.5)
plot([1:length(dn(recession2_idx_colpach))],colpach_runoff(recession2_idx_colpach),'--','LineWidth',1.5)
plot([1:length(dn(recession3_idx_colpach))],colpach_runoff(recession3_idx_colpach),'--','LineWidth',1.5)
legend('recession 1 colpach','recession 2 colpach','recession 3 colpach')
title('Recession flow in Colpach')
xlabel('duration [h]')
xlim([0 80])
xticks([0:12:80])
ylabel('runoff [mm/h]')
ylim([0 1.4])

%% Task 3: Additional analysis of all recession events in entire time series
% Schwebich
% calculate difference (function: "diff") between runoff values dQ/dt in entire observed time period
    dQ_dt_schwebich = 'INSERT CALCULATION OF DIFFERENCE OF RUNOFF VALUES IN ENTIRE OBSERVED TIME PERIOD';

% from these dQ/dt values, find the positions/index of negative values.
% These positions/index give the recession phases (function: "find")
    pos_recession_phases_schwebich = 'INSERT FINDING OF POSITIONS/INDEX AT WHICH dQ/dt < 0';

% use these positions/index to select the actual runoff values Q(t) of the
% recession phases
    runoff_recession_phases_schwebich = 'INSERT INDEXING OF ACTUAL RUNOFF VALUES IN ENTIRE OBSERVED PERIOD BY USING THE ABOVE DEFINED INDEX pos_recession_phases_schwebich';

% use these positions/index to select the runoff changes dQ/dt of the
% recession phases
    dQ_dt_recession_phases_schwebich = 'INSERT INDEXING OF dQ/dt BY USING THE ABOVE DEFINED INDEX pos_recession_phases_schwebich';

% plot relation of runoff changes dQ/dt and actual runoff values Q(t)of the
% recession phases
figure
    semilogy('INSERT ACTUAL RUNOFF VALUES OF RECESSION PHASES','INSERT dQ/dt VALUES OF RECESSION PHASES AS ABSOLUTE VALUES','ro')
ylim([0.00001, 1])
xlim([0, 2.5])
xlabel('actual runoff values in recession phases (mm/h)')
ylabel('dQ/dt in recession phases (mm)')
title('Relation of runoff change dQ/dt to actual runoff in recession phases of Schwebich')

% Colpach (same as for Schwebich)
    dQ_dt_colpach = 'INSERT CALCULATION OF DIFFERENCE OF RUNOFF VALUES IN ENTIRE OBSERVED TIME PERIOD';
    pos_recession_phases_colpach = 'INSERT FINDING OF POSITIONS/INDEX AT WHICH dQ/dt < 0';

    runoff_recession_phases_colpach = 'INSERT INDEXING OF ACTUAL RUNOFF VALUES IN ENTIRE OBSERVED PERIOD BY USING THE ABOVE DEFINED INDEX pos_recession_phases_colpach';
    dQ_dt_recession_phases_colpach = 'INSERT INDEXING OF dQ/dt BY USING THE ABOVE DEFINED INDEX pos_recession_phases_colpach';

figure
semilogy('INSERT ACTUAL RUNOFF VALUES OF RECESSION PHASES','INSERT dQ/dt VALUES OF RECESSION PHASES AS ABSOLUTE VALUES','bo')
ylim([0.00001, 2.5])
xlim([0, 2.5])
xlabel('actual runoff values in recession phases (mm/h)')
ylabel('dQ/dt in recession phases (mm)')
title('Relation of runoff change dQ/dt to actual runoff in recession phases of  Colpach')