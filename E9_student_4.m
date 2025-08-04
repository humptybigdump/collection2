%% Exercise 8: Climate analysis of british catchments with the Budyko framework
%% Task 1: Generating Budkyo diagram and plotting the position of one catchment into Budyko diagram
% import hydrological time series of one arbitrary catchment as table (function:
% "readtable"). Simply choose one of the 50 given catchments.
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% saving/assigning precipitation, potential evapotranspiration ('pet'), runoff ('discharge_spec') from
% table to variables/arrays
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% the streamflow time series may contain several NaN values. Use the
% function "isnan" to find the index (=positions/rows) in the streamflow time
% series, where we have actual data and no NaN. 
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% calculating position of catchment in Budyko framework:
% Step 1: calculating actual evapotranspiration by closing water balance
% (cf. exercise 1) assuming constant water storage change over the 45
% years. In the following, use the above defined NaN index to only do the
% calculations with actual data and ignoring rows with NaN.
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Step 2: calculating aridity index of catchment for the entire 45 years (Eq. 1)
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Step 3: calculating evaporative index of catchment for the entire 45 years (Eq. 2)
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% Step 4: plot of budyko framework and position of catchment
figure
% plot of budyko curve with water and energy limits
plot([0:0.1:1], [0:0.1:1]) % line of energy limit
hold on
xlim([0 2])
ylim([0 2])
title('Position of catchment in Budyko framework')
xlabel('aridity index ETP/P')
ylabel('evaporative index ETA/P')
plot([1:0.1:2], ones(1, length([1:0.1:2]))) %line of water limit

hold on
% plot of catchment position in budyko framework
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'


%% Task 2: Plotting the positions of all given catchments automatically into the Budyko framework
% save list of all available files in folder "data", which start with a "C", in a variable  (function:"dir")
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

% open plot of budyko curve and position of catchment. At the end of each
% for-loop run, the position of currently selected catchment will be added
% to this plot
figure
% plot of budyko curve with water and energy limits
plot([0:0.1:1], [0:0.1:1]) % line of energy limit
hold on
xlim([0 2])
ylim([0 2])
title('Position of catchment in Budyko framework')
xlabel('aridity index ETP/P')
ylabel('evaporative index ETA/P')
plot([1:0.1:2], ones(1, length([1:0.1:2]))) %line of water limit

% create for-loop to get hydrological time series data and to calculate position
% in Budyko framework of all given catchments for the entire 45 years, consecutively from first to
% last catchment
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
  % Step 1 in for-loop: at the start of each loop run, save the name of the
  % next catchment file in the previously defined list containing all
  % available files in folder "data"
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
  
  % Step 2 in for-loop: set and save path to this currently selected
  % catchment file in a variable
  % (function: "fullfile")
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

  % Step 3 in for-loop: import hydrological time series of currently selected catchment as table (function:
  % "readtable")
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'

  % Step 4 in for-loop: saving/assigning precipitation, potential
  % evapotranspiration, runoff from this table to variables/arrays. Again,
  % use "isnan" to define index/positions, where we have actual data and no
  % NaN in the streamflow timeseries
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
  
  % Step 5 in for-loop: calculate actual evapotranspiration, aridity index and evaporative
  % index of currently selected catchment for the entire 45 years. Again, use previously defined
  % NaN index to only do the calculations with actual data and no NaN
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
  
  % Step 6 in for-loop: plot position of currently selected catchment into already existing plot of Budyko framework 
  hold on
    'INSERT YOUR CODE FOLLOWING THE COMMENT ABOVE'
  



